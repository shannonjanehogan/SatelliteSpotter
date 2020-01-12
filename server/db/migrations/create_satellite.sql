CREATE TABLE Satellite (
	satName varchar,
	countryOfOrigin varchar,
	operatingCountry varchar,
	satOwner varchar,
	users varchar,
	purpose varchar,
	detailedPurpose varchar,
	orbitClass varchar,
	orbitType varchar,
	longitude float,
	perigee int,
	apogee int,
	eccentricity DOUBLE PRECISION,
	inclination float,
	minutes float,
	launchMass float,
	dryMass float,
	dateOfLaunch DATE,
	expectedLifetime int,
	contractor varchar,
	countryOfContractor varchar,
	launchSite varchar,
	launchVehicle varchar,
	noradNumber int NOT NULL,
	miscellaneous varchar,
	infoSource varchar,
	source varchar,
	source2 varchar,
	source3 varchar,
	source4 varchar,
	PRIMARY KEY (noradNumber)
);