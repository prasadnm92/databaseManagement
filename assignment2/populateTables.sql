insert into FiefType(id) values(1);
insert into FiefType(id) values(2);
insert into FiefType(id) values(3);

insert into NobleRank(id, hasFiefType) values(1, 1);
insert into NobleRank(id, hasFiefType) values(2, 2);
#new entry for Q3
insert into NobleRank(id) values(3);

insert into RankName(id, names, title, gender, language) values(1, 1, 'Count', 'Masculine', 'en');
insert into RankName(id, names, title, gender, language) values(2, 1, 'Earl', 'Masculine', 'en');
insert into RankName(id, names, title, gender, language) values(3, 1, 'Countess', 'Feminine', 'en');
insert into RankName(id, names, title, gender, language) values(4, 1, 'Comte', 'Masculine', 'fr');
insert into RankName(id, names, title, gender, language) values(5, 2, 'Baron', 'Masculine', 'en');
insert into RankName(id, names, title, gender, language) values(6, 2, 'Baroness', 'Feminine', 'en');
insert into RankName(id, names, title, gender, language) values(7, 2, 'Baro', 'Neutral', 'hu');

insert into FiefName(id, name, language, partOf) values(1, 'County', 'en', 1);
insert into FiefName(id, name, language, partOf) values(2, 'Comte', 'fr', 1);
insert into FiefName(id, name, language, partOf) values(3, 'Barony', 'en', 2);
insert into FiefName(id, name, language, partOf) values(4, 'Barosag', 'hu', 2);
insert into FiefName(id, name, language, partOf) values(5, 'Baronnie', 'fr', 2);
#new entry for Q3
insert into FiefName(id, name, language, partOf) values(6, 'Baronniel', 'it', 2);

insert into NobleRanking(ranksBelow, ranksAbove) values(1, 2);
#new entry for Q9
insert into NobleRanking(ranksBelow, ranksAbove) values(3, 1);

insert into Person(id, name, gender) value(1, 'John Boyle', 'Masculine');
insert into Person(id, name, gender) value(2, 'Robert Lambart', 'Masculine');
insert into Person(id, name, gender) value(3, 'Edward Digby', 'Masculine');
insert into Person(id, name, gender) value(4, 'Gwendolen Guinness', 'Feminine');
insert into Person(id, name, gender) value(5, 'Bathory Erzebet', 'Feminine');
insert into Person(id, name, gender) value(6, 'Antoinette Louise Alberte Suzanne Grimaldi', 'Feminine');
insert into Person(id, name, gender) value(7, 'Antonia Bandaras', 'Masculine');

insert into Nobility(isEntitledTo, entitles, name) values(1, 1, 'Cork');
insert into Nobility(isEntitledTo, entitles, name) values(1, 2, 'Cavan');
insert into Nobility(isEntitledTo, entitles, name) values(2, 3, 'Digby');
insert into Nobility(isEntitledTo, entitles, name) values(1, 4, 'Iveagh');
insert into Nobility(isEntitledTo, entitles, name) values(1, 5, 'Ecsed');
insert into Nobility(isEntitledTo, entitles, name) values(2, 6, 'Massy');
#new entry for Q9
insert into Nobility(isEntitledTo, entitles, name) values(2, 5, 'Ecsed-Massy');

insert into PersonEmail(person, email) values(1, 'cork@example.org');
insert into PersonEmail(person, email) values(2, 'cavan@example.org');
insert into PersonEmail(person, email) values(3, 'digby@example.org');
insert into PersonEmail(person, email) values(4, 'iveagh@example.org');
insert into PersonEmail(person, email) values(5, 'ecsed@example.org');
insert into PersonEmail(person, email) values(6, 'massy@example.org');
insert into PersonEmail(person, email) values(5, 'grimaldi@draculas.com.au');
insert into PersonEmail(person, email) values(7, 'bandaras@supercool.edu');