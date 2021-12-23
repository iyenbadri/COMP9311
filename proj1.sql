-- comp9311 20T3 Project 1
--
-- MyMyUNSW Solutions


-- Q1:
create or replace view Q1(staff_role, course_num)
as
select distinct cs.role, cs.course from course_staff AS cs
INNER JOIN semesters AS s ON c.semester= s.id
where s.year= 2010
Order by cs.course
;

-- Q2:
create or replace view Q2(course_id)
as
select distinct cl.course AS course_num from classes AS cl
INNER JOIN class_types AS ctype ON cl.ctype= ctype.id
where ctype.name= 'Studio'
GROUP BY cl.course
;

-- Q3:
create or replace view Q3A AS
select cl.course, cl.room from classes cl
INNER JOIN rooms r ON cl.room= r.id;

create or replace view Q3B
AS 
select rf.room, rf.facility, fac.description from room_facilities as fac on rf.facility= fac.id where fac.description= 'Student wheelchair access' OR fac.description= 'Teacher wheelchair access';

create or replace view Q3(course_num)
as select q3a.course from q3a
INNER JOIN q3b ON Q3a.room= Q3b.room;
;

-- Q4:
create or replace view Q4(unswid,name)
as
select val.unswid, val.name
from (select p.unswid, p.name, p.id frompeople p join students stu on p.id= stu.id where stu.stype= 'local') as val
join (select ce.student, count(code) as co)
from course_enrolments ce
join courses c on ce.course= c.id
join subjects s on c.subject= s.id
where (s.offeredby= (select id from orgunits where name=' School of Chemical Sciences' and ce.mark>87
group by ce.student) as sal
on val.id= sal.student and sal.co=2);
;


-- Q6:
create or replace view Q6A
as
select semesters.longname, count(distinct(courses.id)) as c from courses INNER JOIN semesters ON courses.semester= semesters.id
GROUP BY semesters.longname ORDER BY c desc
;
create or replace view Q6(semester, course_num)
as
select longname, c as c1 from Q6A
where Q6A.c>= (select max(c) from Q6A)
;

-- Q7:
create or replace view Q7(course_id, avgmark, semester)
as
--... SQL statements, possibly using other views/functions defined by you ...
;

-- Q8: 
create or replace view Q8A as
select student from course_enrolments ce
join courses c on ce.course = c.id
join subjects s on c.subject= s.id
join orgunits o on s.offeredby= o.id
where o.name LIKE '%Engineering';

create or replace view Q8(num)
as
select count(distinct p.unswid) from (select id, unswid, name from people where unswid is not null) as p,
(
select student 
from (
select student
    from (
    select * from program_enrolments pge
    join stream_enrolments se on pge.id = se.partof
    join streams s on se.stream = s.id 
    where s.name = 'Medicine'
    ) as mg, semesters sem
    where mg.semester = sem.id and sem.year = '2009' or sem.year= '2010'
    and student not in (select student from Q8A)
) as intl_students, students where intl_students.student = students.id and students.stype = 'intl'
) as tot_students
where tot_students.student = p.id;

;

-- Q9:
create view Q9A:
select * from (
    select db.id as subject, courses.semester, courses.id as c,db.code as cc 
    from (select id, code from subjects where name = 'Database Systems') as db 
    join courses on db.id= courses.subject
    ) as db_enrol join course_enrolments ce on ce.course = db_enrol.code where mark is not null
    ) as average_sem group by semester;

 create or replace view Q9(year,term,average_mark)
as
 select year, term, final.average from (
     select semester, cast(avg(mark) as numeric(4,2)) as average from 
    (
    select Q9A.semester, Q9A.term,Q9A.average_sem
 from Q9A) as A join semesters on semesters.id = A.semester
;



-- Q12:
create or replace view Q12(unswid, longname)
select rooms.unswid as unswid, rooms.longname as longname from rooms
INNER JOIN buildings on rooms.building= buildings.id
where rooms.rtype=(select id from room_types where description= 'Lecture Theatre') AND buildings.name= 'Mathews Building'
;
