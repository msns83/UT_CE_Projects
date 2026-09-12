DROP TABLE IF EXISTS WatchHistoryItem, WatchListItem, VideoReaction, CommentReaction,
                     Comment, Video, Season, Series, Cinematic, Participation,
                     Crew, Film, wUser, Account, SubscriptionPlan;

CREATE TABLE SubscriptionPlan (
    sub_id INTEGER,
    title VARCHAR(30) NOT NULL,
    cost INTEGER NOT NULL,
    duration INTEGER NOT NULL,
    PRIMARY KEY (sub_id)
);

CREATE TABLE Account (
    aid INTEGER,
    phone CHAR(11) NOT NULL,
    create_at DATE NOT NULL,

    sub_id INTEGER,
    start_date DATE,
    end_date DATE,

    UNIQUE (phone),

    PRIMARY KEY (aid),
    FOREIGN KEY (sub_id) REFERENCES SubscriptionPlan(sub_id) ON DELETE SET DEFAULT ON UPDATE CASCADE
);

CREATE TABLE wUser (
    uid INTEGER,
    username VARCHAR(30) NOT NULL,
    create_at DATE NOT NULL,

    aid INTEGER,

    UNIQUE (username),

    PRIMARY KEY (uid),
    FOREIGN KEY (aid) REFERENCES Account(aid) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Film (
    fid INTEGER,
    title VARCHAR(30) NOT NULL,
    genre VARCHAR(30),
    creator_country VARCHAR(30),
    language VARCHAR(30),

    PRIMARY KEY (fid)
);

CREATE TABLE Crew (
    cid INTEGER,
    name VARCHAR(30) NOT NULL,
    age INTEGER,
    description TEXT,

    PRIMARY KEY (cid)
);

CREATE TABLE Participation (
    fid INTEGER,
    cid INTEGER,
    role VARCHAR(30),

    PRIMARY KEY (fid, cid, role),
    FOREIGN KEY (fid) REFERENCES Film(fid) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (cid) REFERENCES Crew(cid) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Cinematic (
    summary TEXT,
    release_year DATE,

    fid INTEGER,

    PRIMARY KEY (fid),
    FOREIGN KEY (fid) REFERENCES Film(fid) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Series (
    num_of_seasons INTEGER,

    fid INTEGER,

    PRIMARY KEY (fid),
    FOREIGN KEY (fid) REFERENCES Film(fid) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Season (
    sea_id INTEGER,
    release_year DATE,
    summary TEXT,
    num_of_episodes INTEGER,

    fid INTEGER,

    PRIMARY KEY (sea_id),
    FOREIGN KEY (fid) REFERENCES Series(fid) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Video (
    vid INTEGER,
    create_at DATE,
    is_dubbed BOOLEAN,
    is_subtitled BOOLEAN,
    duration INTEGER,
    like_rate INTEGER,
    storage_path TEXT NOT NULL,
    description TEXT,

    cin_id INTEGER NULL, 
    sea_id INTEGER NULL,

    PRIMARY KEY (vid),
    FOREIGN KEY (cin_id) REFERENCES Cinematic(fid) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (sea_id) REFERENCES Season(sea_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Comment (
    comm_id INTEGER,
    comment_text TEXT,
    create_at DATE,

    uid INTEGER,
    fid INTEGER,

    PRIMARY KEY (comm_id),
    FOREIGN KEY (uid) REFERENCES wUser(uid) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (fid) REFERENCES Film(fid) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE CommentReaction (
    reaction_type VARCHAR(30),
    create_at DATE,

    uid INTEGER,
    comm_id INTEGER,

    PRIMARY KEY (uid, comm_id),
    FOREIGN KEY (uid) REFERENCES wUser(uid) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (comm_id) REFERENCES Comment(comm_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE VideoReaction (
    reaction_type VARCHAR(30),
    create_at DATE,

    uid INTEGER,
    vid INTEGER,

    PRIMARY KEY (uid, vid),
    FOREIGN KEY (uid) REFERENCES wUser(uid) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (vid) REFERENCES Video(vid) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE WatchListItem(
    create_at DATE,

    uid INTEGER,
    fid INTEGER,

    PRIMARY KEY (uid, fid),
    FOREIGN KEY (uid) REFERENCES wUser(uid) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (fid) REFERENCES Film(fid) ON DELETE SET DEFAULT ON UPDATE CASCADE
);

CREATE TABLE WatchHistoryItem(
    create_at DATE,

    uid INTEGER,
    fid INTEGER,

    PRIMARY KEY (uid, fid),
    FOREIGN KEY (uid) REFERENCES wUser(uid) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (fid) REFERENCES Film(fid) ON DELETE SET DEFAULT ON UPDATE CASCADE
);