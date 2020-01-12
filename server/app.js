const express = require('express')
const axios = require('axios');
const tle = require('tle.js')
const app = express()
const port = 3000

const TLEArray = [];
const lastFetched = Date.now();

const stubbedData = {
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

  satName: "Name12",

  dateLaunched: new Date(),

  comments: "string of stuff",

  countryOwner: "United States",

  launchVehicle: "example",

  mass: 123.00,

  launchMass: 400.00,

  expectedLifetime: new Date(),
}

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
  while (!lastPage) {
    const response = await axios.get(`http://data.ivanstanojevic.me/api/tle?page-size=100&page=${currPage}`);
    const arr = response.data.member;
    arr.forEach(satellite => {
      const sat = {
        noradId: arr.satelliteId,
        tle: arr.line1 + arr.line2,
      }
      TLEArray.push(sat);
    });
    currPage++;
    if (response.data.view.next == response.data.view.last) {
      lastPage = true;
    }
  }
  const lastResponse = await axios.get(`http://data.ivanstanojevic.me/api/tle?page-size=100&page=${currPage}`);
  TLEArray.push(lastResponse.data.member);
}

async function getSatellites(lat, lon, elevation) {
  try {
    // For each response, get the noradId and the TLE numbers
    const satInfo = tle.getSatelliteInfo(
      "1 25544U 98067A   18077.09047010  .00001878  00000-0  35621-4 0  9999\r\n2 25544  51.6412 112.8495 0001928 208.4187 178.9720 15.54106440104358",         // Satellite TLE string or array.
      1501039265000,  // Timestamp (ms)
      lat,        // Observer latitude (degrees)
      lon,        // Observer longitude (degrees)
      elevation   // Observer elevation (km)
    );
    console.log('the sat info', satInfo);
    // Determine if should be included on list depending on lat/long returned
  } catch (error) {
    console.error(error);
  }
}

app.listen(port, () => console.log(`Example app listening on port ${port}!`))
