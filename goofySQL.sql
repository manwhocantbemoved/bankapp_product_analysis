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

SELECT DISTINCT complaint_tags
FROM reviews;