-- Student Number(s): 10687576, 10651220 
-- Student Name(s):   Timothy Tolj, Kadyn Pearce

USE theatre;

SELECT
    movie_name,
    date_time AS 'session_time',
    ticket_cost
FROM
    session_view AS s
    INNER JOIN movie AS m ON s.movie_id = m.movie_id
WHERE
    movie_duration < 90
    AND rating_id IN ("G", "PG");

SELECT
    m.movie_id,
    m.movie_name,
    m.movie_blurb,
    COUNT(r.movie_id) AS 'num_reviews',
    ROUND(AVG(s.rating_value), 1) AS 'average_rating'
FROM
    movie_view AS m
    INNER JOIN review AS r ON m.movie_id = r.movie_id
    INNER JOIN rating AS s ON r.rating_id = s.rating_id
GROUP BY
    m.movie_id,
    m.movie_name,
    m.movie_blurb;

SELECT
    CONCAT (
        movie_name, " (", DATEPART (year, release_date), ")"
    ) AS movie_title,
    CONCAT (rating_symbol, minimum_age) AS rating,
    IIF(movie_duration, CONCAT(movie_duration / 60, "h ", movie_duration % 60, "m"), '0h 0m') AS "duration"
FROM
    movie
    INNER JOIN rating ON movie.rating_id = rating.rating_id
ORDER BY duration;

SELECT DISTINCT CONCAT (c.first_name, " ", c.last_name) AS "customer", c.birth_date AS "dob", m.movie_name
FROM customer AS c 
INNER JOIN ticket AS t ON c.customer_id = t.customer_id
INNER JOIN session AS s ON s.session_id = t.session_id
INNER JOIN movie AS m ON m.movie_id = s.movie_id
INNER JOIN rating AS r ON m.rating_id = r.rating_id
WHERE DATEDIFF(year, c.birth_date, s.date_time) >= r.minimum_age;

-- Number of movies per genre, with comma-separated movie names
SELECT
    g.genre_name,
    COUNT(mg.movie_id) AS num_movies,
    COALESCE(STRING_AGG(m.movie_name, ', ') WITHIN GROUP (ORDER BY m.movie_name), '') AS movie_names
FROM
    genre AS g
    INNER JOIN movie_genre AS mg ON g.genre_id = mg.genre_id
    INNER JOIN movie AS m ON mg.movie_id = m.movie_id
GROUP BY
    g.genre_id, g.genre_name
ORDER BY
    num_movies DESC;



SELECT 
    session_id, s.date_time, c.cinema_name, c.row_total, c.seat_total
FROM ticked AS t 
INNER JOIN session AS s ON t.session_id = s.session_id
INNER JOIN cinema AS c ON s.cinema_id = c.cinema_id

WHERE s.date_time > GETDATE() AND CHARINDEX(UPPER(RIGHT), "ABCDEFGHIJKLMNOPQRSTUVWXYZ") > row_total
ORDER BY s.date_time;


-- ============================================================================
-- Query: Customer Purchase and Review Summary
--
-- Description:
--   Retrieves a summary of each customer's activity, including their formatted
--   name, number of tickets purchased, total amount spent, number of reviews
--   left, and the date of their first session attended.
--
-- Columns:
--   customer_id        : Unique identifier for the customer.
--   name               : Customer's first name and initial of last name (capitalized).
--   tickets_purchased  : Total number of distinct tickets purchased by the customer.
--   total_spent        : Total amount spent by the customer on tickets.
--   reviews_written       : Number of distinct reviews left by the customer.
--   first_session      : Date of the customer's first session attended.
--
-- Joins:
--   - LEFT JOIN ticket: Links customers to their tickets.
--   - LEFT JOIN review: Links customers to their reviews.
--   - LEFT JOIN session: Links tickets to session details.
--
-- Grouping:
--   Groups results by customer to aggregate their activity.
-- ============================================================================

SELECT 
    c.customer_id,
    CONCAT(c.first_name, " ", UPPER(LEFT(c.last_name, 1)), ".") AS 'name',
    COUNT(DISTINCT t.ticket_id) AS 'tickets_purchased',
    SUM(s.ticket_cost) AS 'total_spent', 
    COUNT(DISTINCT r.review_id) AS 'reviews_written',
    MIN(s.session_date) AS 'first_session'
FROM customer AS c 
LEFT JOIN ticket AS t ON c.customer_id = t.customer_id
LEFT JOIN review AS r ON r.customer_id = c.customer_id
LEFT JOIN session AS s ON t.session_id = s.session_id
GROUP BY c.customer_id, c.first_name, c.last_name;
