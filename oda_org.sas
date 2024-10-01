%let vars = EID, Name, JobTitle, SupervisorName, EMPLOYEE_CONSTITUENT_ID;
%let year = 2024;
%let month = 01SEP;

proc sql;
	create table l1 as 
	select &vars. 
	from edefdb.pers&year.&month.
	where EMPLOYMENT_SUPERVISOR_ID eq '235649' or EID eq '235649' /* Jess and Jess's Reports */;

	create table l2 as
	select &vars. from 
	edefdb.pers&year.&month.
	where EMPLOYMENT_SUPERVISOR_ID in (select eid from l1);

	create table l3 as
	select &vars. from 
	edefdb.pers&year.&month.
	where EMPLOYMENT_SUPERVISOR_ID in (select eid from l2);

	create table l4 as
	select &vars. from 
	edefdb.pers&year.&month.
	where EMPLOYMENT_SUPERVISOR_ID in (select eid from l3);

	create table oda as
	select distinct * from l1 
	union 
	select * from l2 
	union 
	select * from l3 
	union 
	select * from l4
	;

quit;

/*

proc sql;
	create table report_to_jess as 
	select * 
	from edefdb.pers202401SEP
	where EMPLOYMENT_SUPERVISOR_ID eq '235649' or EID eq '235649' ;

	create table report_to_report_to_jess as
	select * from 
	edefdb.pers202401SEP
	where EMPLOYMENT_SUPERVISOR_ID in (select eid from report_to_jess) or EMPLOYMENT_SUPERVISOR_ID in ('294368' '387027' '335159');

	create table oda as
	select * from report_to_jess
	union 
	select * from report_to_report_to_jess;

	create identikey as
		select distinct 
		HREMPLID, Identikey 
			from latestdb.ucb_uuid 
			where HREMPLID in (select EID from oda);

	create table oda_identikey as
	select a.EID,
		   a.Name,
		   b.Identikey,
		   a.SupervisorName,
		   a.JobTitle
	from oda a
	left join
		identikey b
		on a.EID = b.HREMPLID;
quit;

%xlsexport(M:\Decrypt\oda_identikey.xlsx, oda_identikey);*/
