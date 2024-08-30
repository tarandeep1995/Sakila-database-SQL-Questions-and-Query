1) All films with PG-13 films with rental rate of 2.99 or lower
Select * from sakila.film
Select * from sakila.film where rating='PG-13' and rental_rate<=2.99;

2) All films that have deleted scenes
Select * from sakila.film where special_features LIKE '%Deleted Scenes%'

3) All active customers
Select * from sakila.customer
Select * from sakila.customer where active=1
Select count(*) as Total_Number_of_Active_Customers from sakila.customer where active=1

4) Names of customers who rented a movie on 26th July 2005
Select * from sakila.rental

Select CONCAT(c.first_name,' ',c.Last_Name) as Full_Name,r.rental_date from sakila.customer c
left join sakila.rental r
on c.customer_id=r.customer_id
where date(r.rental_date)= '2005-07-26%';

5) Distinct names of customers who rented a movie on 26th July 2005
Select distinct c.customer_id,CONCAT(c.first_name,' ',c.Last_Name) as Full_Name,r.rental_date from sakila.customer c
left join sakila.rental r
on c.customer_id=r.customer_id
where date(r.rental_date)= '2005-07-26%'
order by c.customer_id;

6) How many rentals we do on each day?
Select  date(rental_date),count(*) from sakila.rental 
group by date(rental_date)
order by date(rental_date)


7) All Sci-fi films in our catalogue
Select * from sakila.film
Select * from sakila.film_category
Select * from sakila.category

Select f.title,c.name from sakila.film f 
join sakila.film_category fc on  fc.film_id = f.film_id
join sakila.category c on c.category_id=fc.category_id
where c.name='Sci-fi'

8) Customers and how many movies they rented from us so far?
Select * from sakila.rental
Select * from sakila.customer

Select c.customer_id,c.first_name,count(*) as No_of_Rental from sakila.customer c 
join sakila.rental r on r.customer_id=c.customer_id
group by r.customer_id
order by count(*) desc

9) Which movies should we discontinue from our catalogue (less than 2 lifetime rentals)
 
 with low_rentals as
	(Select inventory_id,count(*) from sakila.rental r 
	 group by inventory_id
	 having count(*)<=1)
Select low_rentals.inventory_id,i.film_id,f.title 
from low_rentals 
join sakila.inventory i on i.inventory_id=low_rentals.inventory_id
join sakila.film f on f.film_id = i.film_id

10) Which movies are not returned yet?
Select customer_id,f.film_id,f.title,r.rental_date from sakila.rental r
join sakila.inventory i on i.inventory_id=r.inventory_id
join sakila.film f on f.film_id=i.film_id
where r.return_date is null

Select * from sakila.film

H1) How many distinct last names we have in the data?
Select Count(distinct last_name) from sakila.customer

H2) How much money and rentals we make for all Store till date? 
Select * from sakila.payment
Select * from sakila.store
Select * from sakila.staff

Select s.store_id,sum(p.amount) from sakila.payment p
join sakila.staff sf on sf.staff_id=p.staff_id
join sakila.store s on s.store_id=sf.store_id
group by s.store_id

H3)How much money and rentals we make for Store 1 by day?

SELECT 
    DATE(r.rental_date) AS rental_date,
    COUNT(r.rental_id) AS total_rentals,
    SUM(p.amount) AS total_revenue
FROM 
    sakila.rental r
JOIN 
    sakila.payment p ON r.rental_id = p.rental_id
JOIN 
    sakila.inventory i ON r.inventory_id = i.inventory_id
JOIN 
    sakila.store s ON i.store_id = s.store_id
WHERE 
    s.store_id = 1
GROUP BY 
    DATE(r.rental_date)
ORDER BY 
    rental_date;


H4) What are the three top earning days so far?

SELECT 
    DATE(r.rental_date) AS rental_date,
    SUM(p.amount) AS total_revenue
FROM 
    sakila.rental r
JOIN 
    sakila.payment p ON r.rental_id = p.rental_id
GROUP BY 
    DATE(r.rental_date)
ORDER BY 
    total_revenue DESC
LIMIT 3
