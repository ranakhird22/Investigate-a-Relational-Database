/*q1

We would like to know who were our top 10 paying customers, 
how many payments they made on a monthly basis during 2007, 
and what was the amount of the monthly payments. Can you write 
a query to capture the customer name,
 month and year of payment, and total payment amount 
 for each month by these top 10 paying customers?*/
 
 
 
 with top AS(select CONCAT(c.first_name, ' ', c.last_name) as full_name,
	sum(p.amount) sum_total		
	from payment p
	join customer c
	on p.customer_id=c.customer_id
	where p.payment_date BETWEEN '2007-01-01' AND '2008-01-01'
	group by 1
	order by 2 desc
	limit 10),
	
	t2 AS(select CONCAT(c.first_name, ' ', c.last_name) as full_name,
	sum(p.amount) sum_total,
	date_trunc('month',p.payment_date) month_date,
	count(p.amount) count_rental
	from payment p
	join customer c
	on p.customer_id=c.customer_id
	group by 1,3)
	
	select  t2.month_date pay_mon,t2.full_name fullname,
	t2.count_rental pay_countpermon
	,t2.sum_total pay_amount
	from t2
	join top
	on t2.full_name=top.full_name
	group by 2,1,4,3
	order by 2
	
	


/*q2Write a query that returns the store ID for
	the store, the year and month and the number of rental orders
	each store has fulfilled for that month. Your table should 
	include a column for each of the following: year, month, 
	store ID and count of rental orders fulfilled during that month.    */
	
	/*methode 1*/
	with rental  AS (Select 
						  DATE_PART('month',r.rental_date) Rental_month,
						  DATE_PART('year',r.rental_date)  Rantal_year,
						  i.store_id store_ID,
						  count(r.*) Count_rentals
				          from film f 
						  join Inventory  i
						  on i.film_id=f.film_id
						  join rental   r
						  on i.inventory_id=r.inventory_id			
						  group by 3,2,1
						  order by 2,1 )
	                                     
	select *
	from rental
	
	
	
	/*q3
	Create a query that lists each movie, the film category it is classified in,
	and the number of times it has been rented out.*/
	select  filmName filme_title,t2.category_name,numberofrent rental_count
	
	from (
	Select f.film_id filmID,f.title filmName ,count(r.rental_id) numberofrent,i.film_id invtortf
	from film f
	join Inventory  i
	on i.film_id=f.film_id
	join rental   r
	on i.inventory_id=r.inventory_id
	group by 1,2,4
	)t1
	   join (Select title,c.name category_name,f.film_id filmID
		From film f
		Join film_category fc
		On f.film_id=fc.film_id
		Join category c
		On fc.category_id=c. category_id)t2
        on t1.invtortf=t2.filmID
	where t2.category_name in ('Animation', 'Children', 'Classics', 'Comedy', 'Family','Music')
	group by 1,2,3
	order by 2,1
	
	/*q4 Now we need to know how the length of rental duration of these family-friendly 
	movies compares to the duration that all movies are rented for. Can you provide a table
	with the movie titles and divide them into 4 levels (first_quarter, second_quarter, 
	third_quarter, and final_quarter) based on the quartiles (25%, 50%, 75%) of the rental 
	duration for movies across all categories?*/
	
	select  f.title titel,c.name as Name,f.rental_duration rental_duration
	,NTILE(4) OVER(ORDER BY f.rental_duration) AS standard_qurtile
	from film f
	Join film_category fc
    On f.film_id=fc.film_id
	Join category c
	On fc.category_id=c. category_id 
	where c.name in ('Animation', 'Children', 'Classics', 'Comedy', 'Family','Music')
	order by 3
	
	
	
	
	/* the next set of  question  are extra question 
	
	methode2 of q2*/
	with rental  AS (Select 
						  date_part('month',r.rental_date) rental_month,
						  date_part('year',r.rental_date)  rantal_year,
						  st.store_id store_ID,
						  count(r.*) Count_rentals
				          FROM rental r
							JOIN payment p
							  ON p.rental_id = r.rental_id
							JOIN staff s
							  ON s.staff_id = p.staff_id
							JOIN store st
							  ON st.store_id = s.store_id			
						  group by 3,2,1
						  order by 2,1 )
	                                     
	select *
	from rental
	
	
	
	/*q5 the amount of sales in each year*/

	
	with topret AS (Select sum(r.rental_id) numberofrent,
	r.rental_date  date,r.rental_id
	from film f
	Join film_category fc
    On f.film_id=fc.film_id
	Join category c
	On fc.category_id=c. category_id  
	join Inventory  i
	on i.film_id=f.film_id
	join rental   r
	on i.inventory_id=r.inventory_id			
	group by 2,3
	order by 1 desc)
	                                     
	select DATE_PART('year',date) the_Year,sum(p.amount) sales_amount 
	from topret
	join payment p 
	on p.rental_id=topret.rental_id
	group by 1
	
	/*q6  top rented movie*/
	
	Select f.film_id filmID,f.title filmName ,count(r.rental_id) numberofrent
	from film f
	join Inventory  i
	on i.film_id=f.film_id
	join rental   r
	on i.inventory_id=r.inventory_id
	group by 1,2
	order by 3 desc
	
	
	
	/*q7 The top rented category */
	
    with topret AS (Select sum(r.rental_id) numberofrent,
	c.name categoryName
	from film f
	Join film_category fc
    On f.film_id=fc.film_id
	Join category c
	On fc.category_id=c. category_id  
	join Inventory  i
	on i.film_id=f.film_id
	join rental   r
	on i.inventory_id=r.inventory_id				
	group by 2
	order by 1 desc)
	
	select categoryName,numberofrent  from topret 
	