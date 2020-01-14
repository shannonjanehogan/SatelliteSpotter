DROP TABLE IF EXISTS tle;
CREATE TABLE tle (
	tleval varchar NOT NULL,
  fetchTime bigint NOT NULL,
  uuid serial PRIMARY KEY
);
