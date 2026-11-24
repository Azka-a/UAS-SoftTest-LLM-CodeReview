-- 1. Cek isi tabel dan tipe data VECTOR
SELECT pr_id, repo_name, is_llm_assisted, time_to_merge_h,
       FROM_VECTOR(feature_vec) AS normalized_features
FROM pr_code_review
FETCH FIRST 10 ROWS ONLY;

-- 2. Pencocokan (Matching) PR Assisted vs Non-Assisted terdekat via MANHATTAN Distance
SELECT a.pr_id AS assisted_id,
       a.repo_name AS assisted_repo,
       b.pr_id AS matched_non_assisted_id,
       ROUND(VECTOR_DISTANCE(a.feature_vec, b.feature_vec, MANHATTAN), 5) AS manhattan_dist,
       a.time_to_merge_h AS assisted_merge_h,
       b.time_to_merge_h AS non_assisted_merge_h
FROM pr_code_review a
CROSS APPLY (
    SELECT pr_id, feature_vec, time_to_merge_h
    FROM pr_code_review b
    WHERE b.is_llm_assisted = 0
    ORDER BY VECTOR_DISTANCE(a.feature_vec, b.feature_vec, MANHATTAN)
    FETCH FIRST 1 ROWS ONLY
) b
WHERE a.is_llm_assisted = 1
ORDER BY manhattan_dist;

-- 3. Cek Execution Plan (seperti Slide 38 Materi Oracle Academy)
EXPLAIN PLAN FOR
SELECT pr_id, repo_name, time_to_merge_h
FROM pr_code_review
WHERE is_llm_assisted = 0
ORDER BY VECTOR_DISTANCE(feature_vec, TO_VECTOR('[0.1, 0.1, 0.1, 0.5]', 4, FLOAT32), MANHATTAN)
FETCH FIRST 5 ROWS ONLY;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);