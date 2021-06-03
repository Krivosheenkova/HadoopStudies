
/* 1. Создать таблицы в форматах PARQUET/ORC/AVRO c компрессией и без. (Выберите один вариант, например ORC с компрессией) */

-- $ ssh  -i ~/.ssh/id_rsa_el_student_4652746 el_student_4652746@37.139.32.56 -D localhost:8080
-- $ ssh el_student_4652746@10.0.0.19
-- $ beeline

use el_student_4652746;

SET parquet.compression=SNAPPY;

create table el_student_4652746.users_parquet_compressed 
	(Id string,
	SubmittedUserId string,
	TeamId string,
	SourceKernelVersionId string,
	SubmissionDate string,
	ScoreDate string,
	IsAfterDeadline string,
	PublicScoreFullPrecision string,
	PrivateScoreFullPrecision string)
stored as parquet;

create table el_student_4652746.users_orc 
	(Id string,
	SubmittedUserId string,
	TeamId string,
	SourceKernelVersionId string,
	SubmissionDate string,
	ScoreDate string,
	IsAfterDeadline string,
	PublicScoreFullPrecision string,
	PrivateScoreFullPrecision string)
stored as orc;


/* 2. Заполнить данными из ваших таблиц, либо при создании таблицы либо отдельно (Insert into <new-table> select * from <csv-table>) */

insert into el_student_4652746.users_orc select * from el_student_4652746.users;
insert into el_student_4652746.users_parquet_compressed select * from el_student_4652746.users;


/* 3. Посмотреть на получившийся размер данных */

-- $ hdfs dfs -du -h /user/el_student_4652746/krivosheenkova/kaggle.db/users
-- 167.1 M  334.2 M  /user/el_student_4652746/krivosheenkova/kaggle.db/users/users.csv

-- $ hdfs dfs -du -h /warehouse/tablespace/managed/hive/el_student_4652746.db
-- 59.1 M   118.3 M  /warehouse/tablespace/managed/hive/el_student_4652746.db/users_orc
-- 104.4 M  208.9 M  /warehouse/tablespace/managed/hive/el_student_4652746.db/users_parquet_compressed


/* 4. Посчитать count некоторых колонок в разных форматах хранения. */

select count(id) from users; -- 29.876 seconds
select count(id) from users_parquet_compressed; -- 0.168 seconds
select count(id) from users_orc; -- 0.134 seconds

select scoredate, count(scoredate), (select count(scoredate) from users) overall from users  group by scoredate; -- 27.484 seconds
select scoredate, count(scoredate), round(count(scoredate) / (select count(scoredate) from users), 2) * 100 overall from users group by scoredate; -- 28.721 seconds

/* 5. Посчитать агрегаты по одной и нескольким колонкам в разных форматах. */

select 
    avg(users_count) average_users_by_team, 
    sum(users_count) overall_users_in_teams, 
    max(users_count) largest_group 
from 
    (select     
        teamid,
        count(*) as users_count
    from el_student_4652746.users 
    group by teamid) t
;
/* 36.673 seconds */

select 
    avg(users_count) average_users_by_team, 
    sum(users_count) overall_users_in_teams, 
    max(users_count) largest_group 
from 
    (select     
        teamid,
        count(*) as users_count
    from el_student_4652746.users_orc 
    group by teamid) t
;
/* 16.584 seconds */
select 
    avg(users_count) average_users_by_team, 
    sum(users_count) overall_users_in_teams, 
    max(users_count) largest_group 
from 
    (select     
        teamid,
        count(*) as users_count
    from el_student_4652746.users_parquet_compressed 
    group by teamid) t
;
/* 13.234 seconds */ 


/* 6. Сделать выводы об эффективности хранения и компресии. */

/* колочно-ориентированные форматы (Parquet, ORCFile) быстрее считывают данные из файла за счет пропуска ненужных столбцов и занимают меньше места на диске, но ORC быстрее и легче.