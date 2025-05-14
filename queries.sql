-- Todo: implement all the queries in this file.
SELECT
    movie_name,
    date_time AS 'session_time',
    ticket_cost
FROM
    session_view
WHERE
    movie_duration < 90
    AND (
        rating_symbol = 'G'
        OR rating_symbol = 'PG'
    )