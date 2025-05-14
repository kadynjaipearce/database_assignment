-- Todo: implement all the queries in this file.
SELECT
    movie_name,
    date_time AS 'session_time',
    ticket_cost
FROM
    session_view AS s
    INNER JOIN movie AS m ON s.movie_id = m.movie_id
WHERE
    movie_duration < 90
    AND rating_id IN ("G", "PG")