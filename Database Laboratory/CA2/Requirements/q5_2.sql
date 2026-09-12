CREATE TABLE Customer (
  CID INTEGER,
  name_ TEXT,
  contact_info TEXT,
  PRIMARY KEY (CID)
);

CREATE TABLE UniStudent (
  StudentID INTEGER,
  University TEXT,
  Discount TEXT,
  PRIMARY KEY (CID),
  FOREIGN KEY (CID) REFERENCES Customer (CID) ON DELETE CASCADE
);

CREATE TABLE Admin_ (
  ADID INTEGER,
  name_ TEXT,
  Role_ TEXT,
  Salary TEXT,
  PRIMARY KEY (ADID)
);

CREATE TABLE Server_ (
  server_id INTEGER,
  server_model TEXT,
  company TEXT,
  PRIMARY KEY (server_id),
  FOREIGN KEY (ADID) REFERENCES Admin_ (ADID) ON DELETE NO ACTION
);

CREATE TABLE Review (
  CID INTEGER,
  server_id INTEGER,
  rating FLOAT,
  PRIMARY KEY (server_id, CID),
  FOREIGN KEY (server_id) REFERENCES Server_(server_id),
  FOREIGN KEY (CID) REFERENCES Customer (CID)
);


CREATE TABLE virtual_server (
  vip_order_id INTEGER,
  Installation_Price FLOAT,
  server_id INTEGER,
  Total_Price FLOAT,
  PRIMARY KEY (server_id,vip_order_id),
  FOREIGN KEY (server_id) REFERENCES server_ (server_id) ON DELETE CASCADE
);

CREATE TABLE vip_server (
  server_id INTEGER,
  Price FLOAT,
  PRIMARY KEY (server_id),
  FOREIGN KEY (server_id) REFERENCES server_ (server_id) ON DELETE CASCADE
);

CREATE TABLE virtual_Order (
  server_id INTEGER,
  CID INTEGER,
  Date_ date,
  PRIMARY KEY (server_id, CID),
  FOREIGN KEY (BID) REFERENCES virtual_server (server_id),
  FOREIGN KEY (CID) REFERENCES Customer (CID)
);


CREATE TABLE vip_Order (
  server_id INTEGER,
  OID_ INTEGER,
  CID INTEGER,
  Date_ date,
  PRIMARY KEY (server_id, OID_, CID),
  FOREIGN KEY (server_id) REFERENCES virtual_Order (server_id),
  FOREIGN KEY (CID) REFERENCES Customer (CID) ON DELETE CASCADE
);
