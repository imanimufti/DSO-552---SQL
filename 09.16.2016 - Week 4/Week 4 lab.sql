-- Week 4

-- Q1. Find the total sales in usd for each account. You should include two columns: the total sales for each
-- company’s orders in usd and the company name.

select a.name, sum(o.total_amt_usd) as total_sales
from orders o
join accounts a 
on o.account_id = a.id
group by a.name
order by total_sales desc;

--Q2. Total number of time each type of channel from web_events was used?
-- Two columns - channel and number of times the channel was used
select distinct channel
from web_events;

select channel, count(*) total
from web_events
group by channel
order by total desc;

--Q3. What was the largest order placed by each account in terms of total usd.
-- columns account name and total usd
select a.name, max(o.total_amt_usd) max_amt
from orders o
join accounts a
on o.account_id = a.id
group by a.name
order by max_amt desc;

--Q4. Find the number of sales representatives in each region
-- two columns, region and sales_reps. Order from fewest to most reps
select r.name, count(*) num_of_reps 
from sales_reps s
join region r
on s.region_id = r.id
group by r.name
order by 2

--Q5 For each a/c, determine avg amount of each type of paper purchased.
-- four columns - a/c name and each type of paper
select a.name, round(avg(standard_amt_usd),2) avg_std_amt_usd , 
				round(avg (poster_amt_usd),2) avg_poster_amt_usd,
				round(avg (gloss_amt_usd),2) avg_gloss_amt_usd
from accounts a
join orders o
on a.id = o.account_id
group by a.name;

--6
-- Determine number of times  aparticular channel was used in web_events tables for each sales rep,
-- should have three columns - name of sales rep, channel, number of occurrences. 
-- Order table with highest number of occurences first. 

select s.name, w.channel, count(*) num_events
from web_events w
join accounts a
on w.account_id = a.id
join sales_reps s
on s.id = a.sales_rep_id
group by s.name, w.channel
order by num_events desc;

--7
-- How many of the sales representatives have more than  5 accounts
-- they manage?
select count(*)
from (
	select s.name, count(*) num_of_accounts
	from sales_reps s
	join accounts a
	on a.sales_rep_id = s.id
	group by s.name -- assuming that names are unique otherwise use id
	having count(*) > 5
	order by 2
) table1;
-- You cant use alias with having because the alias is assigned
-- at the very end once the aggregation is done. 
-- Tab to indent, shift tab to revert text

--Q8 
-- How many accounts have more than 20 orders? 
--select a.name, o.account_id
--from accounts a
--join orders o
--on a.id = o.account_id
--group by account_id
--having count (*) > 20
-- Incorrect query. Try to return query with account name.

-- Q8(done by Abbas)
select count(*)
from(
	select account_id, count(*) total_orders
	from orders
	group by account_id
	having count(*) > 20
	) table1;
	
-- Q9
-- Which a/c has the most orders?
select a.name, count(*) total_orders
from orders o
join accounts a
on a.id = o.account_id
group by a.name
order by 2 desc
limit 1

--10
-- How many accounts spent more than $30k total with PP?

select count(*)
from(
	select a.name, sum(o.total_amt_usd) total_spent
	from accounts a
	join orders o
	on a.id = o.account_id
	group by a.name
	having sum(o.total_amt_usd)> 30000
)table1;

-- Q11.
-- Which account has spent the most with us?
select a.name, sum(o.total_amt_usd) total_spent
from orders o
join accounts a
on a.id = o.account_id
group by a.name
order by total_spent desc
limit 1;

-- Q12 Which account used fb the most as a channel?
select a.name, w.channel, count(*)
from web_events w
join accounts a
on w.account_id = a.id
where w.channel = 'facebook'
group by a.name, w.channel
order by 3 desc
limit 1

-- Q13 - Which a/c used fb as a channel to contact customers 
-- more than six times. 
select a.name, w.channel, count(*)
from web_events w
join accounts a
on w.account_id = a.id
where w.channel = 'facebook'
group by a.name, w.channel
having count(*) > 6
order by 3 desc

-- 14 Which channel was the most frequently used by different a/cs?
select a.name, w.channel, count(*)
from web_events w
join accounts a
on w.account_id = a.id
group by a.name, w.channel
order by 3 desc;

-- 1515. Find the sales ($) for all orders in each year, ordered from largest to smallest. Do you notice any trends
-- in the yearly sales totals?

select date_part('year', occurred_at) order_year, sum(total_amt_usd) total_spent
from orders o 
group by order_year
order by 1;

-- 16. Which month did PP have the largest sales ($) in 2016?
select date_part('month', occurred_at) order_month, sum(total_amt_usd) total_spent
from orders o
where date_part('year', occurred_at) = 2016
group by order_month
order by 2 desc
limit 1;

--17. In which month did walmart spend the most on gloss paper?
select date_trunc('month', o.occurred_at) order_date,
		sum(o.gloss_amt_usd) total_spent
from orders o
join accounts a
on a.id=o.account_id
where a.name = 'Walmart'
group by order_date
order by 2 desc
limit 1;

--18. CASE STATEMENT

select a.name, sum(o.total_amt_usd) total_spent,
	case when sum(o.total_amt_usd) > 200000 THEN 'Top'
		when sum(o.total_amt_usd) > 100000 THEN 'Medium'
		else 'Low'
		end account_level
from orders o
join accounts a
on a.id = o.account_id
group by a.name

-- 19. Restrict the results of previous question to the orders occurred
-- only in 2016 and 2017
select a.name, sum(o.total_amt_usd) total_spent,
	case when sum(o.total_amt_usd) > 200000 THEN 'Top'
		when sum(o.total_amt_usd) > 100000 THEN 'Medium'
		else 'Low'
		end account_level
from orders o
join accounts a
on a.id = o.account_id
where date_part('year', o.occurred_at) in (2016,2017)
group by a.name;

--20.
select s.name, count(*) num_orders,
		case when count(*) > 200 THEN 'Top'
		else 'Not'
		end sales_rep_level
from sales_reps s
join accounts a
on s.id = a.sales_rep_id
join orders o
on a.id = o.account_id
group by s.name
order by 2 desc;

-- 21 
select s.name, count(*) num_orders, sum(total_amt_usd) total_spent,
		case when count(*) > 200 or sum(total_amt_usd) > 750000 then 'Top'
			 when count(*) > 150 or sum(total_amt_usd) > 500000 then 'Middle'
			 else 'low'
		end sales_rep_level
from sales_reps s
join accounts a
on s.id = a.sales_rep_id
join orders o
on a.id = o.account_id
group by s.name
order by 3 desc;