# SatelliteSpotter

Augmented Reality iOS App to Show Real Time Satellites in the Sky Above You

# Inspiration

Satellites have a huge impact on our day to day lives- from google maps, to telecommunications, and weather. However, aside from these couple obvious uses, there are a huge number of satellites above us doing incredible things, and most people have no idea!

This app is targeted primarily at education- both for adults and children. Satellites have a significant role to play in scientific development, and it is important to educate the public to encourage broad support for government investment in space technology and innovation.

Some cool things satellites are doing right now:
- Chandra X-Ray Observatory (CXO), owned by the USA, doing x-ray astronomy.
- Eu:CROPIS (Euglena and Combined Regenerative Organic-Food Production in Space), owned by Germany, two greenhouses for experimental growth of food in space, or Mars/Moon.

# Technology

We used Swift and ARKit to work with Augmented Reality in iOS.

We also created a backend server to handle fetching, cleaning, and calculations with the satellite data. The server with built in Node.js with Express, and we used a Postgres database.

We used several open source datasets to retrieve the real time satellite information. NASA has a publicly available API to fetch location, trajectory, and other data about satellites, which can be found at [NasaGov](https://api.nasa.gov/).

# Challenges

Working with ARKit and Swift was incredibly difficult, because none of the team members had worked with either of these technologies before this hackathon. Figuring out how to correctly place the satellite images on the screen was the biggest technological hurdle to overcome. The satellite has coordinate information of latitude, longitude, and altitude, which needed to be translated to an x, y, z coordinate view for a screen. The satellites change as you view different compass directions, so they are actually placed in an approximate real world location, with a modal of a dome hemisphere above the user so lay out the points.
