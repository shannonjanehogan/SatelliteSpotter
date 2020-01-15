FROM node:10
WORKDIR <add dir here>
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 3000
CMD ["node", "db/index.js", " createTables"]
CMD ["node", "app.js"]
