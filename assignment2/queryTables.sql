#Jyothi Prasad Nama Mahesh - 001783901

/*
1. List both the personal name and the noble name (i.e., the person's nobility name) of 
	every "Count" (in any language) in the database.

Make an inner join Person table with Nobility table using the 'isEntitledTo' foreign key.
Then do an inner join with the RankName table on 'names' foreign key.
Then filter all rows with the title 'Count', according to post @84, Count need not be translated.
Finally, show the personal name & noble name.
*/
select p.name as 'personal name', n.name as 'noble name'
from Person p join Nobility n on (n.entitles = p.id)
	join RankName rn on (n.isEntitledTo = rn.names)
where rn.title = 'Count';

/*
2. For a person (given their id), list every nobility to which they are entitled. For each
	nobility, show the rank in German and noble name. If a rank has several German names, 
	show all of them. The names must have compatible genders.

First do an inner join on Person and Nobility tables,
then join with RankName on their respective foreign keys.
Use the given person id (1 here) to filter the entitled nobilities.
Filter ranks with German names only (and show all of them).
Filter based on gender compatibility between the person and the rank name.
Finally, list the nobility(noble name) and rank name.
*/
select n.name as 'noble name', rn.title as 'rank name'
from Person p join Nobility n on(p.id=n.entitles)
	join RankName rn on(n.isEntitledTo=rn.names)
where p.id=1 #replace with given person id
and rn.language='de'
and p.gender=rn.gender;

/*
3. Show every noble rank and the fief (by Italian name) that it has. If a noble rank has no
	fief, then show the rank as "landless". If the fief has no Italian name, then show the 
    rank as "unnamed fief".
    
Do a left outer join on NobleRank and FiefName so that we have noble ranks without a
fief type as well.
For each record (each noble rank) in the above table show the noble rank id and the fief name.
Show 'unnamed fief' if a record does not have an italian fief name.
Show 'landless' if it does not have a fief type at all.
To show 'unnamed fief', first I remove duplictes using distinct. If a rank has both an italian fief
name and in other language(s) then for that rank there will be 2 records, one with italian name and \
one with 'unnamed fief'. To remove 'unnamed fief', I group by rank name and remove it.
*/
select *
from (
	select distinct nr.id as 'noblerank', if(nr.hasFiefType is null,'landless',if(fn.language<>'it','unnamed fief',fn.name)) as 'fiefname'
	from NobleRank nr left join FiefName fn on (nr.hasFiefType = fn.partOf)
) as rankAndNames2
where not (rankAndNames2.noblerank in (
					select rankAndNames1.noblerank
					from (
						select distinct nr.id as 'noblerank', if(nr.hasFiefType is null,'landless',if(fn.language<>'it','unnamed fief',fn.name)) as 'fiefname'
						from NobleRank nr left join FiefName fn on (nr.hasFiefType = fn.partOf)
					) as rankAndNames1
					group by rankAndNames1.noblerank
					having count(*)>1
			)
and rankAndNames2.fiefname='unnamed fief')
order by rankAndNames2.noblerank;

/*
4. Given an email address, determine whether there is a noble person with that email 
	address.

Do an inner join on PersonEmail and Nobility so that we have emails of only noble persons.
Filter for the given email and check if any records exist. If yes then that means a noble person
exists with that email address.
*/
select if(count(*)>0,'True','False')
from Nobility n join PersonEmail pe on (n.entitles = pe.person)
where pe.email = 'some_email@example.org';
#here, some_email@example.org should be replaced by the email you want to check with

/*
5. List all ranks of nobility for which there is someone who has that rank. For each rank 
	show its id and name(s) in English. If a rank has no name in English, then just show 
	its id.

Do an inner join on RankName and NobleRank to get all ranks and their names.
Use a subquery to filter all ranks that has someone with the noble rank.
Show the noble rank id and rank name (if exists in English)
*/
select rn.id as 'rank ID', if(language='en',rn.title,null) as 'rank name'
from RankName rn join NobleRank nr on(nr.id = rn.names)
where nr.id in(
		select n.isEntitledTo
		from Person p join Nobility n on(p.id=n.entitles));

/*
6. Find all pairs consisting of a personal name and noble name (i.e., the person's nobility
	name) such that every duke of that noble name (i.e., the person's nobility name) 
    entitles a person with the personal name.

Do an inner join on Person, Nobility and RankName to get rank names of all persons with nobility.
From the above result, filter out ones that are the dukes of that nobility.
Show the personal & nobility name.
*/
select p.name as 'personal name', n.name 'noble name'
from Person p join Nobility n on(p.id=n.entitles)
	join RankName rn on(n.isEntitledTo=rn.names)	
where rn.title='duke';

/*
7. List the ranks of nobility that are above the rank of "Comte" (French for "Count").
	For each rank show its name(s) in French.

For each rank name, use a subquery to check if it names a noble rank that ranks above
the french name 'Comte'.
And for each such rank show the rank ID and rank name if the name is in French (else null, as per post @107).
*/
select id as 'rank name ID', names as 'noble rank', if(language='fr',title,null)
from RankName
where names in(
		select n_r.ranksBelow
		from RankName rn join NobleRank nr on (rn.names=nr.id)
			join NobleRanking n_r on (nr.id=n_r.ranksAbove)
		where rn.title='Comte'
		and rn.language='fr'
	);

/*
8. List the ranks of nobility that are both above and below themselves. For each rank show
	its name(s) in English.

Do an inner join on RankName and NobleRanking using the foreign keys.
Filter rows that have ranks that are above and below themselves.
List the ranks (by their id) and show the name if it exists in English.
(else null, following same rule as suggested for query 7 in post @107)
*/
select rn.id as 'rank ID', if(rn.language='en', rn.title, null) as 'rank name'
from RankName rn, NobleRanking n_r1, NobleRanking n_r2
where rn.names = n_r1.ranksBelow
and n_r1.ranksBelow = n_r2.ranksAbove
and n_r1.ranksAbove = n_r2.ranksBelow;

/*
9. For a person (given their id) show the highest rank (or ranks) of nobility to which the
	person is entitled.
    
The idea here is to first generate a table of noble rank ID's for which the given person is entitled to.
This is called as the 'personNobleRanks' table below.
Using these noble ranks, a subset of the NobleRanking table is generated(called as 'personNobleRanking'
below) so that we have the relationships of only those noble ranks that the person is entitled to.
Now all that is left to do is find the top rank from personNobleRanking which can be done by checking
for all personNobleRanks' ids that rank above another noble rank but not below any other noble rank
in the personNobleRanking table.
*/
select pnr.id as 'top ranks'
from (
	#------sub-query to generate the personNobleRanks table------
	select nr.id
	from Person p join Nobility n on(p.id=n.entitles)
		join NobleRank nr on(n.isEntitledTo=nr.id)
	where p.id='given_person') as pnr
where pnr.id not in(
	#------sub-query to generate the personNobleRanking table------
	select ranksAbove
	from NobleRanking
	where ranksBelow in (
			#------sub-query to generate the personNobleRanks table------
			select nr.id
			from Person p join Nobility n on(p.id=n.entitles)
				join NobleRank nr on(n.isEntitledTo=nr.id)
			where p.id='given_person')
	and ranksAbove in (
			#------sub-query to generate the personNobleRanks table------
			select nr.id
			from Person p join Nobility n on(p.id=n.entitles)
				join NobleRank nr on(n.isEntitledTo=nr.id)
			where p.id='given_person')
	);
#here, p.id=5 should be replaced by the id of the given person

/*Q9 alternative
DO NOT GRADE THIS
select pnr.ranksBelow as 'top ranks'
from (
	#------sub-query to generate the personNobleRanking table------
	select *
	from NobleRanking
	where ranksBelow in (
			#------sub-query to generate the personNobleRanks table------
			select nr.id
			from Person p join Nobility n on(p.id=n.entitles)
				join NobleRank nr on(n.isEntitledTo=nr.id)
			where p.id=5)
	and ranksAbove in (
			#------sub-query to generate the personNobleRanks table------
			select nr.id
			from Person p join Nobility n on(p.id=n.entitles)
				join NobleRank nr on(n.isEntitledTo=nr.id)
			where p.id=5)
	) as pnr
where pnr.ranksBelow not in(
	#------sub-query to generate the personNobleRanking table------
	select ranksAbove
	from NobleRanking
	where ranksBelow in (
			#------sub-query to generate the personNobleRanks table------
			select nr.id
			from Person p join Nobility n on(p.id=n.entitles)
				join NobleRank nr on(n.isEntitledTo=nr.id)
			where p.id=5)
	and ranksAbove in (
			#------sub-query to generate the personNobleRanks table------
			select nr.id
			from Person p join Nobility n on(p.id=n.entitles)
				join NobleRank nr on(n.isEntitledTo=nr.id)
			where p.id=5)
	);
*/
/*
10.Show how to add a new name in a language for a rank of nobility (given its id) so that 
	the new name is the only name in that language for that rank of nobility. The new name
    will have Neutral gender.
    
Before inserting a new record, we need to alter the existing table to introduce a new contraint
that makes sure that the name is unique in a language.
After altering, we can insert the new value. If the new name exists then tne new record won't be
inserted into the table.
*/
alter table RankName
add constraint uniqueRankName unique(title, language);

insert into RankName(id, names, title, gender, language) 
			values('new_id', 'given_nobleRank', 'new_title', 'Neutral', 'new_language');

/*
11.Show how to endow (i.e., entitle) an existing person (given their id) with a new rank 
	of nobility. The new rank must be above (and not equal to) every rank of nobility that
    the person currently has. You may use more than one query and/or command.

To endow an existing person, we need to insert a record into the Nobility table.
The columns include the noble rank to entitle, the person to be entitled (given) and a name
for this nobility.
To find the 
"new rank of nobility" -> assume this rank already exists, post @109
*/

insert into Nobility(isEntitledTo, entitles, name)
values((
		select n2.ranksBelow
        from NobleRanking n1, NobleRanking n2,
			(select nr.id as id
				from NobleRank nr join Nobility n on(nr.id=n.isEntitledTo)
					join Person p on(n.entitles=p.id)
				where p.id='given_person') as personNobleRank
		where personNobleRank.id = n1.ranksAbove
		and personNobleRank.id <> n2.ranksBelow
		and n1.ranksBelow=n2.ranksAbove
        limit 1
	),'given_person','new_nobility_name');

/*
12.Show how to disentitle a person (given their id) from all their noble ranks.

Delete all records in Nobility that has an entry for the given person's id.
*/
delete
from Nobility
where entitles=1; #use the given person ID here

/*
13.Update all Hungarian rank names to have Neutral gender.

Update all records by setting the gender to 'Neutral' for every record that
is in Hungarian language.
*/
update RankName
set gender='Neutral'
where language='hu';