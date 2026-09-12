-- MySQL dump 10.13  Distrib 8.0.41, for Win64 (x86_64)
--
-- Host: localhost    Database: filimo
-- ------------------------------------------------------
-- Server version	8.0.41












--
-- Table structure for table account
--

DROP TABLE IF EXISTS account;


CREATE TABLE account (
  aid int NOT NULL,
  phone char(11) NOT NULL,
  create_at date NOT NULL,
  sub_id int DEFAULT NULL,
  start_date date DEFAULT NULL,
  end_date date DEFAULT NULL,
  PRIMARY KEY (aid),
  UNIQUE (phone)
);

--
-- Dumping data for table account
--



INSERT INTO account VALUES (1,'09354178363','2026-05-01',1,'2026-05-01','2026-05-08'),(2,'09926505372','2026-05-01',2,'2026-05-01','2026-06-01'),(3,'09124791247','2026-05-01',3,'2026-05-01','2027-05-01'),(4,'09112223344','2025-06-11',2,'2025-06-11','2025-07-11'),(5,'09335557788','2025-08-19',3,'2025-08-19','2026-08-19'),(6,'09998887766','2026-01-09',1,'2026-01-09','2026-01-16'),(7,'09001112233','2026-02-01',2,'2026-02-01','2026-03-01'),(8,'09224446688','2026-03-13',3,'2026-03-13','2027-03-13');



--
-- Table structure for table cinematic
--

DROP TABLE IF EXISTS cinematic;


CREATE TABLE cinematic (
  summary text,
  release_year date DEFAULT NULL,
  fid int NOT NULL,
  PRIMARY KEY (fid)
);

--
-- Dumping data for table cinematic
--



INSERT INTO cinematic VALUES ('Story of J. Robert Oppenheimer.','2023-07-21',10),('The life story of a simple man from Alabama.','1994-07-06',11),('Two imprisoned men bond over a number of years.','1994-09-22',12),('A slave turned bounty hunter rescues his wife.','2012-12-25',13),('Origin story of the Batman villain.','2019-10-04',14),('Alan Turing cracks the Enigma code.','2014-11-28',15),('When Earth becomes uninhabitable in the future, a farmer and ex-NASA pilot, Joseph Cooper, is tasked to pilot a spacecraft, along with a team of researchers, to find a new planet for humans..','2014-10-26',16),('With his impeccable vocal abilities, Freddie Mercury and his rock band, Queen, achieve superstardom.','2018-10-24',17),('Paul Edgecomb, the head guard of a prison, meets an inmate, John Coffey, a black man who is accused of murdering two girls. His life changes drastically when he discovers that John has a special gift.','1999-12-06',18);



--
-- Table structure for table comment
--

DROP TABLE IF EXISTS comment;


CREATE TABLE comment (
  comm_id int NOT NULL,
  comment_text text,
  create_at date DEFAULT NULL,
  uid int DEFAULT NULL,
  fid int DEFAULT NULL,
  PRIMARY KEY (comm_id)
);

--
-- Dumping data for table comment
--



INSERT INTO comment VALUES (1,'An absolute masterpiece by Nolan. The sound design is incredible.','2023-08-01',1,10),(2,'Cillian Murphy deserves all the awards for this performance.','2023-08-05',2,10),(3,'A bit too long for my taste, but still a solid movie.','2023-08-10',4,10),(4,'One of the greatest movies ever made. I cry every time.','2024-01-15',3,11),(5,'Tom Hanks is simply phenomenal here.','2024-02-20',5,11),(6,'The definition of a perfect movie.','2024-01-10',6,12),(7,'Morgan Freeman narrating is the best part.','2024-03-05',7,12),(8,'Tarantino at his finest! The dialogue is extremely sharp.','2024-02-11',8,13),(9,'Leonardo DiCaprio played the villain perfectly.','2024-02-15',1,13),(10,'Joaquin Phoenix gave a chilling performance. Very dark.','2024-01-22',2,14),(11,'Visually stunning and deeply unsettling.','2024-01-25',3,14),(12,'Such a tragic but important historical story.','2024-04-10',4,15),(13,'Benedict Cumberbatch was the perfect casting choice for Alan Turing.','2024-04-12',5,15),(14,'The soundtrack by Hans Zimmer is out of this world!','2024-03-18',6,16),(15,'Mind-bending plot, but the emotional core is what makes it great.','2024-03-20',7,16),(16,'Rami Malek IS Freddie Mercury. The Live Aid scene was perfect.','2024-01-05',8,17),(17,'Great music, but the pacing felt a bit rushed at times.','2024-01-08',1,17),(18,'Stephen King adaptations rarely get better than this.','2024-02-28',2,18),(19,'John Coffey broke my heart. An incredibly moving film.','2024-03-02',3,18),(20,'Breaking Bad still has the greatest ending in television history.','2025-06-15',9,1),(21,'Negan completely changed the tone of the show.','2025-06-18',12,2),(22,'The mystery elements in Lost kept me hooked for years.','2025-06-20',10,3),(23,'Sherlock and Watson are perfectly cast in this series.','2025-06-21',17,4),(24,'Mr. Robot predicted so many things about modern hacking culture.','2025-06-25',13,5),(25,'Dexter season 4 is peak television.','2025-06-26',11,6),(26,'Friends is timeless comfort television.','2025-06-27',14,7),(27,'Michael Scott makes every episode unforgettable.','2025-06-29',15,8),(28,'The 100 became much darker than I expected.','2025-07-01',16,9),(29,'Robert Downey Jr. was amazing in Oppenheimer.','2025-07-03',18,10);



--
-- Table structure for table commentreaction
--

DROP TABLE IF EXISTS commentreaction;


CREATE TABLE commentreaction (
  reaction_type varchar(30) DEFAULT NULL,
  create_at date DEFAULT NULL,
  uid int NOT NULL,
  comm_id int NOT NULL,
  PRIMARY KEY (uid,comm_id)
);

--
-- Dumping data for table commentreaction
--



INSERT INTO commentreaction VALUES ('LIKE','2024-02-15',1,4),('LIKE','2024-01-28',1,10),('LIKE','2024-02-16',2,4),('LIKE','2024-04-15',2,13),('LIKE','2024-01-15',3,1),('LIKE','2024-03-25',3,14),('LIKE','2024-01-16',4,1),('LIKE','2024-03-12',4,7),('DISLIKE','2024-01-30',4,10),('LIKE','2024-01-20',5,2),('LIKE','2024-02-20',5,8),('DISLIKE','2024-01-22',6,3),('LIKE','2024-01-10',6,16),('LIKE','2024-02-25',7,9),('DISLIKE','2024-01-12',7,17),('LIKE','2024-03-10',8,6),('LIKE','2024-03-05',8,18),('LIKE','2025-06-19',9,21),('LIKE','2025-06-16',10,20),('LIKE','2025-06-17',11,20),('LIKE','2025-06-21',12,22),('DISLIKE','2025-06-20',13,21),('LIKE','2025-06-22',16,23);



--
-- Table structure for table crew
--

DROP TABLE IF EXISTS crew;


CREATE TABLE crew (
  cid int NOT NULL,
  name varchar(30) NOT NULL,
  age int DEFAULT NULL,
  description text,
  PRIMARY KEY (cid)
);

--
-- Dumping data for table crew
--



INSERT INTO crew VALUES (1,'Tom Hanks',69,'Thomas Jeffrey Hanks is an American actor and filmmaker. Known for both his comedic and dramatic roles, he is one of the most popular and recognizable film stars worldwide, and is regarded as an American cultural icon'),(2,'Matthew McConaughey',56,'Matthew David McConaughey is an American actor. He is best known for his amazing act in movie intrestellar, dallas buyers club and the opening season of the anthology series true detective'),(3,'Rami Malek',44,'Rami Malek is an American actor. He gained recognition for portraying Queen lead singer Freddie Mercury in the biographical film Bohemian Rhapsody and playing main character of Mr. Robot.'),(4,'Christopher Nolan',55,'Sir Christopher Edward Nolan is a British and American filmmaker. A significant auteur of his generation, he has been a major figure in the 21st century Hollywood.'),(5,'Bryan Cranston',70,'Lead in Breaking Bad'),(6,'Aaron Paul',46,'Jesse Pinkman in Breaking Bad'),(7,'Norman Reedus',57,'Daryl Dixon in TWD'),(8,'Andrew Lincoln',52,'Rick Grimes in TWD'),(9,'Benedict Cumberbatch',49,'Sherlock Holmes / Alan Turing'),(10,'Cillian Murphy',49,'Lead in Oppenheimer'),(11,'Quentin Tarantino',63,'Director of Django Unchained'),(12,'Joaquin Phoenix',51,'Joker'),(13,'Matthew Fox',57,'Jack Shephard in Lost'),(14,'Michael C. Hall',55,'Dexter Morgan'),(15,'Matthew Perry',57,'Chanandler Bong in Friends'),(16,'Jim Parsons',53,'Sheldon Cooper in Big Bang Theory'),(17,'Steve Carell',63,'Michael Scott in The Office'),(18,'Martin Freeman',54,'John Watson in Sherlock'),(19,'Leonardo DiCaprio',51,'Calvin Candie in Django'),(20,'Jamie Foxx',58,'Django'),(21,'Frank Darabont',67,'Director of Shawshank & Green Mile'),(22,'Tim Robbins',67,'Andy Dufresne in Shawshank'),(23,'Morgan Freeman',88,'Red in Shawshank'),(24,'Alycia Debnam-Carey',32,'Queen Lexa in The 100'),(25,'Devon Bostick',34,'Jasper in The 100'),(26,'Emma Stone',38,'Academy Award winning actress'),(27,'Robert Downey Jr.',61,'Actor known for Iron Man and Oppenheimer'),(28,'Matt Damon',56,'Actor known for The Martian'),(29,'Anne Hathaway',44,'Actress known for Interstellar'),(30,'Jessica Chastain',49,'Actress known for Interstellar'),(31,'Bryan Singer',61,'Director of Bohemian Rhapsody'),(32,'Bob Odenkirk',64,'Actor known for Better Call Saul'),(33,'Steven Yeun',43,'Glenn in The Walking Dead'),(34,'Lauren Cohan',44,'Maggie Greene in TWD'),(35,'Jennifer Aniston',57,'Rachel Green in Friends'),(36,'Courteney Cox',62,'Monica Geller in Friends'),(37,'Steve Molaro',51,'Producer of Big Bang Theory'),(38,'Kaley Cuoco',41,'Penny in Big Bang Theory'),(39,'Johnny Galecki',51,'Leonard Hofstadter in Big Bang Theory'),(40,'David Fincher',64,'Director of Fight Club'),(41,'Christian Bale',52,'Actor known for Batman trilogy'),(42,'Heath Ledger',46,'Academy Award winning actor'),(43,'Vince Gilligan',59,'Creator of Breaking Bad');



--
-- Table structure for table film
--

DROP TABLE IF EXISTS film;


CREATE TABLE film (
  fid int NOT NULL,
  title varchar(30) NOT NULL,
  genre varchar(30) DEFAULT NULL,
  creator_country varchar(30) DEFAULT NULL,
  language varchar(30) DEFAULT NULL,
  PRIMARY KEY (fid)
);

--
-- Dumping data for table film
--



INSERT INTO film VALUES (1,'Breaking Bad','Crime Drama','USA','English'),(2,'The Walking Dead','Horror','USA','English'),(3,'Lost','Sci-Fi/Mystery','USA','English'),(4,'Sherlock','Mystery','UK','English'),(5,'Mr. Robot','Techno-Thriller','USA','English'),(6,'Dexter','Crime Thriller','USA','English'),(7,'Friends','Sitcom','USA','English'),(8,'The Office','Sitcom','USA','English'),(9,'The 100','Post-Apocalyptic','USA','English'),(10,'Oppenheimer','Biographical','USA','English'),(11,'Forrest Gump','Drama','USA','English'),(12,'The Shawshank Redemption','Drama','USA','English'),(13,'Django Unchained','Western','USA','English'),(14,'Joker','Drama/Thriller','USA','English'),(15,'The Imitation Game','History/Drama','UK','English'),(16,'Interstellar','Sci-Fi/Adventure','USA','English'),(17,'Bohemian Rhapsody','Biographical','USA','English'),(18,'The Green Mile','Fantacy/Crime','USA','English'),(19,'Big Bang Theory','Sitcom','USA','English');



--
-- Table structure for table participation
--

DROP TABLE IF EXISTS participation;


CREATE TABLE participation (
  fid int NOT NULL,
  cid int NOT NULL,
  role varchar(30) NOT NULL,
  PRIMARY KEY (fid,cid,role)
);

--
-- Dumping data for table participation
--



INSERT INTO participation VALUES (11,1,'Actor'),(18,1,'Actor'),(16,2,'Actor'),(5,3,'Actor'),(17,3,'Actor'),(10,4,'Director'),(16,4,'Director'),(1,5,'Actor'),(1,6,'Actor'),(2,7,'Actor'),(2,8,'Actor'),(4,9,'Actor'),(15,9,'Actor'),(10,10,'Actor'),(13,11,'Director'),(14,12,'Actor'),(3,13,'Actor'),(6,14,'Actor'),(7,15,'Actor'),(19,16,'Actor'),(8,17,'Actor'),(4,18,'Actor'),(13,19,'Actor'),(13,20,'Actor'),(11,21,'Director'),(12,21,'Director'),(18,21,'Driector'),(12,22,'Actor'),(12,23,'Actor'),(9,24,'Actor'),(9,25,'Actor'),(10,25,'Actor'),(10,27,'Actor'),(10,28,'Actor'),(16,29,'Actor'),(16,30,'Actor'),(17,31,'Director'),(1,32,'Actor'),(2,33,'Actor'),(2,34,'Actor'),(7,35,'Actor'),(7,36,'Actor'),(19,37,'Producer'),(19,38,'Actor'),(19,39,'Actor'),(4,40,'Producer'),(14,41,'Actor'),(1,43,'Director');



--
-- Table structure for table season
--

DROP TABLE IF EXISTS season;


CREATE TABLE season (
  sea_id int NOT NULL,
  release_year date DEFAULT NULL,
  summary text,
  num_of_episodes int DEFAULT NULL,
  fid int DEFAULT NULL,
  PRIMARY KEY (sea_id)
);

--
-- Dumping data for table season
--



INSERT INTO season VALUES (1,'2008-01-20','Chemistry teacher goes rogue',7,1),(2,'2009-03-08','Walt and Jesse expand',13,1),(3,'2010-03-21','The Cousins arrive',13,1),(4,'2011-07-17','Face Off',13,1),(5,'2012-07-15','The final empire',16,1),(6,'2010-10-31','Rick wakes up in an apocalypse',6,2),(7,'2011-10-16','The group stays at the farm',13,2),(8,'2012-10-14','Taking over the prison',16,2),(9,'2013-10-13','A deadly virus spreads',16,2),(10,'2014-10-12','Journey to Terminus',16,2),(11,'2015-10-11','Arrival at Alexandria',16,2),(12,'2016-10-23','Negan takes control',16,2),(13,'2017-10-22','All Out War',16,2),(14,'2018-10-07','A new beginning',16,2),(15,'2019-10-06','The Whisperer War',22,2),(16,'2021-08-22','The final fight for survival',24,2),(17,'2004-09-22','Flight 815 crashes on an island',25,3),(18,'2005-09-21','Discovering the hatch',24,3),(19,'2006-10-04','The Others are revealed',23,3),(20,'2008-01-31','Trying to get off the island',14,3),(21,'2009-01-21','Time travel anomalies',17,3),(22,'2010-02-02','The final resolution',18,3),(23,'2010-07-25','Meeting Dr. Watson',3,4),(24,'2012-01-01','Face to face with Moriarty',3,4),(25,'2014-01-01','Sherlock returns',3,4),(26,'2017-01-01','The final problem',3,4),(27,'2015-06-24','Elliot joins fsociety',10,5),(28,'2016-07-13','The Five/Nine fallout',12,5),(29,'2017-10-11','Stage 2 begins',10,5),(30,'2019-10-06','The truth about Elliot',13,5),(31,'2006-10-01','The Ice Truck Killer',12,6),(32,'2007-09-30','The Bay Harbor Butcher',12,6),(33,'2008-09-28','Dexter finds a friend',12,6),(34,'2009-09-27','The Trinity Killer',12,6),(35,'2010-09-26','Lumen and the barrel girls',12,6),(36,'2011-10-02','The Doomsday Killer',12,6),(37,'2012-09-30','Debra discovers the truth',12,6),(38,'2013-06-30','The final storm',12,6),(39,'1994-09-22','Rachel runs away from her wedding',24,7),(40,'1995-09-21','Ross and Rachel get together',24,7),(41,'1996-09-19','They were on a break',25,7),(42,'1997-09-25','Phoebe is a surrogate',24,7),(43,'1998-09-24','Ross says the wrong name',24,7),(44,'1999-09-23','Chandler and Monica move in',25,7),(45,'2000-10-12','Monica and Chandler get married',24,7),(46,'2001-09-27','Rachel has a baby',24,7),(47,'2002-09-26','Ross and Rachel co-parent',24,7),(48,'2003-09-25','Saying goodbye to the apartment',18,7),(49,'2005-03-24','Introduction to Dunder Mifflin',6,8),(50,'2005-09-20','The Dundies',22,8),(51,'2006-09-21','Jim transfers to Stamford',25,8),(52,'2007-09-27','Ryan becomes the boss',19,8),(53,'2008-09-25','Michael Scott Paper Company',28,8),(54,'2009-09-17','Jim and Pam get married',26,8),(55,'2010-09-23','Michael leaves Scranton',26,8),(56,'2011-09-22','Robert California takes over',24,8),(57,'2012-09-20','The documentary airs',25,8),(58,'2014-03-19','Delinquents sent to Earth',13,9),(59,'2014-10-22','Mount Weather conflict',16,9),(60,'2016-01-21','ALIE and the City of Light',16,9),(61,'2017-02-01','Praimfaya arrives',13,9),(62,'2018-04-24','The bunker and Eden',13,9),(63,'2019-04-30','Sanctum exploration',13,9),(64,'2020-05-20','The final test',16,9),(65,'2007-09-24','Penny moves in next door',17,19),(66,'2008-09-22','Leonard and Penny date',23,19),(67,'2009-09-21','Howard meets Bernadette',23,19),(68,'2010-09-23','Sheldon meets Amy',24,19),(69,'2011-09-22','Howard goes to space',24,19),(70,'2012-09-27','Leonard leaves for the sea',24,19),(71,'2013-09-26','Penny quits acting',24,19),(72,'2014-09-22','Sheldon goes on a train trip',24,19),(73,'2015-09-21','Leonard and Penny marry',24,19),(74,'2016-09-19','Howard and Bernadette have a baby',24,19),(75,'2017-09-25','Sheldon proposes to Amy',24,19),(76,'2018-09-24','The Nobel Prize',24,19);



--
-- Table structure for table series
--

DROP TABLE IF EXISTS series;


CREATE TABLE series (
  num_of_seasons int DEFAULT NULL,
  fid int NOT NULL,
  PRIMARY KEY (fid)
);

--
-- Dumping data for table series
--



INSERT INTO series VALUES (5,1),(11,2),(6,3),(4,4),(4,5),(8,6),(10,7),(9,8),(7,9),(12,19);



--
-- Table structure for table subscriptionplan
--

DROP TABLE IF EXISTS subscriptionplan;


CREATE TABLE subscriptionplan (
  sub_id int NOT NULL,
  title varchar(30) NOT NULL,
  cost int NOT NULL,
  duration int NOT NULL,
  PRIMARY KEY (sub_id)
);

--
-- Dumping data for table subscriptionplan
--



INSERT INTO subscriptionplan VALUES (1,'Free',0,7),(2,'Monthly',100000,30),(3,'Annual',900000,365);



--
-- Table structure for table video
--

DROP TABLE IF EXISTS video;


CREATE TABLE video (
  vid int NOT NULL,
  create_at date DEFAULT NULL,
  is_dubbed smallint DEFAULT NULL,
  is_subtitled smallint DEFAULT NULL,
  duration int DEFAULT NULL,
  like_rate int DEFAULT NULL,
  storage_path text NOT NULL,
  description text,
  cin_id int DEFAULT NULL,
  sea_id int DEFAULT NULL,
  PRIMARY KEY (vid)
);

--
-- Dumping data for table video
--



INSERT INTO video VALUES (501,'2023-07-21',0,1,180,95,'/m/Oppenheimer/Subbed/480p.mp4','Main Movie 480p',10,NULL),(502,'2023-07-21',0,1,180,95,'/m/Oppenheimer/Subbed/720p.mp4','Main Movie 720p',10,NULL),(503,'2023-07-21',0,1,180,95,'/m/Oppenheimer/Subbed/1080p.mp4','Main Movie 1080p',10,NULL),(504,'2023-07-21',0,1,180,95,'/m/Oppenheimer/Subbed/1080px265.mkv','Main Movie 1080p x265',10,NULL),(505,'2023-07-21',0,1,180,95,'/m/Oppenheimer/Subbed/4k.mkv','Main Movie 4K',10,NULL),(506,'2023-08-15',1,0,180,94,'/m/Oppenheimer/Dubbed/480p.mp4','Main Movie Dubbed 480p',10,NULL),(507,'2023-08-15',1,0,180,94,'/m/Oppenheimer/Dubbed/720p.mp4','Main Movie Dubbed 720p',10,NULL),(508,'2023-08-15',1,0,180,94,'/m/Oppenheimer/Dubbed/1080p.mp4','Main Movie Dubbed 1080p',10,NULL),(509,'1994-07-06',0,1,142,98,'/m/ForrestGump/Subbed/480p.mp4','Main Movie 480p',11,NULL),(510,'1994-07-06',0,1,142,98,'/m/ForrestGump/Subbed/720p.mp4','Main Movie 720p',11,NULL),(511,'1994-07-06',0,1,142,98,'/m/ForrestGump/Subbed/1080p.mp4','Main Movie 1080p',11,NULL),(512,'1995-01-10',1,0,142,97,'/m/ForrestGump/Dubbed/480p.mp4','Main Movie Dubbed 480p',11,NULL),(513,'1995-01-10',1,0,142,97,'/m/ForrestGump/Dubbed/720p.mp4','Main Movie Dubbed 720p',11,NULL),(514,'1994-09-23',0,1,142,99,'/m/TheShawshankRedemption/Subbed/480p.mp4','Main Movie 480p',12,NULL),(515,'1994-09-23',0,1,142,99,'/m/TheShawshankRedemption/Subbed/720p.mp4','Main Movie 720p',12,NULL),(516,'1994-09-23',0,1,142,99,'/m/TheShawshankRedemption/Subbed/1080p.mp4','Main Movie 1080p',12,NULL),(517,'1995-05-12',1,0,142,98,'/m/TheShawshankRedemption/Dubbed/720p.mp4','Main Movie Dubbed 720p',12,NULL),(518,'1995-05-12',1,0,142,98,'/m/TheShawshankRedemption/Dubbed/1080p.mp4','Main Movie Dubbed 1080p',12,NULL),(519,'2012-12-25',0,1,165,96,'/m/DjangoUnchained/Subbed/480p.mp4','Main Movie 480p',13,NULL),(520,'2012-12-25',0,1,165,96,'/m/DjangoUnchained/Subbed/720p.mp4','Main Movie 720p',13,NULL),(521,'2012-12-25',0,1,165,96,'/m/DjangoUnchained/Subbed/1080p.mp4','Main Movie 1080p',13,NULL),(522,'2012-12-25',0,1,165,96,'/m/DjangoUnchained/Subbed/2k.mkv','Main Movie 2K',13,NULL),(523,'2013-03-10',1,0,165,95,'/m/DjangoUnchained/Dubbed/720p.mp4','Main Movie Dubbed 720p',13,NULL),(524,'2013-03-10',1,0,165,95,'/m/DjangoUnchained/Dubbed/1080px265.mkv','Main Movie Dubbed 1080p x265',13,NULL),(525,'2019-10-04',0,1,122,90,'/m/Joker/Subbed/480p.mp4','Main Movie 480p',14,NULL),(526,'2019-10-04',0,1,122,90,'/m/Joker/Subbed/720p.mp4','Main Movie 720p',14,NULL),(527,'2019-10-04',0,1,122,90,'/m/Joker/Subbed/1080p.mp4','Main Movie 1080p',14,NULL),(528,'2019-10-04',0,1,122,90,'/m/Joker/Subbed/4k.mkv','Main Movie 4K',14,NULL),(529,'2020-01-15',1,0,122,88,'/m/Joker/Dubbed/720p.mp4','Main Movie Dubbed 720p',14,NULL),(530,'2020-01-15',1,0,122,88,'/m/Joker/Dubbed/1080px265.mkv','Main Movie Dubbed 1080p x265',14,NULL),(531,'2014-11-28',0,1,114,91,'/m/TheImitationGame/Subbed/480p.mp4','Main Movie 480p',15,NULL),(532,'2014-11-28',0,1,114,91,'/m/TheImitationGame/Subbed/720p.mp4','Main Movie 720p',15,NULL),(533,'2014-11-28',0,1,114,91,'/m/TheImitationGame/Subbed/1080p.mp4','Main Movie 1080p',15,NULL),(534,'2015-02-14',1,0,114,89,'/m/TheImitationGame/Dubbed/720p.mp4','Main Movie Dubbed 720p',15,NULL),(535,'2014-11-07',0,1,169,96,'/m/Interstellar/Subbed/480p.mp4','Main Movie 480p',16,NULL),(536,'2014-11-07',0,1,169,96,'/m/Interstellar/Subbed/720p.mp4','Main Movie 720p',16,NULL),(537,'2014-11-07',0,1,169,96,'/m/Interstellar/Subbed/1080p.mp4','Main Movie 1080p',16,NULL),(538,'2014-11-07',0,1,169,96,'/m/Interstellar/Subbed/4k.mkv','Main Movie 4K',16,NULL),(539,'2015-02-20',1,0,169,95,'/m/Interstellar/Dubbed/720p.mp4','Main Movie Dubbed 720p',16,NULL),(540,'2015-02-20',1,0,169,95,'/m/Interstellar/Dubbed/1080p.mp4','Main Movie Dubbed 1080p',16,NULL),(541,'2018-11-02',0,1,134,88,'/m/BohemianRhapsody/Subbed/480p.mp4','Main Movie 480p',17,NULL),(542,'2018-11-02',0,1,134,88,'/m/BohemianRhapsody/Subbed/720p.mp4','Main Movie 720p',17,NULL),(543,'2018-11-02',0,1,134,88,'/m/BohemianRhapsody/Subbed/1080p.mp4','Main Movie 1080p',17,NULL),(544,'2019-01-20',1,0,134,86,'/m/BohemianRhapsody/Dubbed/720p.mp4','Main Movie Dubbed 720p',17,NULL),(545,'1999-12-10',0,1,189,97,'/m/TheGreenMile/Subbed/480p.mp4','Main Movie 480p',18,NULL),(546,'1999-12-10',0,1,189,97,'/m/TheGreenMile/Subbed/720p.mp4','Main Movie 720p',18,NULL),(547,'1999-12-10',0,1,189,97,'/m/TheGreenMile/Subbed/1080p.mp4','Main Movie 1080p',18,NULL),(548,'2000-04-05',1,0,189,95,'/m/TheGreenMile/Dubbed/720p.mp4','Main Movie Dubbed 720p',18,NULL),(549,'2000-04-05',1,0,189,95,'/m/TheGreenMile/Dubbed/1080px265.mkv','Main Movie Dubbed 1080p x265',18,NULL);



--
-- Table structure for table videoreaction
--

DROP TABLE IF EXISTS videoreaction;


CREATE TABLE videoreaction (
  reaction_type varchar(30) DEFAULT NULL,
  create_at date DEFAULT NULL,
  uid int NOT NULL,
  vid int NOT NULL,
  PRIMARY KEY (uid,vid)
);

--
-- Dumping data for table videoreaction
--



INSERT INTO videoreaction VALUES ('LIKE','2024-01-10',1,501),('LIKE','2024-01-11',1,502),('LIKE','2024-01-12',1,503),('DISLIKE','2024-01-13',1,509),('LIKE','2024-01-14',1,514),('LIKE','2024-01-15',1,519),('LIKE','2024-02-01',2,515),('LIKE','2024-02-02',2,516),('LIKE','2024-02-03',2,520),('LIKE','2024-02-04',2,525),('DISLIKE','2024-02-05',2,531),('LIKE','2024-03-01',3,526),('LIKE','2024-03-02',3,527),('LIKE','2024-03-03',3,535),('LIKE','2024-03-04',3,536),('LIKE','2024-03-05',3,541),('DISLIKE','2024-03-06',3,545),('LIKE','2024-03-07',3,546),('LIKE','2024-03-08',3,547),('LIKE','2025-02-20',4,532),('LIKE','2025-02-21',4,533),('LIKE','2025-02-22',4,537),('LIKE','2025-02-23',4,538),('LIKE','2025-02-24',4,542),('LIKE','2025-02-25',5,504),('LIKE','2025-02-26',5,510),('LIKE','2025-02-27',5,521),('DISLIKE','2025-02-28',5,528),('LIKE','2025-03-01',5,543),('LIKE','2025-03-02',5,548),('LIKE','2025-03-10',6,505),('LIKE','2025-03-11',6,511),('LIKE','2025-03-12',6,517),('LIKE','2025-03-13',6,522),('LIKE','2025-03-14',6,529),('LIKE','2024-04-01',7,506),('LIKE','2024-04-02',7,512),('LIKE','2024-04-03',7,518),('DISLIKE','2024-04-04',7,523),('LIKE','2024-04-05',7,530),('LIKE','2024-04-06',7,534),('LIKE','2024-04-07',7,539),('LIKE','2024-04-10',8,507),('LIKE','2024-04-11',8,508),('LIKE','2024-04-12',8,513),('LIKE','2024-04-13',8,524),('LIKE','2024-04-14',8,540),('LIKE','2025-08-01',9,503),('LIKE','2025-08-02',9,521),('LIKE','2025-08-03',9,537),('LIKE','2025-08-04',9,547),('LIKE','2025-08-05',10,515),('LIKE','2025-08-06',10,526),('DISLIKE','2025-08-07',10,541);



--
-- Table structure for table watchhistoryitem
--

DROP TABLE IF EXISTS watchhistoryitem;


CREATE TABLE watchhistoryitem (
  create_at date DEFAULT NULL,
  uid int NOT NULL,
  fid int NOT NULL,
  PRIMARY KEY (uid,fid)
);

--
-- Dumping data for table watchhistoryitem
--



INSERT INTO watchhistoryitem VALUES ('2024-01-10',1,14),('2024-01-15',1,15),('2024-01-20',1,16),('2024-01-25',1,17),('2024-01-30',1,18),('2024-02-01',2,10),('2024-02-05',2,11),('2024-02-10',2,12),('2024-02-15',2,15),('2024-02-20',2,16),('2024-02-25',2,17),('2024-03-01',3,10),('2024-03-03',3,11),('2024-03-05',3,12),('2024-03-07',3,13),('2024-03-09',3,14),('2024-03-11',3,15),('2024-03-13',3,16),('2024-03-15',4,11),('2024-03-17',4,12),('2024-03-19',4,13),('2024-03-21',4,14),('2024-03-23',4,15),('2024-03-25',4,16),('2024-03-27',4,17),('2024-03-29',4,18),('2024-01-05',5,10),('2024-01-10',5,11),('2024-01-15',5,12),('2024-01-20',5,13),('2024-01-25',5,14),('2024-01-30',5,15),('2024-02-05',5,16),('2024-02-10',5,17),('2024-02-15',5,18),('2024-04-01',6,10),('2024-04-05',6,11),('2024-04-10',6,12),('2024-04-15',6,13),('2024-04-20',6,14),('2024-04-25',7,12),('2024-04-27',7,13),('2024-04-29',7,14),('2024-05-01',7,15),('2024-05-03',7,16),('2024-05-05',7,17),('2024-05-10',8,10),('2024-05-12',8,11),('2024-05-14',8,14),('2024-05-16',8,15),('2024-05-18',8,16),('2024-05-20',8,17),('2024-05-22',8,18),('2025-08-01',9,1),('2025-08-03',9,10),('2025-08-05',9,13),('2025-08-07',9,16),('2025-08-09',9,18),('2025-08-02',10,3),('2025-08-04',10,4),('2025-08-06',10,12),('2025-08-08',10,14),('2025-08-10',10,17);



--
-- Table structure for table watchlistitem
--

DROP TABLE IF EXISTS watchlistitem;


CREATE TABLE watchlistitem (
  create_at date DEFAULT NULL,
  uid int NOT NULL,
  fid int NOT NULL,
  PRIMARY KEY (uid,fid)
);

--
-- Dumping data for table watchlistitem
--



INSERT INTO watchlistitem VALUES ('2024-06-01',1,10),('2024-06-02',1,11),('2024-06-03',1,12),('2024-06-05',2,13),('2024-06-06',2,14),('2024-06-10',3,15),('2024-06-11',3,16),('2024-06-12',3,17),('2024-06-13',3,18),('2024-06-15',4,10),('2024-06-20',5,11),('2024-06-21',5,12),('2024-06-22',5,13),('2024-06-23',5,14),('2024-06-24',5,15),('2024-06-25',6,16),('2024-06-26',6,17),('2024-07-02',7,10),('2024-07-03',7,11),('2024-07-01',7,18),('2024-07-05',8,12),('2024-07-06',8,13),('2024-07-07',8,14),('2024-07-08',8,15),('2025-09-15',9,12),('2025-09-16',9,14),('2025-09-17',9,17),('2025-09-18',10,10),('2025-09-19',10,15),('2025-09-20',10,18);



--
-- Table structure for table wuser
--

DROP TABLE IF EXISTS wuser;


CREATE TABLE wuser (
  uid int NOT NULL,
  username varchar(30) NOT NULL,
  create_at date NOT NULL,
  aid int DEFAULT NULL,
  PRIMARY KEY (uid),
  UNIQUE (username)
);

--
-- Dumping data for table wuser
--



INSERT INTO wuser VALUES (1,'daryl_dixon','2024-01-02',1),(2,'rosita_espinosa','2024-01-02',1),(3,'maggie_greene','2024-01-02',1),(4,'ben_linus','2025-02-17',2),(5,'kate_austen','2025-02-17',2),(6,'charlie_pace','2025-02-17',2),(7,'octavia_blake','2024-01-02',3),(8,'bloodreina','2024-01-02',3),(9,'walter_white','2025-06-11',4),(10,'saul_goodman','2025-06-11',4),(11,'rick_grimes','2025-08-19',5),(12,'negan_smith','2025-08-19',5),(13,'elliot_alderson','2026-01-09',6),(14,'sheldon_cooper','2026-02-01',7),(15,'michael_scott','2026-02-01',7),(16,'julian casablancas','2026-03-13',8),(17,'john_watson','2026-03-13',8),(18,'freddie_mercury','2026-03-13',8);












-- Dump completed on 2026-05-02 14:41:26


-- Foreign Keys added after table creation
ALTER TABLE account ADD CONSTRAINT account_ibfk_1 FOREIGN KEY (sub_id) REFERENCES subscriptionplan (sub_id) ON DELETE SET DEFAULT ON UPDATE CASCADE;
ALTER TABLE cinematic ADD CONSTRAINT cinematic_ibfk_1 FOREIGN KEY (fid) REFERENCES film (fid) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE comment ADD CONSTRAINT comment_ibfk_1 FOREIGN KEY (uid) REFERENCES wuser (uid) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE comment ADD CONSTRAINT comment_ibfk_2 FOREIGN KEY (fid) REFERENCES film (fid) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE commentreaction ADD CONSTRAINT commentreaction_ibfk_1 FOREIGN KEY (uid) REFERENCES wuser (uid) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE commentreaction ADD CONSTRAINT commentreaction_ibfk_2 FOREIGN KEY (comm_id) REFERENCES comment (comm_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE participation ADD CONSTRAINT participation_ibfk_1 FOREIGN KEY (fid) REFERENCES film (fid) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE participation ADD CONSTRAINT participation_ibfk_2 FOREIGN KEY (cid) REFERENCES crew (cid) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE season ADD CONSTRAINT season_ibfk_1 FOREIGN KEY (fid) REFERENCES series (fid) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE series ADD CONSTRAINT series_ibfk_1 FOREIGN KEY (fid) REFERENCES film (fid) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE video ADD CONSTRAINT video_ibfk_1 FOREIGN KEY (cin_id) REFERENCES cinematic (fid) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE video ADD CONSTRAINT video_ibfk_2 FOREIGN KEY (sea_id) REFERENCES season (sea_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE videoreaction ADD CONSTRAINT videoreaction_ibfk_1 FOREIGN KEY (uid) REFERENCES wuser (uid) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE videoreaction ADD CONSTRAINT videoreaction_ibfk_2 FOREIGN KEY (vid) REFERENCES video (vid) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE watchhistoryitem ADD CONSTRAINT watchhistoryitem_ibfk_1 FOREIGN KEY (uid) REFERENCES wuser (uid) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE watchhistoryitem ADD CONSTRAINT watchhistoryitem_ibfk_2 FOREIGN KEY (fid) REFERENCES film (fid) ON DELETE SET DEFAULT ON UPDATE CASCADE;
ALTER TABLE watchlistitem ADD CONSTRAINT watchlistitem_ibfk_1 FOREIGN KEY (uid) REFERENCES wuser (uid) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE watchlistitem ADD CONSTRAINT watchlistitem_ibfk_2 FOREIGN KEY (fid) REFERENCES film (fid) ON DELETE SET DEFAULT ON UPDATE CASCADE;
ALTER TABLE wuser ADD CONSTRAINT wuser_ibfk_1 FOREIGN KEY (aid) REFERENCES account (aid) ON DELETE CASCADE ON UPDATE CASCADE;