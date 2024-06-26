

-- Which country have the most invoices
SELECT 
    COUNT(invoice_id) AS TotalInvoice, billing_country
FROM
    invoice
GROUP BY billing_country
ORDER BY TotalInvoice DESC
LIMIT 1;

-- What are top 3 value of invoices
SELECT 
    ROUND(total, 2)
FROM
    invoice
ORDER BY total DESC
LIMIT 3;

-- The city that has the highest sum of invoice totals is best city. 
SELECT 
    billing_city, ROUND(SUM(total), 2) AS TotalInvoice
FROM
    invoice
GROUP BY billing_city
ORDER BY TotalInvoice DESC
LIMIT 1;

-- the customer who has spent the most money on music
SELECT 
    c.customer_id,
    first_name,
    last_name,
    ROUND(SUM(i.total), 2) AS TotalInvoice
FROM
    invoice i
        JOIN
    customer c ON i.customer_id = c.customer_id
GROUP BY c.customer_id , first_name , last_name
ORDER BY TotalInvoice DESC
LIMIT 1;

/* return the email, first name, last name, & Genre of all Rock Music listeners. 
Return your list ordered alphabetically by email starting with A.*/

SELECT DISTINCT
    c.email, c.first_name, c.last_name, g.name
FROM
    genre g
        JOIN
    Track t ON g.genre_id = t.genre_id
        JOIN
    invoice_line il ON il.track_id = t.track_id
        JOIN
    invoice i ON il.invoice_id = i.invoice_id
        JOIN
    customer c ON c.customer_id = i.customer_id
WHERE
    g.name = 'Rock'
ORDER BY c.email;

-- Write a query that returns the Artist name and total track count of the top 10 rock bands.
SELECT 
    a.name, g.name, COUNT(t.track_id) AS Total_track
FROM
    artist a
        JOIN
    Album2 al ON al.artist_id = a.artist_id
        JOIN
    track t ON t.album_id = al.album_id
        JOIN
    genre g ON g.genre_id = t.genre_id
WHERE
    g.name = 'Rock'
GROUP BY a.name , g.name
ORDER BY Total_track DESC
LIMIT 10;

/*  Returning all the track names that have a song length longer than the average song length. 
Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first. */

SELECT 
    name, milliseconds
FROM
    track
WHERE
    milliseconds > (SELECT 
            AVG(milliseconds) AS AvgLength
        FROM
            track)
ORDER BY milliseconds DESC;

-- how much amount spent by each customer on artists
WITH bestSellingArtist AS (
	SELECT artist.artist_id AS artist_id, artist.name AS artist_name,
    round(SUM(invoice_line.unit_price*invoice_line.quantity),2) AS total_sales
	FROM invoice_line
	JOIN track ON track.track_id = invoice_line.track_id
	JOIN album2 ON album2.album_id = track.album_id
	JOIN artist ON artist.artist_id = album2.artist_id
	GROUP BY 1,2
	ORDER BY 3 DESC
	LIMIT 1
)
SELECT c.customer_id, c.first_name, c.last_name, bsa.artist_name,
round(SUM(il.unit_price*il.quantity),2) AS amount_spent
FROM invoice i
JOIN customer c ON c.customer_id = i.customer_id
JOIN invoice_line il ON il.invoice_id = i.invoice_id
JOIN track t ON t.track_id = il.track_id
JOIN album2 alb ON alb.album_id = t.album_id
JOIN bestSellingArtist  bsa ON bsa.artist_id = alb.artist_id
GROUP BY 1,2,3,4
ORDER BY 5 DESC;

 /* We want to find out the most popular music Genre for each country. 
 We determine the most popular genre as the genre 
with the highest amount of purchases. Write a query that returns each country along with the top Genre. For countries where 
the maximum number of purchases is shared return all Genres. */

with Popular_genre as
 ( select count(il.quantity) as Purchases,c.country,g.name,
 row_number() over(partition by c.country order by count(il.quantity) desc) as row_num
 from customer c join invoice i on c.customer_id = i.customer_id
join invoice_line il on il.invoice_id=i.invoice_id
join track t on t.track_id=il.track_id 
join genre g on g.genre_id=t.genre_id
group by 2,3
order by 2 asc, 1 desc)
Select * from Popular_genre where row_num=1;

/* Write a query that determines the customer that has spent the most on music for each country. 
Write a query that returns the country along with the top customer and how much they spent. 
For countries where the top amount spent is shared, provide all customers who spent this amount.*/

with Top_cus as
( Select c.customer_id,c.first_name,c.last_name,i.billing_country,round(sum(i.total),2) as total_spending,
row_number() over(partition by i.billing_country order by sum(i.total) desc) as row_num
from customer c join invoice i on
c.customer_id=i.customer_id
group by 1,2,3,4
order by 4 asc,5 desc
)
select * from Top_cus where row_num=1













				





















