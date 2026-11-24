-- DDL & DML Oracle Database 23ai AI Vector Search
CREATE TABLE pr_code_review (
    pr_id             NUMBER PRIMARY KEY,
    repo_name         VARCHAR2(255),
    is_llm_assisted   NUMBER(1),
    time_to_merge_h   NUMBER,
    feature_vec       VECTOR(4, FLOAT32)
);

INSERT INTO pr_code_review VALUES (1, 'F3-Nation/f3-nation', 1, 2.3819, TO_VECTOR('[0.000000, 0.000000, 0.000000, 0.000000]', 4, FLOAT32));
COMMIT;