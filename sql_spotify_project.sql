-- SQL PROJECT - SPOTIFY --
--CREATE TABLE--
-- create table
DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);

--EDA--
SELECT COUNT (*) FROM spotify;

SELECT COUNT (DISTINCT artist) FROM spotify;

SELECT DISTINCT album_type FROM spotify;
 
SELECT MAX(duration_min) FROM spotify;
SELECT MIN(duration_min) FROM spotify;

SELECT * FROM spotify WHERE duration_min = 0;

DELETE FROM spotify 
WHERE duration_min = 0;

SELECT * FROM spotify
WHERE duration_min = 0;

SELECT DISTINCT channel FROM spotify;

/*
-- ------------------------------
-- DATA ANALYSIS EASY CATEGORY--
-- ------------------------------
1.Retrieve the names of all tracks that have more than 1 billion streams.
2.List all albums along with their respective artists.
3.Get the total number of comments for tracks where licensed = TRUE.
4.Find all tracks that belong to the album type single.
5.Count the total number of tracks by each artist.
*/ 

--Q1.Retrieve the names of all tracks that have more than 1 billion streams.
SELECT *
FROM spotify
WHERE stream > 1000000000;

--Q2.List all albums along with their respective artists.
SELECT DISTINCT album, artist 
FROM spotify;

--Q3.Get the total number of comments for tracks where licensed = TRUE.
SELECT  
	SUM(comments) AS total_comments 
FROM spotify 
WHERE licensed = 'true';

--Q4.Find all tracks that belong to the album type single.
SELECT *
FROM spotify
WHERE album_type = 'single' ; 

--Q5.Count the total number of tracks by each artist.
SELECT artist ,
COUNT (track) AS total_tracks
FROM spotify
GROUP BY artist
ORDER BY 2;

/*
-- ------------------------------
-- DATA ANALYSIS MEDIUM CATEGORY--
-- ------------------------------

Calculate the average danceability of tracks in each album.
Find the top 5 tracks with the highest energy values.
List all tracks along with their views and likes where official_video = TRUE.
For each album, calculate the total views of all associated tracks.
Retrieve the track names that have been streamed on Spotify more than YouTube.
*/

--Q6. Calculate the average danceability of tracks in each album.
SELECT 
	AVG(danceability) 
	AS avg_danceability , album 
FROM spotify GROUP BY 2 ;

--Q7. Find the top 5 tracks with the highest en ergy values.
SELECT track ,
MAX (energy) as Highest_energy 
FROM spotify
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

--Q8. List all tracks along with their views and likes where official_video = TRUE.
SELECT track ,
SUM (views) AS total_views,
SUM (likes) AS total_likes
FROM spotify
WHERE official_video = 'true'
GROUP BY 1
ORDER BY 2 DESC , 3 DESC;

--Q9. For each album, calculate the total views of all associated tracks.
SELECT 
	album , 
	track ,
	SUM(views) AS total_views 
FROM spotify
GROUP BY 1 , 2 
ORDER BY 3 DESC;

--Q10. Retrieve the track names that have been streamed on Spotify more than YouTube.
SELECT *
FROM 
(SELECT 
	track,
	--most_played_on,
	COALESCE (SUM(CASE WHEN most_played_on = 'Youtube' THEN stream END),0) AS streamed_on_youtube,
	COALESCE (SUM(CASE WHEN most_played_on = 'Spotify' THEN stream END),0) AS streamed_on_spotify
FROM spotify
GROUP BY 1) AS t1
WHERE 
	streamed_on_spotify > streamed_on_youtube
	AND
	streamed_on_youtube <> 0;

/*
-- ------------------------------
-- ADVANCED CATEGORY--
-- ------------------------------

11. Find the top 3 most-viewed tracks for each artist using window functions.
12. Write a query to find tracks where the liveness score is above the average.
13. Use a `WITH` clause to calculate the difference between the highest and lowest energy values for tracks in each album.**
14. Find tracks where the energy-to-liveness ratio is greater than 1.2.
15. Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.
*/

--Q11 Find the top 3 most-viewed tracks for each artist using window functions.
WITH ranking_artist
AS
(SELECT
	artist,
	track,
	SUM(views),
	DENSE_RANK() OVER(PARTITION BY artist ORDER BY SUM(views) DESC) AS rank
FROM spotify
GROUP BY 1,2
ORDER BY 1,3 DESC
)
SELECT * FROM ranking_artist
WHERE rank <=3;

--Q!2. Write a query to find tracks where the liveness score is above the average.
SELECT 
	track,
	artist,
	liveness
FROM spotify
WHERE liveness >(SELECT AVG(liveness) FROM spotify)

SELECT AVG(liveness) FROM spotify; --0.19


--Q13.Use a `WITH` clause to calculate the difference between,
--the highest and lowest energy values for tracks in each album.
WITH cte 
AS
(SELECT 
	album,
	MAX(energy) AS highest_energy,
	MIN(energy) AS lowest_energy
from spotify
GROUP BY 1
) 

SELECT 
	album,
	highest_energy - lowest_energy AS energy_difference
FROM cte
ORDER BY 2 DESC









