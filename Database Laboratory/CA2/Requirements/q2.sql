CREATE TABLE Person (
    email CHAR(255),
    person_name CHAR(255),
    about TEXT,
);


CREATE TABLE Director (
    email CHAR(255),
    PRIMARY KEY(email),
    FOREIGN KEY(email) REFERENCES Person(email) ON DELETE CASCADE,
);

CREATE TABLE Customer (
    email CHAR(255),
    about TEXT,
    credit INTEGER,
    PRIMARY KEY(email),
    FOREIGN KEY(email) REFERENCES Person(email) ON DELETE CASCADE,
);

CREATE TABLE Reviewer (
    email CHAR(255),
    about TEXT,
    credit INTEGER,
    reputation INTEGER,
    PRIMARY KEY(email),
    FOREIGN KEY(email) REFERENCES Person(email) ON DELETE CASCADE,
);

CREATE TABLE Movie (
    title CHAR(255),
    release_year DATE,
    director CHAR(255) NOT NULL,
    budget INT,
    summary TEXT,
    PRIMARY KEY(title),
    FOREIGN KEY(director) REFERENCES Director(email) ON DELETE NO ACTION,

);

CREATE TABLE Review (
    review_id INT,
    author CHAR(255),
    movie CHAR(255),
    rating INT,
    review_date DATE,
    review_text TEXT,
    PRIMARY KEY(review_id,author,movie),
    FOREIGN KEY(author) REFERENCES Reviewer(email) ON DELETE CASCADE,
    FOREIGN KEY(movie) REFERENCES Movie(title) ON DELETE CASCADE,
);

CREATE TABLE Review_replies (
    reply_id INT,
    review_id INT,
    author CHAR(255),
    movie CHAR(255),
    reply_date DATE,
    reply_text TEXT,
    PRIMARY KEY(reply_id,review_id,author,movie),
    FOREIGN KEY(author) REFERENCES Reviewer(email) ON DELETE CASCADE,
    FOREIGN KEY(movie) REFERENCES Movie(title) ON DELETE CASCADE,
    FOREIGN KEY(review_id) REFERENCES Review(review_id) ON DELETE CASCADE,
);


CREATE TABLE Rent(
    renter CHAR(255),
    movie CHAR(255),
    rent_date DATE,
    PRIMARY KEY(renter,movie),
    FOREIGN KEY(renter) REFERENCES Customer(email) ON DELETE CASCADE,
    FOREIGN KEY(movie) REFERENCES Movie(title) ON DELETE CASCADE,
);
