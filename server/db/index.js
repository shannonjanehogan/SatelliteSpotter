const { Pool } = require("pg");
const fs = require("fs");
require("dotenv").config();

const pool = new Pool({
  host: 'sat-serv-db',
  user: 'postgres',
  password: 'password',
  database: 'satellite-db'
});

pool.on("connect", () => {
  console.log("connected to the db");
});

/**
Database Access Functions for the Command Line
*/
function createTables() {
  const createTablesScript = createTablesScriptString();
  runQuery(createTablesScript);
}

async function selectQuery(queryFile) {
  const dropTablesScript = readFileHelper(queryFile, "queries");
  const result = await runQuery(dropTablesScript);
  return result.rows;
}

/**
Helper Functions
*/
const runQueryWithParams = (queryScript, params) => {
   return pool.query(queryScript, params)
     .then((res) => {
      //  console.log(res);
       return res.rows;
       pool.end();
     })
     .catch((err) => {
       console.log(err);
       return err;
       pool.end();
     });
 }

const runQuery = (queryScript) => {
   return pool.query(queryScript)
     .then((res) => {
      //  console.log(res);
       return res.rows;
       pool.end();
     })
     .catch((err) => {
       console.log(err);
       return err;
       pool.end();
     });
 }

// Returns result of reading the sql file to a string
const readFileHelper = (fileName, folderName) => {
  return fs.readFileSync(`./db/${folderName}/${fileName}.sql`).toString();
}

// Returns a string of all the tables to create, in a specific order so that
// there are no foreign key constraint errors
const createTablesScriptString = () => {
  let scripts = "";

  scripts += readFileHelper('create_tle', 'migrations');
  scripts += readFileHelper('create_satellite', 'migrations');

  return scripts;
}

module.exports = {
  createTables,
  readFileHelper,
  selectQuery,
  runQuery,
  runQueryWithParams
};

require("make-runnable");
