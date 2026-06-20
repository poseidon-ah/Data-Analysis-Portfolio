-- 1-------------------------------------------------
SELECT 
	C.client_id,
    C.name,
    SUM(I.invoice_total) AS total_purchase
FROM clients C
JOIN invoices I
	ON C.client_id = I.client_id
GROUP BY C.client_id ;
-- 2--------------------------------------------------
SELECT 
	C.client_id,
    C.name,
    COUNT(I.invoice_id) AS count_invoices
FROM clients C
JOIN invoices I
	ON C.client_id = I.client_id
GROUP BY C.client_id ;
-- 3--------------------------------------------------
SELECT *
FROM (	
    SELECT
		C.client_id,
		C.name,
		SUM(I.invoice_total) AS total_purchase
	FROM clients C
	JOIN invoices I
		ON C.client_id = I.client_id
	GROUP BY C.client_id
      ) AS t
WHERE total_purchase > (
	SELECT AVG(total_purchase)
    FROM (
			SELECT SUM(invoice_total) AS total_purchase
            FROM invoices
            GROUP BY client_id) AS r
    ) ;
 
 
 
 WITH customer_total AS (
	SELECT client_id, SUM(invoice_total) AS total_purchase
    FROM invoices
    GROUP BY client_id
    )
SELECT * FROM customer_total
WHERE total_purchase > (SELECT AVG(total_purchase) FROM customer_total) ;

-- 4--------------------------------------------------
SELECT
	client_id,
    name,
    invoice_date
FROM
	(SELECT
		C.client_id,
		C.name,
		I.invoice_date,
		ROW_NUMBER() OVER(PARTITION BY C.client_id ORDER BY I.invoice_date DESC) AS rnk
	FROM clients C
	JOIN invoices I
		ON C.client_id = I.client_id ) AS r
WHERE rnk = 1 ;
-- 5--------------------------------------------------
SELECT
	C.client_id,
    C.name,
    I.invoice_id,
    I.invoice_total,
    CASE
		WHEN I.payment_total = 0 THEN 0
        ELSE ROUND((I.payment_total / I.invoice_total) * 100)
	END AS percent_payment
FROM clients C
JOIN invoices I
	ON C.client_id = I.client_id ;
-- 6---------------------------------------------------
  SELECT
		C.client_id,
		C.name,
		SUM(I.invoice_total) AS total_purchase,
        RANK() OVER(ORDER BY SUM(I.invoice_total) DESC) AS rnk
	FROM clients C
	JOIN invoices I
		ON C.client_id = I.client_id
	GROUP BY C.client_id ;
-- 7---------------------------------------------------
SELECT
	C.client_id,
    C.name,
    I.invoice_total
FROM clients C
LEFT JOIN invoices I
	ON C.client_id = I.client_id
WHERE I.invoice_total IS NULL ;
-- 8---------------------------------------------------
SELECT
    CASE
		WHEN I.payment_total > 0 THEN 'Paid'
        ELSE 'Unpaid'
	END AS payment_status,
    AVG(I.invoice_total) AS avg_invoice
FROM clients C
JOIN invoices I
	ON C.client_id = I.client_id
GROUP BY payment_status ;