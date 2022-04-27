-- To view the content of both datasets individually
SELECT * FROM donation_data;
SELECT * FROM donor_data;
-- To view the content of both datasets merged
SELECT *
FROM donation_data dd
JOIN donor_data d 
ON dd.id = d.id;
-- To view total number of registered donors and total expected donations
SELECT COUNT(id) AS donors, 
SUM(donation) AS total_donations
FROM donation_data;
-- To view total number of donors that donated and the total donations gotten by the charity
SELECT COUNT(d.id) AS donors, 
SUM(donation) AS total_donations
FROM donation_data dd
JOIN donor_data d 
ON dd.id = d.id
WHERE  donation_frequency != 'Never'
--To view gender count ratio of actual donors and total donation
SELECT gender,
		COUNT(DISTINCT d.id) AS number_of_donors, 
		SUM(donation) AS total_donations
FROM donation_data dd
JOIN donor_data d 
ON dd.id = d.id
WHERE  donation_frequency != 'Never'
GROUP BY 1
ORDER BY 2 DESC;
--To view the gender count ratio of donors that pledged to donate but never did.
SELECT gender,
		COUNT(DISTINCT d.id) AS number_of_donors, 
		SUM(donation) AS total_donations
FROM donation_data dd
JOIN donor_data d 
ON dd.id = d.id
WHERE  donation_frequency = 'Never'
GROUP BY 1
ORDER BY 2 DESC;

-- To view all the US states with donors
SELECT DISTINCT state 
FROM donation_data;
-- To view number of donors and total donation per state in descending order
SELECT state,
		COUNT(DISTINCT d.id) AS number_of_donors, 
		SUM(donation) AS total_donations
FROM donation_data dd
JOIN donor_data d 
ON dd.id = d.id
WHERE  donation_frequency != 'Never'
GROUP BY 1
ORDER BY 3 DESC;

-- To view number of donors and total donation per job field in descending order
SELECT job_field,
		COUNT(DISTINCT d.id) AS number_of_donors, 
		SUM(donation) AS total_donations
FROM donation_data dd
JOIN donor_data d 
ON dd.id = d.id
WHERE  donation_frequency != 'Never'
GROUP BY 1
ORDER BY 3 DESC;
-- To view number of donors and total donation per donation frequency in descending order
SELECT donation_frequency,
		COUNT(DISTINCT id) AS number_of_donors, 
		SUM(donation) AS total_donations
FROM donation_data dd
JOIN donor_data d 
ON dd.id = d.id
GROUP BY 1
ORDER BY 2 Desc;
-- Using subqueries to view donors and their total donations after further grouping the frequency of donations into 2 categories 'frequent' and 'less frequent'
SELECT T1.frequency,
		COUNT(T2.id) AS number_of_donors, 
		SUM(T2.donation) AS total_donations
FROM (SELECT job_field,
		d.id as id, 
		donation,
		donation_frequency,
	CASE 
	WHEN donation_frequency = 'Never'
	OR donation_frequency ='Once'
	OR donation_frequency = 'Seldom'
	OR donation_frequency = 'Yearly' THEN 'less frequent'
	ELSE 'frequent' 
	END AS frequency
	FROM donation_data dd
	JOIN donor_data d 
	ON dd.id = d.id) T1
JOIN
(SELECT job_field,
		d.id as id, 
		donation,
		donation_frequency,
	CASE 
	WHEN donation_frequency = 'Never'
	OR donation_frequency ='Once'
	OR donation_frequency = 'Seldom'
	OR donation_frequency = 'Yearly' THEN 'less frequent'
	ELSE 'frequent' 
	END AS frequency
	FROM donation_data dd
	JOIN donor_data d 
	ON dd.id = d.id) T2
ON T1.id = T2.id
GROUP BY 1
ORDER BY 3 DESC;

-- To view the gender ratio of frequent and less frequent donors and total donations 
SELECT T1.gender, 
T1.frequency,
		COUNT(T2.id) AS number_of_donors, 
		SUM(T2.donation) AS total_donations
FROM (SELECT gender,
		d.id as id, 
		donation,
		donation_frequency,
	CASE 
	WHEN donation_frequency = 'Never'
	OR donation_frequency ='Once'
	OR donation_frequency = 'Seldom'
	OR donation_frequency = 'Yearly' THEN 'less frequent'
	ELSE 'frequent' 
	END AS frequency
	FROM donation_data dd
	JOIN donor_data d 
	ON dd.id = d.id) T1
JOIN
(SELECT gender,
		d.id as id, 
		donation,
		donation_frequency,
	CASE 
	WHEN donation_frequency = 'Never'
	OR donation_frequency ='Once'
	OR donation_frequency = 'Seldom'
	OR donation_frequency = 'Yearly' THEN 'less frequent'
	ELSE 'frequent' 
	END AS frequency
	FROM donation_data dd
	JOIN donor_data d 
	ON dd.id = d.id) T2
ON T1.id = T2.id
GROUP BY 1, 2
ORDER BY 1;

-- To view the number of frequent and less frequent donors and total donations from the different job fields 
SELECT T1.job_field, T1.frequency,
		COUNT(T2.id) AS number_of_donors, 
		SUM(T2.donation) AS total_donations
FROM (SELECT job_field,
		d.id as id, 
		donation,
		donation_frequency,
	CASE 
	WHEN donation_frequency = 'Never'
	OR donation_frequency ='Once'
	OR donation_frequency = 'Seldom'
	OR donation_frequency = 'Yearly' THEN 'less frequent'
	ELSE 'frequent' 
	END AS frequency
	FROM donation_data dd
	JOIN donor_data d 
	ON dd.id = d.id) T1
JOIN
(SELECT job_field,
		d.id as id, 
		donation,
		donation_frequency,
	CASE 
	WHEN donation_frequency = 'Never'
	OR donation_frequency ='Once'
	OR donation_frequency = 'Seldom'
	OR donation_frequency = 'Yearly' THEN 'less frequent'
	ELSE 'frequent' 
	END AS frequency
	FROM donation_data dd
	JOIN donor_data d 
	ON dd.id = d.id) T2
ON T1.id = T2.id
GROUP BY 1, 2
ORDER BY 1;

-- To get information on the top 10 frequent donors based on the value of their donation
SELECT T2.id AS id,
		T1.name, 
		T1.gender, 
		T1.state, 
		T1.university, 
		T1.job_field, 
		T1.frequency, 
		T2.donation AS donation
FROM (SELECT job_field,
	  	concat (first_name,' ',last_name) AS name,
		d.id AS id, 
	  	gender, 
	  	state, 
	  	university,
		donation,
		donation_frequency,
	CASE 
	WHEN donation_frequency = 'Never'
	OR donation_frequency ='Once'
	OR donation_frequency = 'Seldom'
	OR donation_frequency = 'Yearly' THEN 'less frequent'
	ELSE 'frequent' 
	END AS frequency
	FROM donation_data dd
	JOIN donor_data d 
	ON dd.id = d.id) T1
JOIN
(SELECT job_field,
 		concat (first_name,' ',last_name) AS name,
		d.id AS id, 
		donation,
		donation_frequency,
	CASE 
	WHEN donation_frequency = 'Never'
	OR donation_frequency ='Once'
	OR donation_frequency = 'Seldom'
	OR donation_frequency = 'Yearly' THEN 'less frequent'
	ELSE 'frequent' 
	END AS frequency
	FROM donation_data dd
	JOIN donor_data d 
	ON dd.id = d.id)T2
ON T1.id = T2.id
WHERE T1.frequency = 'frequent'
ORDER BY 8 DESC
LIMIT 10;
--To view information on donors that pledged to donate but never did.
SELECT T2.id AS id,
		T1.name, 
		T1.gender,
		T1.email,
		T2.state, 
		T2.university, 
		T2.job_field,
		T1.donation
FROM(SELECT d.id as id, 
	 	concat (first_name,' ',last_name) AS name,
	 	gender,
	 	email,
		donation,
		donation_frequency
	FROM donation_data dd
	JOIN donor_data d 
	ON dd.id = d.id)T1
JOIN (SELECT d.id as id, 
	  	state,
	  	university,
	  	job_field
	FROM donation_data dd
	JOIN donor_data d 
	ON dd.id = d.id)T2
ON T1.id = T2.id
WHERE  T1.donation_frequency = 'Never'
ORDER BY 2;
--To view the gender count ratio of donors that pledged to donate but never did but acquired a tertiary education.
SELECT T1.gender, COUNT(T1.university) AS number_of_donors, 
		SUM(T1.donation) AS total_donations
FROM (SELECT job_field,gender, university,
		d.id as id, 
		donation,
		donation_frequency
	FROM donation_data dd
	JOIN donor_data d 
	ON dd.id = d.id
	WHERE university is NOT NULL) T1
JOIN (SELECT job_field,gender, university,
		d.id as id, 
		donation,
		donation_frequency
	FROM donation_data dd
	JOIN donor_data d 
	ON dd.id = d.id
	WHERE university is NOT NULL) T2
ON T1.id = T2.id
WHERE T1.donation_frequency = 'Never'
GROUP BY 1;