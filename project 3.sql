--Question 1
SELECT prof_id, COUNT(prof_id)
FROM my_contact
GROUP BY prof_id
HAVING COUNT(prof_id) > 1
ORDER BY prof_id;

--Question 2
DELETE FROM my_contact
WHERE prof_id IN
(SELECT prof_id
FROM
(SELECT prof_id,
ROW_NUMBER() OVER(PARTITION BY prof_id
ORDER BY prof_id) AS row_num
FROM my_contact) t
WHERE t.row_num > 1);

drop table contact_seeking;
drop table contact_interests;

--Question 3

create table my_contact(
contact_id bigserial constraint contact_key primary key,
last_name varchar(100),
first_name varchar(100),
phone varchar(10),
email varchar(100),
gender varchar(10),
birthday date,
prof_id integer references profession (prof_id),
zip_code integer references zipcode (zip_code),
status_id integer references status (status_id)


);

select * from my_contact;

select * from zipcode;
--Question 4

insert into my_contact(last_name, first_name, phone, email, gender, birthday, prof_id, zip_code, status_id)
values ('Smith', 'John', '0831112020', 'jsmith@mail.com', 'male', '1970-01-01', 3, 1, 1),
	   ('jones', 'Jim', '0831200000', 'jjones@mail.com', 'male', '1977-11-11', 2, 1, 1),
	   ('Edwards', 'ben', '0831200001', 'bedwards@mail.com', 'male', '1969-12-23', 1, 2, 2),
	   ('Vedder', 'Edna', '0831200002', 'evedder@mail.com', 'female', '1978-01-16', 4, 3, 1),
	   ('Mags', 'Sherley', '0831200003', 'smags@mail.com', 'female', '1997-09-11', 4, 4, 1),
	   ('Tully', 'Jerremy', '0831200004', 'jtully@mail.com', 'male', '2000-07-13', 5, 7, 2),
	   ('Baxter', 'Sally', '0831200005', 'sbaxter@mail.com', 'female', '1999-10-19', 1, 8, 1),
	   ('Abby', 'Mike', '0831200006', 'mabby@mail.com', 'male', '2002-06-09', 3, 9, 1),
	   ('Jabb', 'Nathan', '0831200007', 'njabb@mail.com', 'male', '2002-06-09', 3, 9, 1),
	   ('Lexington', 'Nigel', '0831200008', 'nlexton@mail.com', 'male', '2002-06-09', 1, 16, 2),
	   ('Scott', 'Sean', '0831200009', 'sscott@mail.com', 'male', '2002-06-09', 4, 9, 1),
	   ('Wright', 'Leigh', '0831200010', 'lwright@mail.com', 'female', '2002-06-09', 1, 2, 1),
	   ('Mills', 'Dana', '0831200011', 'dmills@mail.com', 'female', '2002-06-09', 3, 2, 1),
	   ('Westcot', 'Ben', '0831200012', 'bwestcot@mail.com', 'male', '2002-06-09', 5, 1, 2),
	   ('Rakes', 'Kelly', '0831200013', 'krakes@mail.com', 'female', '2002-06-09', 2, 1, 1),
	   ('Bates', 'Cathy', '083120014', 'cbates@mail.com', 'female', '1968-10-17', 4, 2, 1);

select * from profession;
--Question 5

WITH RECURSIVE prof_and_name AS (
    select contact_id, prof_id, first_name FROM my_contact
    )
select * from prof_and_name
WHERE prof_id > 3;

--Question 6

SELECT contact_id, email
FROM my_contact
ORDER BY contact_id
FETCH FIRST ROW ONLY;

--Question 7
select * from profession;
SELECT my_contact.contact_id, my_contact.prof_id, email, profession.profession_name, profession.prof_id
FROM my_contact
INNER JOIN profession ON my_contact.prof_id = profession.prof_id
WHERE my_contact.prof_id= 3;

select * from profession;
SELECT my_contact.contact_id, my_contact.prof_id, email, profession.profession_name, profession.prof_id
FROM my_contact
INNER JOIN profession ON my_contact.prof_id = profession.prof_id
ORDER BY my_contact.prof_id ;


--Qusetion 8

SELECT
s1.zip_code,
s2.zip_code,
s1.email
FROM
my_contact s1
INNER JOIN zipcode s2 ON s1.zip_code <>
s2.zip_code;

--Question 9

SELECT email, profession_name
FROM my_contact e
FULL OUTER JOIN profession d ON d.prof_id =
e.prof_id;

--Question 10

SELECT email, profession_name
FROM  my_contact e
FULL OUTER JOIN profession d ON d.prof_id =
e.prof_id
WHERE
email IS NULL;

--Question 13

SELECT
my_contact.email,
my_contact.prof_id,
profession.prof_id,
profession.profession_name
FROM
my_contact
LEFT JOIN profession ON my_contact.prof_id = profession.prof_id
;

--Question 12

CREATE TABLE Labels (label CHAR(1) PRIMARY KEY);
CREATE TABLE Scores (score INT PRIMARY KEY);
INSERT INTO Labels (label)
VALUES ('F'), ('C');
INSERT INTO Scores (score)
VALUES (1), (2);
SELECT * FROM Labels CROSS JOIN Scores;


--Question 13

SELECT * FROM my_contact NATURAL JOIN zipcode;

--Question 14()

SELECT * FROM profession
UNION ALL
SELECT *
FROM zipcode
ORDER BY zip_code asc;

--Question 15

SELECT email, prof_id
INTO profession_email
FROM my_contact
group by email, prof_id
Having prof_id>AVG(prof_id);

--Question 16a

select AVG(status_id)
FROM status

--Question16b

SELECT random() * 100 + 1 AS RAND_1_100;

--Question 17

SELECT email, prof_id
FROM my_contact
WHERE prof_id > (
SELECT AVG (prof_id) FROM profession
);

--Qusetion 18

SELECT relname, relpages FROM pg_class ORDER BY
relpages DESC limit 1;

--Question 19

SELECT DISTINCT				
contact_id, status_id
FROM my_contact
WHERE status_id > (
SELECT AVG (status_id) FROM my_contact);


--Question 20(1)

SELECT contact_id, email, count(*)
FROM my_contact
GROUP BY ROLLUP(contact_id, email)

--Question 21(2)

SELECT contact_id, email, count(*)
FROM my_contact
GROUP BY CUBE(contact_id, email)

--Question 22(3)

CREATE INDEX email_index ON my_contact(email);

CREATE INDEX phone_index ON my_contact(phone);

--Question 23(4)

SELECT contact_id, email, phone, prof_id 
FROM my_contact
WHERE prof_id > 2
GROUP BY contact_id
HAVING count(zip_code) > 0;

select * from my_contact;


--Question 24(5)

CREATE OR REPLACE FUNCTION record_insert()
RETURNS trigger AS
$$
BEGIN
INSERT INTO profession(prof_id)
VALUES(new.prof_id);
RETURN NEW;
END;
$$
LANGUAGE 'plpgsql';


--Question 25(6)

SELECT contact_id, email, phone, prof_id 
From my_contact a
WHERE NOT EXISTS
(
SELECT NULL
From profession b
WHERE a.prof_id = b.prof_id + 1
)
ORDER BY a.contact_id

--Question 26(7)*

SELECT
	email,
	prof_id,
	status_id,
	RANK () OVER ( 
		PARTITION BY prof_id
		ORDER BY status_id)
FROM
my_contact;

--Question 27(8)*

SELECT
	email,
	prof_id,
	status_id,
	Dense_RANK () OVER ( 
		PARTITION BY prof_id
		ORDER BY status_id)
FROM
my_contact;


--Question 28(9)

SELECT email, birthday,
FIRST_VALUE(birthday) OVER (
	ORDER BY birthday
) AS oldest
FROM my_contact;

--Qusetion 29(10)

SELECT email, birthday,
Last_VALUE(birthday) OVER (
	ORDER BY birthday
) AS oldest
FROM my_contact;

--Question 30(11)


EXPLAIN SELECT * FROM my_contact
QUERY PLAN
-------------------------------------------------------
------
Seq Scan on my_contact (cost=0.00..451.00 rows=15000
width=364)


--Question 31(12)

CREATE ROLE jeff
LOGIN
PASSWORD 'myPass1';

SELECT rolname FROM pg_roles;


--Question 32(13)
CREATE ROLE emp;

GRANT emp TO jeff;