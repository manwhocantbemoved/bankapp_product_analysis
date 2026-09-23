CREATE TABLE reviews (
    review_id CHAR(36) PRIMARY KEY,
    score TINYINT,
    thumbs_up_count INT,
    app_version VARCHAR(15),
    bank VARCHAR(20),
    review_date DATE,
    complaint_tags VARCHAR(200)
);
SHOW CREATE TABLE reviews;
ALTER TABLE reviews CONVERT TO CHARACTER SET utf8mb4;
LOAD DATA LOCAL INFILE 'C:/Users/ythan/Downloads/Data Analyst Practice/Topics/Jupyter/bankapp_product_analysis/df_clean2.csv'
INTO TABLE reviews
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(review_id, content, score, thumbs_up_count, app_version, bank, review_date, complaint_tags);
SET GLOBAL local_infile = 1;

SELECT DISTINCT *
FROM reviews
ORDER BY thumbs_up_count DESC;

-- Pos and Neg avgs
SELECT
	bank,
	AVG(CASE WHEN score >= 3 THEN score END) AS Positive_Avg,
    AVG(CASE WHEN score <= 2 THEN score END) AS Neg_Avg
FROM reviews
GROUP BY bank;

-- Percentages of positive vs negative reviews 
SELECT
    bank,
    ROUND(COUNT(CASE WHEN score >= 3 THEN 1 END) * 100/COUNT(score), 2) AS Positive_Pct,
    ROUND(COUNT(CASE WHEN score <= 2 THEN 1 END) * 100/COUNT(score), 2) AS Neg_Pct,
    ROUND(COUNT(CASE WHEN score >= 3 THEN 1 END) * 100/COUNT(score), 2) - ROUND(COUNT(CASE WHEN score <= 2 THEN 1 END) * 100/COUNT(score), 2) AS Net_Sentiment
FROM reviews
GROUP BY bank
ORDER BY Net_Sentiment;

-- Reviews with thumbs up counts ranked by complaints
SELECT review_id, thumbs_up_count, bank, complaint_tags
FROM reviews
WHERE bank = 'Metrobank' AND score <= 2
ORDER BY thumbs_up_count DESC;

-- Query to make duplicate rows for separating double complaint tags
CREATE TABLE review_tags AS
SELECT r.review_id, r.bank, r.score, r.thumbs_up_count, jt.tag
FROM reviews r,
JSON_TABLE(
    REPLACE(r.complaint_tags, "'", '"'),
    '$[*]' COLUMNS (tag VARCHAR(100) PATH '$')
) AS jt;

-- Counting each complaint tags unique per bank
SELECT bank, tag, COUNT(*) AS tag_count
FROM review_tags
GROUP BY bank, tag
ORDER BY tag, tag_count DESC;

-- Seeing which app versions have the most negative complaints
SELECT app_version, bank,
	COUNT(CASE WHEN score <= 2 THEN complaint_tags END) AS app_version_negative_complaints
FROM reviews
GROUP BY bank, app_version
ORDER BY app_version_score DESC;
