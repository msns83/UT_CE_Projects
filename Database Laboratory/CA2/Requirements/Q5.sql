CREATE TABLE Customers (
    cid INT,
    phone CHAR(11),
    cname VARCHAR(30),
    PRIMARY KEY (cid)
) ENGINE=InnoDB;

CREATE TABLE Students (
    cid INT,
    sid INT,
    univ VARCHAR(100),
    discount VARCHAR(30),
    UNIQUE (sid),
    PRIMARY KEY (cid),
    FOREIGN KEY (cid) REFERENCES Customers(cid) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE Admins (
    aid INT,
    arole VARCHAR(30),
    aname VARCHAR(30),
    salary INT,
    PRIMARY KEY (aid)
) ENGINE=InnoDB;

CREATE TABLE Servers (
    serid INT,
    model VARCHAR(30),
    sversion INT,
    producer VARCHAR(30),
    aid INT,
    verify_status VARCHAR(30),
    PRIMARY KEY (serid),
    FOREIGN KEY (aid) REFERENCES Admins(aid) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB;

CREATE TABLE Virtuals(
    serid INT,
    price INT,
    usage_date DATETIME,
    use_type VARCHAR(30),
    cid INT,
    PRIMARY KEY (serid),
    FOREIGN KEY (serid) REFERENCES Servers(serid) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (cid) REFERENCES Customers(cid) ON DELETE NO ACTION
) ENGINE=InnoDB;

CREATE TABLE Privates (
    serid INT,
    price INT,
    PRIMARY KEY (serid),
    FOREIGN KEY (serid) REFERENCES Servers(serid) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE Rates (
    cid INT,
    serid INT,
    rate INT,
    PRIMARY KEY (cid, serid),
    FOREIGN KEY (serid) REFERENCES Servers(serid) ON DELETE NO ACTION,
    FOREIGN KEY (cid) REFERENCES Customers(cid) ON DELETE NO ACTION
) ENGINE=InnoDB;

CREATE TABLE Orders (
    date DATETIME,
    oid INT,
    icost INT,
    cost INT,
    cid INT,
    serid INT,
    PRIMARY KEY (oid, cid, serid),
    FOREIGN KEY (cid) REFERENCES Customers(cid) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (serid) REFERENCES Privates(serid) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

INSERT INTO Admins (aid, arole, aname, salary) VALUES
(1, 'senior', 'Ali Reza', 60000),
(2, 'junior', 'Sara Karimi', 48000);

INSERT INTO Customers (cid, phone, cname) VALUES
(1, '09121234567', 'Mohammad Hosseini'),
(2, '09129876543', 'Neda Azimi');

INSERT INTO Students (cid, sid, univ, discount) VALUES
(1, 101, 'Tehran Univ', '10%');

INSERT INTO Servers (serid, model, sversion, producer, aid, verify_status) VALUES
(1, 'S1', 2, 'Dell', 1, 'approved'),
(2, 'S2', 1, 'Lenovo', 2, 'pending'),
(3, 'S3', 2, 'Microsoft', 2, 'pending');

INSERT INTO Virtuals (serid, price, usage_date, use_type, cid) VALUES
(2, 15, '2025-10-10 09:00:00', 'downloaded', 1);

INSERT INTO Privates (serid, price) VALUES
(1, 2500),
(3, 3500);

INSERT INTO Rates (cid, serid, rate) VALUES
(1, 1, 5),
(2, 2, 4);

INSERT INTO Orders (date, oid, icost, cost, cid, serid) VALUES
('2025-10-01', 1, 100, 2600, 1, 1),
('2025-10-02', 2, 80, 1580, 2, 3);


SELECT s.* 
FROM Servers s
JOIN Admins a ON s.aid = a.aid
WHERE a.aname = 'Ali Reza';

SELECT * 
FROM Orders
WHERE cid = 1;

SELECT v.*, c.cname
FROM Virtuals v
JOIN Customers c ON v.cid = c.cid;

SELECT r.*, c.cname, s.model
FROM Rates r
JOIN Customers c ON r.cid = c.cid
JOIN Servers s ON r.serid = s.serid;

SELECT c.cname, s.univ, s.discount
FROM Students s
JOIN Customers c ON s.cid = c.cid;