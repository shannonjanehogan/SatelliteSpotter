const express = require('express')
const axios = require('axios');
const tle = require('tle.js');
const database = require('./db/index.js');
const app = express()
const port = 3000

const stubbedData = [{
  // satellite compass heading from observer in degrees (0 = north, 180 = south)
  azimuth: 294.5780478624994,
  // satellite elevation from observer in degrees (90 is directly overhead)
  elevation: 81.63903620330046,
  // km distance from observer to spacecraft
  range: 406.60211015810074,
  // spacecraft altitude in km
  height: 402.9082788620108,
  // spacecraft latitude in degrees
  lat: 34.45112876592785,
  // spacecraft longitude in degrees
  lng: -117.46176597710809,
  // spacecraft velocity (relative to observer) in km/s
  velocity: 7.675627442183371,
  noradId: 4247,
},
{
  // satellite compass heading from observer in degrees (0 = north, 180 = south)
  azimuth: 294.5780478624994,
  // satellite elevation from observer in degrees (90 is directly overhead)
  elevation: 81.63903620330046,
  // km distance from observer to spacecraft
  range: 406.60211015810074,
  // spacecraft altitude in km
  height: 402.9082788620108,
  // spacecraft latitude in degrees
  lat: 34.45112876592785,
  // spacecraft longitude in degrees
  lng: -117.46176597710809,
  // spacecraft velocity (relative to observer) in km/s
  velocity: 7.675627442183371,
  noradId: 4247,
},
{
  // satellite compass heading from observer in degrees (0 = north, 180 = south)
  azimuth: 294.5780478624994,
  // satellite elevation from observer in degrees (90 is directly overhead)
  elevation: 81.63903620330046,
  // km distance from observer to spacecraft
  range: 406.60211015810074,
  // spacecraft altitude in km
  height: 402.9082788620108,
  // spacecraft latitude in degrees
  lat: 34.45112876592785,
  // spacecraft longitude in degrees
  lng: -117.46176597710809,
  // spacecraft velocity (relative to observer) in km/s
  velocity: 7.675627442183371,
  noradId: 4247,
}];

app.get('/', function (req, res) {
  res.send(stubbedData);
});

app.get('/test', function (req, res) {
  getSatellites(49.2827, 123.1207, 0.5);
  res.send(501);
});

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
      const params = [
        arr.line1 + arr.line2,
        Date.now()
      ];
      await database.runQueryWithParams(sql, params);
    }
    currPage++;
    if (response.data.view.next == response.data.view.last) {
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

async function getSatellites(lat, lon, elevation) {
  try {
    const sql = database.readFileHelper('select_tle', 'queries');
    const result = await database.runQuery(sql);
    let responseArray = [];
    const allVisible = getVisibleSatellites({
      observerLat: lat,
      observerLng: lon,
      observerHeight: 0,
      // Array of 3-line TLE arrays.
      tles: row.tleval,
      elevationThreshold: elevation,
      timestampMS: row.fetchTime
    });
    return allVisible;
  } catch (error) {
    console.error(error);
  }
}

app.listen(port, () => console.log(`Example app listening on port ${port}!`))
