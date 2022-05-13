use sakila;
-- 1 Write a query to display for each store its store ID, city, and country.
select * from store;
select * from address;
select * from city;
select * from country;

select 
	s.store_id,
	ci.city,
    co.country
from store as s
join address as a
on s.address_id = a.address_id
join city as ci
on a.city_id = ci.city_id
join country as co
on ci.country_id = co.country_id;

-- 2 Write a query to display how much business, in dollars, each store brought in.

select * from store;
select * from staff;
select * from payment;

select 
	sr.store_id,
    sum(p.amount)
from payment as p
join staff as sf
on p.staff_id = sf.staff_id
join store as sr
on sf.staff_id = sr.manager_staff_id
group by sr.store_id;


-- 3 Which film categories are longest?

select * from film;
select * from film_category;
select * from category;

select 
	c.name,
    round(avg(f.length),2) as avg_len
from film as f
join film_category as fc
on f.film_id = fc.film_id
join category as c
on fc.category_id = c.category_id
group by c.name
order by avg_len desc
limit 3;

-- 4 Display the most frequently rented movies in descending order.

select * from rental;
select * from inventory;
select * from film;

select
	f.title,
	count(f.title) as counter
from rental as r
join inventory as i
on r.inventory_id = i.inventory_id
join film as f
on i.film_id = f.film_id
group by f.title
order by counter desc
limit 10;

-- 5 List the top five genres in gross revenue in descending order.


select * from payment;
select * from rental;
select * from inventory;
select * from film_category;
select * from category;

select 
	c.name,
    round(sum(p.amount),0) as revenue
from payment as p
join rental as r
on p.rental_id = r.rental_id
join inventory as i
on r.inventory_id = i.inventory_id
join film_category as fc
on i.film_id = fc.film_id
join category as c
on fc.category_id = c.category_id
group by c.name
order by revenue
limit 6;


-- 6 Is "Academy Dinosaur" available for rent from Store 1?

select * from inventory;
select * from film;

select 
	f.title,
    i.store_id,
    count(i.film_id) as copies
from inventory as i
join film as f
on i.film_id = f.film_id
where i.store_id = 1 and f.title = "Academy Dinosaur"
group by f.title;

-- 7 Get all pairs of actors that worked together.

select * from film_actor;

SELECT 
t1.actor_id as act1,
t2.actor_id as act2

FROM film_actor as t1
join film_actor as t2
on t1.actor_id < t2.actor_id
AND T1.film_id=T2.film_id
group by act1, act2
order by act1, act2;

-- 8 Get all pairs of customers that have rented the same film more than 3 times.

select * from rental;
select * from inventory;

select 
	r.customer_id, 
	i.film_id, 
    count(i.film_id) as counter
from rental as r
join inventory as i
on r.inventory_id = i.inventory_id
group by r.customer_id, i.film_id
having counter>2
order by r.customer_id;

-- 9 For each film, list actor that has acted in more films.


select t1.*
from (select
	film_id,
    actor_id,
    count(film_id) over (partition by actor_id) as counter
from film_actor) as t1
left join 
(select
	film_id,
    actor_id,
    count(film_id) over (partition by actor_id) as counter
from film_actor) as t2
on t1.film_id = t2.film_id and t1.counter < t2.counter
where t2.counter is null    
order by film_id;

