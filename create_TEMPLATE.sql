-- Student Number(s): 10687576, 10651220 
-- Student Name(s):   Timothy Tolj, Kadyn Pearce
/*	Database Creation & Population Script (6 marks)
Write a script to create the database you designed in Task 1 (incorporating any changes you have made since then).  
Give your columns the same data types, properties and constraints specified in your data dictionary, and name your tables and columns consistently.  
Include any suitable default values and any necessary/appropriate CHECK or UNIQUE constraints.

Make sure this script can be run multiple times without resulting in any errors (hint: drop the database if it exists before trying to create it).
Adapt the code at the start of the �company.sql� file (Module 5) to implement this.  

See the brief for further information. 
 */
-- Write your creation script here
IF DB_ID ('theatre') IS NOT NULL BEGIN PRINT 'Database exists - dropping.';

USE master;

ALTER DATABASE theatre
SET
	SINGLE_USER
WITH
	ROLLBACK IMMEDIATE;

DROP DATABASE theatre;

END GO PRINT 'Creating database.';

CREATE DATABASE theatre;

GO USE theatre;

GO PRINT 'Creating rating table...';

CREATE TABLE rating 
	(
		rating_id TINYINT NOT NULL PRIMARY KEY IDENTITY,
		rating_symbol CHAR(2) NOT NULL UNIQUE,
		rating_name VARCHAR(25) NOT NULL UNIQUE,
		minimum_age TINYINT NOT NULL DEFAULT (0)
	)

CREATE TABLE genre 
	(
		genre_id TINYINT NOT NULL PRIMARY KEY IDENTITY,
		genre_name VARCHAR(25) NOT NULL UNIQUE
	)

CREATE TABLE movie 
	(
		movie_id INT NOT NULL PRIMARY KEY IDENTITY,
		movie_name NVARCHAR (50) NOT NULL UNIQUE,
		release_date DATE NOT NULL,
		movie_duration SMALLINT NOT NULL,
		movie_blurb VARCHAR(1024) NULL,
		rating_id TINYINT NOT NULL REFERENCES rating(rating_id),

		UNIQUE (movie_name, release_date)
	)

CREATE TABLE movie_genre 
	(
		movie_id INT NOT NULL REFERENCES movie(movie_id),
		genre_id TINYINT NOT NULL REFERENCES genre(genre_id),

		PRIMARY KEY (movie_id, genre_id)
	)

CREATE TABLE cinema_type 
	(
		type_id INT NOT NULL PRIMARY KEY IDENTITY,
		type_name VARCHAR(25) NOT NULL UNIQUE
	)

	/*	Database Population Statements
	Following the SQL statements to create your database and its tables, you must include statements to populate the database with sufficient test data.
	You are only required to populate the database with enough data to make sure that all views and queries return meaningful results.
	
	You can start working on your views and queries and write INSERT statements as needed for testing as you go.
	The final create.sql should be able to create your database and populate it with enough data to make sure that all views and queries return meaningful results.
	
	Data has been provided for some of the tables.
	Adapt the INSERT statements as needed, and write your own INSERT statements for the remaining tables.
	 */
	/*	The following statement inserts the details of 5 classification ratings into a table named "rating".
	It specifies values for columns named "rating", "rating_name" and "min_age".
	If required, change the table and column names to match those in your database.
	You may use NULL instead of 0 for the first three classifications if preferred, but will need to account for this in certain queries if so.
	 */
INSERT INTO
	rating (rating, rating_name, min_age)
VALUES
	('G', 'General', 0),
	('PG', 'Parental Guidance', 0),
	('M', 'Mature', 0),
	('MA', 'Mature Audiences', 15),
	('R', 'Restricted', 18);

/*	The following statement inserts the details of 10 genres into a table named "genre".
It specifies values for a column named "genre_name", and it is assumed that the primary key column is an auto-incrementing integer.
If required, change the table and column names to match those in your database.
 */
INSERT INTO
	genre (genre_name)
VALUES
	('Action'), -- Genre 1
	('Adventure'), -- Genre 2
	('Animation'), -- Genre 3
	('Comedy'), -- Genre 4
	('Crime'), -- Genre 5
	('Drama'), -- Genre 6
	('Fantasy'), -- Genre 7
	('Horror'), -- Genre 8
	('Romance'), -- Genre 9
	('Sci-Fi');

-- Genre 10
/*	The following statement inserts the details of 3 cinema types into a table named "cinema_type".
It specifies values for a column named "cinema_type_name", and it is assumed that the primary key column is an auto-incrementing integer.
If required, change the table and column names to match those in your database.
 */
INSERT INTO
	cinema_type (cinema_type_name)
VALUES
	('Budget'),
	('Standard'),
	('Gold Class');

-- Write your INSERT statements for the remaining tables here