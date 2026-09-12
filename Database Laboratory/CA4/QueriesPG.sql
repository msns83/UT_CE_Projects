-- 1. GENRE ANALYSIS --
-- This query tells which genres are watched the most and therefore drive the most traffic
-- It directs us where to invest more money on the future.
SELECT 
    f.genre, 
    COUNT(wh.fid) AS Total_Views
FROM Film f
JOIN WatchHistoryItem wh ON f.fid = wh.fid
GROUP BY f.genre
ORDER BY Total_Views DESC;

-- This one tells which genres brings people to comment section the most
-- The commenct section does only make users spend more time on the platform and get more engaged, it is a place to put advertisements.
SELECT 
    f.genre, 
    COUNT(c.fid) AS Comments_Count
FROM Film f
JOIN Comment c ON f.fid = c.fid
GROUP BY f.genre
ORDER BY Comments_Count DESC;


-- 2. MOST DISCUSSED CONTENT --
-- Measures virality. High comment count means a movie is highly conversational and therefore suitable for social media campaigns.
SELECT 
    f.title, 
    COUNT(c.comm_id) AS Total_Comments
FROM Film f
JOIN Comment c ON f.fid = c.fid
GROUP BY f.fid, f.title
ORDER BY Total_Comments DESC
LIMIT 5;


-- 3. MOST POPULAR NEW RELEASES --
-- The query blow points out top 5 watched movies released in the current year.
-- These movies are both popular and new so putting them on the front page would be a good choice.
SELECT 
    f.title, 
    f.genre, 
    COUNT(wh.uid) AS Unique_Viewers
FROM Cinematic c
JOIN Film f ON f.fid = c.fid
JOIN WatchHistoryItem wh ON f.fid = wh.fid
WHERE c.release_year BETWEEN '2020-01-01' AND '2027-01-01'
GROUP BY f.fid, f.title, f.genre
ORDER BY Unique_Viewers DESC
LIMIT 5;





-- 4. NEAR EXPIRATION ACCOUNTS --
-- This query finds accounts whose their subscription plan is going to expire within the next month
-- so that the marketing team would target those accounts for renewing/upgrading their plan
SELECT 
    a.phone, 
    sp.title AS Current_Plan, 
    a.end_date
FROM Account a
JOIN SubscriptionPlan sp ON a.sub_id = sp.sub_id
WHERE sp.title != 'Free' AND a.end_date BETWEEN '2026-05-01' AND '2026-07-31'
ORDER BY a.end_date ASC;


-- 5. NEWLY REGISTERED ACCOUNTS --
-- It monitors the number of newly registered accounts per month to evaluate performance of the corresponding marketing team.
SELECT 
    to_char(create_at, 'YYYY-MM') AS Registration_Month, 
    COUNT(aid) AS New_Accounts
FROM Account
GROUP BY Registration_Month
ORDER BY Registration_Month ASC;


-- 6. POPULAR MOVIE STARS --
-- Measures which actors attract more views
-- maybe a good idea would be putting their faces on thumbnails
-- or suggesting films of an actor to a user who has watched movies of him before
SELECT 
    c.name AS Actor_Name, 
    COUNT(wh.uid) AS Total_Views
FROM Crew c
JOIN Participation p ON c.cid = p.cid
JOIN WatchHistoryItem wh ON p.fid = wh.fid
WHERE p.role = 'Actor'
GROUP BY c.cid, c.name
ORDER BY Total_Views DESC
LIMIT 5;



-- 7. REVENUE AND SUBSCRIPTION ANALYSIS --
-- This query displays:
-- total number of booked of each subscription plan 
-- and the amount of money each one has brought for the company
-- It analyzes which plans are more profitable than the others 
-- and guides the company to focus on those subscription plans for future planings.
SELECT 
    sp.title AS Plan_Name, 
    COUNT(a.aid) AS Total_Subscribers, 
    (COUNT(a.aid) * sp.cost) AS Total_Revenue
FROM SubscriptionPlan sp
LEFT JOIN Account a ON sp.sub_id = a.sub_id
GROUP BY sp.sub_id, sp.title, sp.cost
ORDER BY Total_Revenue DESC;


-- 8. SENTIMENT ANALYSIS --
-- Truly shows users perspective toward a movie
-- since high  number of views doesn't necessarily imply quality, 
-- checking number of likes/dislikes is probably a more precise quality metric.
SELECT 
    split_part(v.storage_path, '/', 3) AS Movie_Base_Path,
    SUM(CASE WHEN vr.reaction_type = 'LIKE' THEN 1 ELSE 0 END) AS Total_Likes,
    SUM(CASE WHEN vr.reaction_type = 'DISLIKE' THEN 1 ELSE 0 END) AS Total_Dislikes
FROM Video v
JOIN VideoReaction vr ON v.vid = vr.vid
WHERE v.storage_path LIKE '/m/%'  -- Ensures we are only looking at movies
GROUP BY split_part(v.storage_path, '/', 3)
HAVING Total_Likes > 0 OR Total_Dislikes > 0
ORDER BY Total_Likes DESC;


-- 9. SUBBED VS. DUBBED --
-- Number of reactions that Subbed/Dubbed movies got
-- reaction count kinda represents watch count but without a complex join query to reach Film from Video
SELECT 
    CASE 
        WHEN is_dubbed = 1 THEN 'Dubbed' 
        WHEN is_subtitled = 1 THEN 'Subtitled' 
    END AS Format,
    COUNT(vr.vid) AS Total_Reactions
FROM Video v
JOIN VideoReaction vr ON v.vid = vr.vid
WHERE v.sea_id IS NULL
GROUP BY Format
HAVING Format IS NOT NULL;



-- 10. UNWATCHED CONTENT --
-- This query shows those films that are not watched by any user
-- tracking them is important when we wanna free some space on an overloaded server
-- maybe transfer them to an archive space and bring them back if mecessary in the future
SELECT 
	f.fid,
    f.title
FROM Film f
LEFT JOIN WatchHistoryItem wh ON f.fid = wh.fid
WHERE wh.fid IS NULL;





-- 11. WATCHLIST ANALYSIS --
-- Shows films placed the most in users watch lists.
-- one thing to do is to suggest them to users with similar taste.
-- another approach would be sending a push notification to let the users know the movie they've been waiting on is finally out or soon to be.
SELECT 
    f.title, 
    COUNT(wl.uid) AS Watchlist_Adds
FROM Film f
JOIN WatchListItem wl ON f.fid = wl.fid
GROUP BY f.fid, f.title
ORDER BY Watchlist_Adds DESC
LIMIT 5;

-- Finds the films on user's watch list that are not watched yet to send a reminder email/notification.
SELECT 
    u.username, 
    f.title AS Missed_Film
FROM WatchListItem wl
JOIN wUser u ON wl.uid = u.uid
JOIN Film f ON wl.fid = f.fid
WHERE NOT EXISTS (
    SELECT 1 FROM WatchHistoryItem wh 
    WHERE wh.uid = wl.uid AND wh.fid = wl.fid
);




-- 12. WEEK DAYS VIEW TRAFFIC --
-- Shows number of views per week days.
-- This data can be used for scheduling the release of new episodes.

SELECT 
    trim(to_char(create_at, 'Day')) AS Day_Of_Week, 
    COUNT(*) AS Total_Views
FROM WatchHistoryItem
GROUP BY Day_Of_Week
ORDER BY Total_Views DESC;