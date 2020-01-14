# A node docker image with SatelliteSpotter
# Specify the path to the server directory at WORKDIR below
FROM node:10
WORKDIR <path-to-server-directory>
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 3000
CMD ["node", "db/index.js", " createTables"]
CMD ["node", "app.js"]
