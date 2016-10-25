create table FiefType (
  id int primary key
);
create table NobleRank (
  id int primary key,
  hasFiefType int,
  foreign key(hasFiefType) references FiefType(id) on delete no action on update cascade,  
  unique(hasFiefType)  
);
create table RankName (
  id int primary key,
  names int not null,
  foreign key(names) references NobleRank(id) on delete cascade on update cascade,
  title varchar(200) not null,
  gender enum('Masculine', 'Feminine', 'Neutral') not null,
  language char(2) not null
);
create table FiefName (
  id int primary key,
  name varchar(200) not null,
  language char(2) not null,
  partOf int not null,
  foreign key(partOf) references FiefType(id) on delete cascade on update cascade
);
create table NobleRanking (
  ranksBelow int not null,
  foreign key(ranksBelow) references NobleRank(id) on delete cascade on update cascade,
  ranksAbove int not null,
  foreign key(ranksAbove) references NobleRank(id) on delete cascade on update cascade,
  primary key(ranksBelow, ranksAbove)
);
create table Person (
  id int primary key,
  name varchar(200) not null,
  gender enum('Masculine', 'Feminine', 'Neutral') not null
);
create table Nobility (
  isEntitledTo int not null,
  foreign key(isEntitledTo) references NobleRank(id) on delete cascade on update cascade,
  entitles int not null,
  foreign key(entitles) references Person(id) on delete cascade on update cascade,
  primary key(isEntitledTo, entitles),
  name varchar(200) not null
);
create table PersonEmail (
  person int not null,
  foreign key(person) references Person(id) on delete cascade on update cascade,
  email varchar(200) not null,
  primary key(person, email)
);