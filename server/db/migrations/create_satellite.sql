DROP TABLE IF EXISTS Satellite;

CREATE TABLE Satellite (
	satName varchar,
	countryOfOrigin varchar,
	satOwner varchar,
	users varchar,
	orbitClass varchar,
	orbitType varchar,
	perigee DOUBLE PRECISION,
	apogee DOUBLE PRECISION,
	eccentricity DOUBLE PRECISION,
	inclination DOUBLE PRECISION,
	launchMass int,
	dateOfLaunch DATE,
	expectedLifetime int,
	contractor varchar,
	launchSite varchar,
	launchVehicle varchar,
	noradNumber int NOT NULL,
	miscellaneous varchar,
	PRIMARY KEY (noradNumber)
);
