
use el_student_4652746.users;

-- users table
create external table users 
(Id string,
SubmittedUserId string,
TeamId string,
SourceKernelVersionId string,
SubmissionDate string,
ScoreDate string,
IsAfterDeadline string,
PublicScoreFullPrecision string,
PrivateScoreFullPrecision string)
row format serde 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
location "/user/el_student_4652746/krivosheenkova/kaggle.db/users"
tblproperties ("skip.header.line.count"="1");

-- submissions table
create external table submissions 
(Id string,
UserName string, 
DisplayName string,
RegisterDate string,
PerformanceTier string)
row format serde 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
location "/user/el_student_4652746/krivosheenkova/kaggle.db/submissions"
tblproperties ("skip.header.line.count"="1");


-- submissions count by year
select 
	year(dt) submissions_year, 
	count(*) submissions_count 
from 
	(select 
		to_date(from_unixtime(UNIX_TIMESTAMP(submissiondate, 'MM/dd/yyyy'))) as dt 
	from el_student_4652746.users) t 
group by year(dt) 
order by submissions_year;


-- some kaggle teams stats 
select 
	avg(users_count) average_users_by_team, 
	sum(users_count) overall_users_in_teams, 
	max(users_count) largest_group 
from 
	(select 
		teamid, 
		count(*) as users_count  
	from 
		(select 
			s.username, 
			u.teamid 
		from submissions as s 
		left join el_student_4652746.users as u 
		on u.id = s.username) t
	group by teamid) t1;
