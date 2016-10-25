/*
1.Develop an assertion, written in SQL, that enforces the requirement
that allows a benefit plan must be entitled to the benefit that the 
benefit plan is a part of.
*/
create assertion BenefitPlanEntitledToBenefit
	check (exists (
			select *
            from BenefitPlan bp, Position pos, Permission perm
            where bp.id = perm.allows
            and perm.allowedFor = pos.id
            and exists (
					select *
                    from Benefit b, Entitles ent
                    where pos.id = ent.entitledBy
                    and ent.entitledTo = b.bid
                    and b.id = bp.partOf)));

/*
2.Develop an assertion, written in SQL, that enforces the requirement
that an employee who selects a benefit plan must have a position that
is entitled to the benefit and allows this benefit plan.
*/
create assertion EmployeeSelectsBenefitPlan
	check (exists (
			select *
            from Employee e, Selection sel, Permission perm, Entitles ent
            where e.id = sel.selectedBy
            and sel.usesPlan = perm.allows
            and perm.allowedFor = ent.entitledBy
            and ent.entitledTo = sel.selects
            and e.servesAs = perm.allowedFor));

/*
3.Develop an assertion, written in SQL, that enforces the requirement
that every family benefit plan selected by an employee include the
family relationships of all dependents of the employee.
*/
create assertion EmployeeDependentsIncludesFamilyRelationships
	check (not exists (
			select *
            from Dependent d, Selection s, FamilyBenefitPlan fbp
            where d.dependsOn = s.slectedBy
            and s.usesPlan = fbp.id
            and d.relatedBy not in (
					select finc.includes
                    from FamilyIncludes finc
                    where finc.family = fbp.id)));

/*
4.Give the user 'HRAgent' the ability to modify the cost of a benefit
plan (by name and description) allowed for a position (by title)
during a pay period (by duration). Modification includes adding and
deleting as well as updating cost records.

Create a view of all Permissions with the corrosponding details from BenefitPlan
and Position that the HRAgent can have access to and provide select access to this
view. Provide select access to PayPeriod. Provide modify/create access to Cost
table so that HRAgent can add, remove or change records in Cost table.
*/
create view PermissionsWithDetails (allows, allowedFor, planName, planDescription, positionTitle) as
	select perm.allows, perm.allowedFor, bp.name, bp.description, pos.title
	from BenefitPlan bp, Position pos, Permission perm
	where bp.id = perm.allows
	and perm.allowedFor = pos.id;

grant select on PermissionsWithDetails to 'HRAgent';
grant select on PayPeriod to 'HRAgent';
grant select, update, insert, delete on Cost to 'HRAgent';

/*
5.The following are the main commands being performed on this database:
 a.Insert a new employee given the person details and the benefits selected
	- while inserting, user queries person based on name. So hash on 
	  name is sufficient.
	- while inserting into Selection table, user queries based on Employee 
	  details (servesAs, address and email) so hashes on these also are sufficient 
	  (and also there is a uniqueness contraint on email which requires hash index).
 b.Find the benefit plan information given the position
	- to get benefit plan information, we need to join Position and Permission
	  tables by comparing on allowedFor column on Permission. So a hash index is sufficient.
 c.List all the benefit plans along with the benefit type and order by the plan name
	- we need to join BenefitPlan with Benefit on Benefit's id so a hash index is
	  sufficient on this (but anyway there is a primary key index on this) and a 
	  Btree on plan name to order by it.
 d.Compute the average pay duration for each positions
	- we need to join Permission with Cost and then with PayPeriod so a hash index on
	  Cost.costsAllowedFor is suffecient and there is a primary key index on PayPeriod.id
	  anyway. You need a B-tree index on Permission.allowedFor, Permission.allows to 
	  group by allowedFor.
 e.List the benefit plans for people whose names begin with some letter
	- we need to join BenefitPlan, Selection, Employee and then Person (in that order) and
	  hence a hash on Selection.usesPlan is sufficient and Employee.id already has a primary
	  key index. A Btree index on Person.name is required to fiter on range match on name that
	  start with something.
List the candidate indexes for collection of queries and commands.
Note that the solution is a single collection of candidate indexes
for all queries and commands, not a collection for each query and
command.

SOLUTION:
Person. Hash on id.					//primary key
Person. Btree on name.					//for query 5; query 1 requires Hash

Position. Hash on id.					//primary key

Employee. Hash on id.					//primary key
Employee. Hash on serveAs.				//for query 1
Employee. Hash on address.				//for query 1
Employee. Hash on email.				//uniqueness

Dependent. Hash on hasDependent.			//primary key

Benefit. Hash on id.					//primary key

BenefitPlan. Hash on id.				//primary key
BenefitPlan. Btree on name.				//for query 3

Selection. Hash on (selectedBy, selects).		//primary key
Selection. Hash on usesPlan				//for query 5

Individual. Hash on id.					//primary key

Family. Hash on id.					//primary key

FamilyIncludes. Hash on family.				//primary key

PayPeriod. Hash on id.					//primary key

Entitlement. Hash on (entitleTo, entitledBy).		//primary key

Permission. B-tree on (allowedFor, allows).		//primary key; for query 4(group by) & 2

Cost. Hash on (costsAllowedFor, during, costsAllows).	//primary key
Cost. Hash on costsAllowedFor.				//for query 4
*/
