USE project_medical_data_history;
SELECT * FROM admissions;
SELECT * FROM doctors;
SELECT * FROM patients;
SELECT * FROM province_names;


# Show first name, last name, and gender of patients who's gender is 'M'
SELECT first_name, last_name, gender
FROM patients
WHERE Gender = "M";

# Show first name and last name of patients who does not have allergies
SELECT * FROM patients
WHERE allergies is not null;

#Show first name of patients that start with the letter 'C'
SELECT first_name, last_name FROM patients
WHERE first_name LIKE "C%";

# Show first name and last name of patients that weight within the range of 100 to 120 (inclusive)
SELECT first_name, last_name, weight
FROM patients
WHERE weight between 100 AND 120;

# Update the patients table for the allergies column. If the patient's allergies is null then replace it with 'NKA'
UPDATE patients
SET allergies = "NKA"
WHERE allergies IS NULL;

# Show first name and last name concatenated into one column to show their full name.
SELECT CONCAT(first_name, ' ',last_name) AS full_name
FROM patients;

# Show first name, last name, and the full province name of each patient.
SELECT p.first_name, p.last_name, p.province_id, pr.province_name
FROM patients p
JOIN province_names pr
on p.province_id = pr.province_id;

#  Show how many patients have a birth_date with 2010 as the birth year.
SELECT COUNT(*) AS patient_count
FROM patients
WHERE YEAR(birth_date) = 2010;

# Show the first_name, last_name, and height of the patient with the greatest height.
SELECT first_name, last_name, height 
FROM patients
ORDER BY height DESC
LIMIT 1;

# Show all columns for patients who have one of the following patient_ids: 1,45,534,879,1000
SELECT * FROM patients
WHERE patient_id >= 1455348791000;

# Show the total number of admissions
SELECT COUNT(*) AS Total_Admissions
FROM admissions;

#Show all the columns from admissions where the patient was admitted and discharged on the same day.
SELECT * FROM admissions
WHERE admission_date = discharge_date;

# Show the total number of admissions for patient_id 579.
SELECT COUNT(*) AS total_admissions
FROM admissions
WHERE patient_id = 579;

# Based on the cities that our patients live in, show unique cities that are in province_id 'NS'?
SELECT DISTINCT city
FROM patients
WHERE province_id = 'NS';

# Write a query to find the first_name, last name and birth date of patients who have height more than 160 and weight more than 70
SELECT first_name, last_name, birth_date 
FROM patients
WHERE height > 160 AND weight > 70;

# Show unique birth years from patients and order them by ascending.
SELECT DISTINCT YEAR(birth_date) AS birth_year
FROM patients
ORDER BY birth_year ASC;

# Show unique first names from the patients table which only occurs once in the list
SELECT first_name
FROM patients
GROUP BY first_name
HAVING COUNT(first_name) = 1;

# Show patient_id and first_name from patients where their first_name start and ends with 's' and is at least 6 characters long.
SELECT patient_id, first_name
FROM patients
WHERE first_name LIKE 's%s'
  AND LENGTH(first_name) >= 6;
  
#Show patient_id, first_name, last_name from patients whos diagnosis is 'Dementia'.   Primary diagnosis is stored in the admissions table.
SELECT 
    p.patient_id,
    p.first_name,
    p.last_name,
    a.diagnosis
FROM 
    patients p
JOIN 
    admissions a
    ON p.patient_id = a.patient_id
WHERE 
    a.diagnosis = 'Dementia';
    
# Display every patient's first_name. Order the list by the length of each name and then by alphbetically.
SELECT 
    first_name
FROM 
    patients
ORDER BY 
    LENGTH(first_name),
    first_name;

# Show the total amount of male patients and the total amount of female patients in the patients table. Display the two results in the same row.
SELECT
    SUM(CASE WHEN gender = 'M' THEN 1 ELSE 0 END) AS Male_Patients,
    SUM(CASE WHEN gender = 'F' THEN 1 ELSE 0 END) AS Female_Patients
FROM 
    patients;
    
# Show the total amount of male patients and the total amount of female patients in the patients table. Display the two results in the same row.
#Same as above query.

# Show patient_id, diagnosis from admissions. Find patients admitted multiple times for the same diagnosis
SELECT p.first_name, p.last_name,a.diagnosis as diagnosis,
COUNT(*) as admission_count
FROM patients p
JOIN admissions a 
ON p.patient_id = a.patient_id
GROUP BY 
first_name, 
last_name,
diagnosis
HAVING
COUNT(*)>1;

# Show the city and the total number of patients in the city. Order from most to least patients and then by city name ascending.
SELECT 
    city,
    COUNT(patient_id) AS total_patients
FROM 
    patients
GROUP BY 
    city
ORDER BY 
    total_patients DESC,
    city ASC;
    
#Show first name, last name and role of every person that is either patient or doctor. The roles are either "Patient" or "Doctor"
SELECT first_name, last_name, 'patient' AS role
 FROM patients 
 UNION ALL
SELECT first_name, last_name, 'Doctor' AS role
FROM doctors;

# Show all allergies ordered by popularity. Remove NULL values from query.
SELECT 
    allergies,
    COUNT(*) AS total_occurrences
FROM 
    patients
WHERE 
    allergies IS NOT NULL
GROUP BY 
    allergies
ORDER BY 
    total_occurrences DESC;

# Show all patient's first_name, last_name, and birth_date who were born in the 1970s decade. Sort the list starting from the earliest birth_date.
SELECT 
    first_name,
    last_name,
    birth_date
FROM 
    patients
WHERE 
    birth_date BETWEEN '1970-01-01' AND '1979-12-31'
ORDER BY 
    birth_date ASC;

# We want to display each patient's full name in a single column. Their last_name in all upper letters must appear first, then first_name in all lower case letters. Separate the last_name and first_name with a comma. Order the list by the first_name in decending order    EX: SMITH,jane
SELECT 
    CONCAT(UPPER(last_name), ',', LOWER(first_name)) AS full_name
FROM 
    patients
ORDER BY 
    first_name DESC;
    
# Show the province_id(s), sum of height; where the total sum of its patient's height is greater than or equal to 7,000.
SELECT 
    province_id,
    SUM(height) AS total_height
FROM 
    patients
GROUP BY 
    province_id
HAVING 
    SUM(height) >= 7000;
    
# Show the difference between the largest weight and smallest weight for patients with the last name 'Maroni'
SELECT 
    (MAX(weight) - MIN(weight)) AS weight_difference
FROM
    patients
WHERE
    last_name = 'Maroni';
    
# Show all of the days of the month (1-31) and how many admission_dates occurred on that day. Sort by the day with most admissions to least admissions.
SELECT 
    EXTRACT(DAY FROM admission_date) AS day_of_month,
    COUNT(*) AS total_admissions
FROM 
    admissions
GROUP BY 
    EXTRACT(DAY FROM admission_date)
ORDER BY 
    total_admissions DESC;

# Show all of the patients grouped into weight groups. Show the total amount of patients in each weight group. Order the list by the weight group decending. e.g. if they weight 100 to 109 they are placed in the 100 weight group, 110-119 = 110 weight group, etc.
SELECT 
    FLOOR(weight / 10) * 10 AS weight_group,
    COUNT(*) AS total_patients
FROM 
    patients
GROUP BY 
    FLOOR(weight / 10) * 10
ORDER BY 
    weight_group DESC;
    
# Show patient_id, weight, height, isObese from the patients table. Display isObese as a boolean 0 or 1. Obese is defined as weight(kg)/(height(m). Weight is in units kg. Height is in units cm.
SELECT
    patient_id,
    weight,
    height,
    CASE 
        WHEN (weight / POWER(height / 100.0, 2)) >= 30 THEN 1
        ELSE 0
    END AS isObese
FROM 
    patients;

#Show patient_id, first_name, last_name, and attending doctor's specialty. Show only the patients who has a diagnosis as 'Epilepsy' and the doctor's first name is 'Lisa'. Check patients, admissions, and doctors tables for required information.
SELECT 
    p.patient_id,
    p.first_name,
    p.last_name,
    d.specialty
FROM 
    patients p
JOIN 
    admissions a
    ON p.patient_id = a.patient_id
JOIN 
    doctors d
    ON a.attending_doctor_id = d.doctor_id
WHERE 
    a.diagnosis = 'Epilepsy'
    AND d.first_name = 'Lisa';


