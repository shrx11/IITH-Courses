CREATE TABLE researcher
(
    Rid SERIAL,
    First_name text NOT NULL,
    Middle_Name text,
    Last_Name text,
    
    UNIQUE (First_name, Middle_Name, Last_Name),
    PRIMARY KEY (Rid)
);
    
    CREATE UNIQUE INDEX middle_null ON researcher (First_name, (Middle_Name IS NULL), Last_Name) WHERE Middle_Name IS NULL;

CREATE TABLE venue
(
    Vid SERIAL,
    Name text NOT NULL,

    PRIMARY KEY (Vid),
    UNIQUE (Name)
);

CREATE TABLE research_paper
(
    Pid SERIAL NOT NULL,
    Title text NOT NULL,
    Abstract text,
    YOP SMALLINT,
    Vid INT,
    PRIMARY KEY (Pid),
    FOREIGN KEY (Vid) REFERENCES Venue(Vid)
);

CREATE TABLE author
(
    Auth_Order SMALLINT NOT NULL,
    Rid INT NOT NULL,
    Pid INT NOT NULL,
    
    PRIMARY KEY (Rid, Pid),
    FOREIGN KEY (Rid) REFERENCES Researcher(Rid),
    FOREIGN KEY (Pid) REFERENCES Research_Paper(Pid),

    UNIQUE(Rid, Pid),
    UNIQUE(Pid, Auth_Order)
);

CREATE TABLE reference
(
  Pid INT NOT NULL,
  Refid INT NOT NULL,
  PRIMARY KEY (Refid, Pid),
  FOREIGN KEY (Pid) REFERENCES Research_Paper(Pid)
);