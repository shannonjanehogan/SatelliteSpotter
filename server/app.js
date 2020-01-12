const express = require('express')
const axios = require('axios');
const tle = require('tle.js');
const database = require('./db/index.js');
const app = express()
const port = 3000

app.get('/', function (req, res) {
  res.send('SatelliteSpotter is up and running!');
});

// Returns all the satellites visible from the users location
app.get('/satellites', async function (req, res) {
  const result = await getVisibleSatellites(req.query.lat, req.query.lon);
  res.send(result);
});

// Does a large fetch for all satellites in space, getting their current info and trajectory
// Needs to be run daily
app.get('/tles', function (req, res) {
  getDailyTLEs();
  res.sendStatus(200);
});

async function getDailyTLEs() {
  let lastPage = false;
  let currPage = 1;
  const sql = database.readFileHelper('insert_tle', 'queries');
  while (!lastPage) {
    const response = await axios.get(`http://data.ivanstanojevic.me/api/tle?page-size=100&page=${currPage}`);
    const arr = response.data.member;
    for (i = 0; i < arr.length; i++) {
      let satellite = arr[i];
      let tle = satellite.line1 + "\n" + satellite.line2;
      const params = [
        tle,
        Date.now()
      ];
      await database.runQueryWithParams(sql, params);
    }
    currPage++;
    if (response.data.view.next === response.data.view.last) {
      lastPage = true;
    }
  }
  const lastResponse = await axios.get(`http://data.ivanstanojevic.me/api/tle?page-size=100&page=${currPage}`);
  const lastArr = response.data.member;
  for (i = 0; i < lastArr.length; i++) {
    let satellite = lastArr[i];
    const params = [
      lastArr.line1 + lastArr.line2,
      Date.now()
    ];
    await database.runQueryWithParams(sql, params);
  };
}

async function getVisibleSatellites(lat, lon) {
  const sql = database.readFileHelper('select_tle', 'queries');
  const result = await database.runQuery(sql);
  const nearSatellites = [];

  for (i = 0; i < result.length; i++) {
    const tleObj = result[i];
    let error = false;
    let satInfo = {};
    let norad;
    try {
      satInfo = tle.getSatelliteInfo(
        tleObj.tleval,         // Satellite TLE string or array.
        tleObj.fetchTime,  // Timestamp (ms)
        lat,                // Observer latitude (degrees)
        lon,              // Observer longitude (degrees)
        0               // Observer elevation (km)
      );
      norad = tle.getCatalogNumber(tleObj.tleval);
    } catch {
      error = true;
    }
    if (!error) {
      if (satInfo.elevation > 45) {
        const fetchSql = database.readFileHelper('select_satellite', 'queries');
        const params = [norad];
        const satelliteResult = await database.runQueryWithParams(fetchSql, params);

        if (satelliteResult && satelliteResult.length) {
          satInfo.name = satelliteResult[0].satname || "N/A";
          satInfo.comments = satelliteResult[0].miscellaneous || "N/A";
          satInfo.launchVehicle = satelliteResult[0].launchvehicle || "N/A";
          satInfo.dateOfLaunch = satelliteResult[0].dateoflaunch || "N/A";
          satInfo.expectedLifetime = satelliteResult[0].expectedlifetime || "N/A";
          satInfo.users = satelliteResult[0].users || "N/A";
          satInfo.countryOfOrigin = satelliteResult[0].countryoforigin || "N/A";
          satInfo.satOwner = satelliteResult[0].satowner || "N/A";
          satInfo.noradId = norad;
          satInfo.tle = tleObj.tleval;
          nearSatellites.push(satInfo);
        }
        // } else {
        //   satInfo.name = null;
        //   satInfo.countryOfOrigin = null;
        //   satInfo.satOwner = null;
        //   satInfo.comments = null;
        //   satInfo.launchVehicle = null;
        //   satInfo.dateOfLaunch = null;
        //   satInfo.expectedLifetime = null;
        //   satInfo.users = null;
        // }
        // satInfo.noradId = norad;
        // satInfo.tle = tleObj.tleval;
        // nearSatellites.push(satInfo);
      }
    }
  }
  console.log("END RESULT", nearSatellites);
  return nearSatellites;
}

app.listen(port, () => console.log(`Example app listening on port ${port}!`))
