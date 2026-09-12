-- 1. FUNCTIONS (4 Queries)

-- Most Popular New Releases (Query 3)
CREATE OR REPLACE FUNCTION GetPopularReleases(start_date DATE, end_date DATE, top_limit INT)
RETURNS TABLE (title VARCHAR, genre VARCHAR, unique_viewers BIGINT) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        f.title::VARCHAR, 
        f.genre::VARCHAR, 
        COUNT(wh.uid)::BIGINT AS unique_viewers
    FROM Cinematic c
    JOIN Film f ON f.fid = c.fid
    JOIN WatchHistoryItem wh ON f.fid = wh.fid
    WHERE c.release_year BETWEEN start_date AND end_date
    GROUP BY f.fid, f.title, f.genre
    ORDER BY unique_viewers DESC
    LIMIT top_limit;
END;
$$ LANGUAGE plpgsql;


-- Near Expiration Accounts (Query 4)
CREATE OR REPLACE FUNCTION GetExpiringAccounts(from_date DATE, to_date DATE)
RETURNS TABLE (phone VARCHAR, current_plan VARCHAR, end_date DATE) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        a.phone::VARCHAR, 
        sp.title::VARCHAR AS current_plan, 
        a.end_date::DATE
    FROM Account a
    JOIN SubscriptionPlan sp ON a.sub_id = sp.sub_id
    WHERE sp.title != 'Free' AND a.end_date BETWEEN from_date AND to_date
    ORDER BY a.end_date ASC;
END;
$$ LANGUAGE plpgsql;


-- Remind Unwatched Watchlist (Query 11b)
CREATE OR REPLACE FUNCTION GetUserMissedWatchlist(target_uid INT)
RETURNS TABLE (username VARCHAR, missed_film VARCHAR) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        u.username::VARCHAR, 
        f.title::VARCHAR AS missed_film
    FROM WatchListItem wl
    JOIN wUser u ON wl.uid = u.uid
    JOIN Film f ON wl.fid = f.fid
    WHERE wl.uid = target_uid AND NOT EXISTS (
        SELECT 1 FROM WatchHistoryItem wh 
        WHERE wh.uid = wl.uid AND wh.fid = wl.fid
    );
END;
$$ LANGUAGE plpgsql;


-- Popular Movie Stars (Query 6)
CREATE OR REPLACE FUNCTION GetTopActors(top_limit INT)
RETURNS TABLE (actor_name VARCHAR, total_views BIGINT) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        c.name::VARCHAR AS actor_name, 
        COUNT(wh.uid)::BIGINT AS total_views
    FROM Crew c
    JOIN Participation p ON c.cid = p.cid
    JOIN WatchHistoryItem wh ON p.fid = wh.fid
    WHERE p.role = 'Actor'
    GROUP BY c.cid, c.name
    ORDER BY total_views DESC
    LIMIT top_limit;
END;
$$ LANGUAGE plpgsql;


-- 2. VIEWS (2 Queries)

-- Unwatched Content (Query 10)
CREATE VIEW vw_unwatched_content AS
SELECT 
    f.fid,
    f.title
FROM Film f
LEFT JOIN WatchHistoryItem wh ON f.fid = wh.fid
WHERE wh.fid IS NULL;


-- Revenue and Subscription Analysis (Query 7)
CREATE OR REPLACE VIEW vw_revenue_analysis AS
SELECT 
    sp.title AS Plan_Name, 
    COUNT(a.aid) AS Total_Subscribers, 
    (COUNT(a.aid) * sp.cost) AS Total_Revenue
FROM SubscriptionPlan sp
LEFT JOIN Account a ON sp.sub_id = a.sub_id
GROUP BY sp.sub_id, sp.title, sp.cost;

-- 3. MATERALIZED QUERIES

-- MatView 1: Sentiment Analysis (Query 8)
CREATE MATERIALIZED VIEW mv_sentiment_analysis AS
SELECT 
    split_part(v.storage_path, '/', 3) AS Movie_Base_Path,
    SUM(CASE WHEN vr.reaction_type = 'LIKE' THEN 1 ELSE 0 END) AS Total_Likes,
    SUM(CASE WHEN vr.reaction_type = 'DISLIKE' THEN 1 ELSE 0 END) AS Total_Dislikes
FROM Video v
JOIN VideoReaction vr ON v.vid = vr.vid
WHERE v.storage_path LIKE '/m/%'
GROUP BY split_part(v.storage_path, '/', 3)
HAVING SUM(CASE WHEN vr.reaction_type = 'LIKE' THEN 1 ELSE 0 END) > 0 
    OR SUM(CASE WHEN vr.reaction_type = 'DISLIKE' THEN 1 ELSE 0 END) > 0;

-- MatView 2: Genre Analysis Data (Query 1a)
CREATE MATERIALIZED VIEW mv_genre_analysis AS
SELECT 
    f.genre, 
    COUNT(wh.fid) AS Total_Views
FROM Film f
JOIN WatchHistoryItem wh ON f.fid = wh.fid
GROUP BY f.genre;
