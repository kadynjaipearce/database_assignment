CREATE VIEW
    movie_view AS
SELECT
    m.movie_id,
    movie_name,
    release_date,
    movie_duration,
    rating_id,
    rating_name,
    minimum_age,
    STRING_AGG (genre_name, ', ')
FROM
    movie AS "genres"
    INNER JOIN rating AS r ON m.rating_id = r.rating_id
    INNER JOIN movie_genre AS mg ON m.movie_id = mg.movie_id
    InnER JOIN genre AS g ON mg.genre_id = g.genre_id
GROUP BY
    m.movie_id,
    movie_name,
    release_date,
    movie_duration,
    rating_id,
    rating_name,
    minimum_age GO
CREATE VIEW
    session_view AS
SELECT
    s.session_id,
    s.date_time AS "session_time",
    s.ticket_cost,
    m.movie_id,
    m.movie_name,
    r.rating_id,
    r.rating_symbol,
    c.cinema_id,
    c.cinema_name,
    CAST(c.row_total AS int) * CAST(c.seat_total AS int) AS "capacity",
    ct.type_name,
    COUNT(t.ticket_id) AS "tickets_sold"
FROM
    session AS s
    FULL JOIN movie AS m ON s.movie_id = m.movie_id
    INNER JOIN rating AS r ON m.rating_id = r.rating_id
    INNER JOIN cinema AS c ON s.cinema_id = c.cinema_id
    INNER JOIN cinema_type AS ct ON c.type_id = ct.type_id
    LEFT JOIN ticket AS t ON s.session_id = t.session_id
GROUP BY
    s.session_id,
    s.date_time,
    s.ticket_cost,
    m.movie_id,
    m.movie_name,
    r.rating_id,
    r.rating_symbol,
    c.cinema_id,
    c.cinema_name,
    ct.type_name,
    c.row_total,
    c.seat_total GO