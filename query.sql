------- 1. Querying on individual ---------------
------- 1.1. Quering single individual ---------------
-- Select subject with ID = AA214601:10001
SELECT * FROM Subject
WHERE COHR_SUBJ_ID = "AA214601:10001"

-- Select household income of subject ID = AA214601:10001 recored during the study
SELECT * FROM HH_Inc
WHERE COHR_SUBJ_ID = "AA214601:10001"

-- Select Smoking history of subject ID = AA214601:10001 recored during the study
SELECT * FROM HH_Inc
WHERE COHR_SUBJ_ID = "AA214601:10001"

-- Select household income, smoking history and education status of subject ID = AA214601:10001 recored during the study
SELECT
    sj.COHR_SUBJ_ID,
    h.HH_INC,
    h.HH_DATE,
    s.SMK,
    s.DATE_CONT AS SMK_DATE,
    e.EDUC,
    e.DATE_CONT AS EDUC_DATE
FROM Subject sj
LEFT JOIN HH_Inc h ON sj.COHR_SUBJ_ID = h.COHR_SUBJ_ID
LEFT JOIN Smoking s ON sj.COHR_SUBJ_ID = s.COHR_SUBJ_ID
LEFT JOIN Education e ON sj.COHR_SUBJ_ID = e.COHR_SUBJ_ID
WHERE sj.COHR_SUBJ_ID = "AA214601:10001"

------- 1.2. Quering individuals on condition(s) ---------------
-- Select household income data in subjects who enrolled before 2000
SELECT 
    h.COHR_SUBJ_ID,
    h.HH_INC,
    h.HH_DATE,
    e.ENROLL_DATE
FROM HH_Inc h
LEFT JOIN Enrollment e ON h.COHR_SUBJ_ID = e.COHR_SUBJ_ID
WHERE YEAR(e.ENROL_DATE) < 2000

-- Select subjects living in the UK

SELECT 
    s.*
FROM Subject s
LEFT JOIN Home h ON s.COHR_SUBJ_ID = h.COHR_SUBJ_ID
WHERE h.country = "United Kingdom"


------- 2. Basic analytical query ---------------
-- Finding the number of subjects by enrollment year
SELECT year(ENROLL_DATE), count(COHR_SUBJ_ID) FROM Enrollment GROUP BY 1

-- Finding the number of smokers in 2000
SELECT COUNT(s.COHR_SUBJ_ID) FROM
(SELECT DISTINCT COHR_SUBJ_ID FROM Smoking WHERE YEAR(DATE_CONT) = 2000 AND SMK = 1) s

-- Finding mean household income in smokers in 2000 (Assuming household income data are numeric)

SELECT AVG(HH_INC) 
FROM HH_INC h
LEFT JOIN (SELECT DISTINCT COHR_SUBJ_ID FROM Smoking WHERE YEAR(DATE_CONT) = 2000 AND SMK = 1) s
ON h.COHR_SUBJ_ID = s.COHR_SUBJ_ID
