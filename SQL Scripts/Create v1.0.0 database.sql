CREATE TABLE IF NOT EXISTS Version (
	CurrentVersion	TEXT NOT NULL
);
INSERT INTO Version VALUES ('1.0.0');

CREATE TABLE IF NOT EXISTS Setting (
	Distance			INTEGER	DEFAULT 1,
	Quantity			INTEGER	DEFAULT 1,
	Currency			INTEGER DEFAULT 1,
	DefaultToFilledTank	INTEGER	DEFAULT 1
);

CREATE TABLE IF NOT EXISTS FuelTransaction (
	Date				INTEGER,
	Distance			INTEGER,
	Odometer			INTEGER,
	Quantity			INTEGER,
	FuelEconomy			INTEGER,
	PricePerQuantity	INTEGER,
	FuelCost			INTEGER,
	FilledTank			INTEGER,
	Location			TEXT,
	Pump				TEXT
);
