-- Lab 6- Data Cleaning
--LEFT and RIGHT
--1. In the accounts table, there is a column holding the website for each company. The last three digits
--specify what type of web address they are using. Pull these extensions and provide how many of each
--website type exist in the accounts table.

select right(website, 3) ext, count(*)
from accounts
group by ext;

-- 2. There is much debate about how much the name (or even the first letter of a company name) matters.
-- Use the accounts table to pull the first letter of each company name to see the distribution of company
-- names that begin with each letter (or number).

select left(name,1), count(*)
from accounts
group by 1
order by 1;

-- There are two E's (one small and one capital), in order to consider them as one.

select upper(left(name,1)), count(*)
from accounts
group by 1
order by 1;

--Q3
--What is the number of company names that start with a vowel and consonant letters?
-- vowel: a, e, i, u, o
-- Create a new variable(letter_type) to state if a name starts with vowel or consonant.
-- To create a new variable use a case statement.

with t1 as (
select left(name,1) letter,
	case when lower(left(name, 1)) in ('a', 'e', 'i','u','o') then 'vowel' else 'consonant'
	end as letter_type
from accounts
)
select letter_type, count(*)
from t1
group by letter_type;

-- Without a subquery
select 
	case when lower(left(name, 1)) in ('a', 'e', 'i','u','o') then 'vowel' else 'consonant'
	end as letter_type, count(*)
from accounts
group by letter_type


--Q4 POSITION
-- Use the accounts table to create first and last name columns that hold the first and last names for the
-- primary_poc.

select primary_poc, position(' ' in primary_poc), length(primary_poc)
from accounts
 
-- Continued

select primary_poc, position(' ' in primary_poc), length(primary_poc),
	left(primary_poc, position(' ' in primary_poc)-1) first_name,
	right(primary_poc, length(primary_poc)- position(' ' in primary_poc)) lastname
from accounts

--CONCAT
-- 5. Each company in the accounts table wants to create an email address for each primary_poc. The
-- email address should be the first name of the primary_poc last name primary_poc @ company name
-- .com. (e.g. tamara.tuma@walmart.com)

--Example of Concat
select concat(name, ' ', website)
from accounts

with t1 as (
select primary_poc, name,
    left(primary_poc, position(' ' in primary_poc)-1) first_name,
	right(primary_poc, length(primary_poc)- position(' ' in primary_poc)) lastname
from accounts
)
select primary_poc, 
	concat(first_name, '.', lastname, '@', name, '.com')
from t1

--6. 

--You may have noticed that in the previous solution some of the company names include spaces, which
--will certainly not work in an email address. See if you can create an email address that will work by
--removing all of the spaces in the account name, but otherwise your solution should be just as in the
--previous question.

select lower(concat(left(primary_poc, position(' ' in primary_poc) - 1), '.' ,
 right(primary_poc, length(primary_poc) - position(' ' in primary_poc)),
 '@', replace(name, ' ',''),'.','com'))
from accounts

--OR

with t1 as (
select primary_poc, name,
    left(primary_poc, position(' ' in primary_poc)-1) first_name,
	right(primary_poc, length(primary_poc)- position(' ' in primary_poc)) lastname
from accounts
)
select primary_poc, 
	concat(first_name, '.', lastname, '@',replace(name, ' ', ''), '.com')
from t1
-- replace (name, ' ', '')
-- Replace the ' ' in name with '' (Remove the space in name)
--7

-- SUBSTRING
--Starting from character 4, extract 2 letters

select substr(name, 4, 2)
from accounts

--Q7
--7. We would also like to create an initial password, which they will change after their first log in. The
--password will be a combination of:
--• the first letter of the primary_poc’s first name (lowercase),
--• the last letter of their first name (lowercase),
--• the first letter of their last name (uppercase),
--• the last letter of their last name (uppercase),
--• the number of letters in their first name,
--• the number of letters in their last name, and
--• the name of the company they are working with, no spaces
--• the forth and fifth digit of their sales rep id
	
with t1 as (
select primary_poc, replace(name, ' ', '') as company, sales_rep_id,
	lower(left(primary_poc, position(' ' in primary_poc)-1)) first_name,
	lower(right(primary_poc, length(primary_poc) - position(' ' in primary_poc))) lastname
from accounts
)
select primary_poc,
		concat(left(first_name,1),
		right(first_name,1),
		upper(left(lastname, 1)),
		upper(right(lastname,1)),
		length(first_name),
		length(lastname),
		company,
		substr(sales_rep_id::text,4,2))
from t1


-- Window Functions 
--Q8
-- For the orders table, create a new column which shows the total number of transactions for all accounts

select *, sum(total_amt_usd) over() as overall_total
from orders

--9.
-- Update the previous query to create two new column: (1) over_all_total_by_account_id, and (2)
-- overall_count_by_account_id (without using Group By).

select account_id, total_amt_usd,
	sum(total_amt_usd) over(partition by account_id) as overall_total_byaccount,
	count(*) over(partition by account_id) as count_byaccount
from orders

--10
-- Create a running total of standard_amt_usd (in the orders table) over order time.

select occurred_at, standard_amt_usd
from orders
order by 1

--

select occurred_at, standard_amt_usd,
	sum(standard_amt_usd) over(order by occurred_at) as running_total
from orders

-- In windows function (we can use order_by and partition by function)

--11 Create a running total of standard_amt_usd (in the orders table) over order time for each month

select occurred_at, standard_amt_usd, date_trunc('month', occurred_at),
	sum(standard_amt_usd) over(partition by date_trunc('month', occurred_at) order by occurred_at) as running_total_month
from orders

-- 12
-- Create a running total of standard_qty (in the orders table) over order time for each year.
select occurred_at, standard_qty, date_trunc('year', occurred_at),
	sum(standard_qty) over(partition by date_trunc('year', occurred_at) order by occurred_at) as running_total_month
from orders

--  RAW_NUMBER() and RANK(), DENSE_RANK()
-- 13. For account with id 1001, use the row_number(), rank() and dense_rank() to rank the transactions
-- by the number of standard paper purchased.

select standard_qty,
	row_number() over(order by standard_qty),
	rank() over(order by standard_qty),
	dense_rank() over(order by standard_qty)
from orders
where account_id = 1001

--14. For each account, use the row_number(), rank() and dense_rank() to rank the transactions by the
-- number of standard paper purchased.

select account_id, standard_qty,
	row_number() over(partition by account_id order by standard_qty),
	rank() over(partition by account_id order by standard_qty),
	dense_rank() over(partition by account_id order by standard_qty)
from orders

--15. Select the id, account_id, and standard_qty variable from the orders table, then create a
-- column called dense_rank that ranks this standard_qty amount of paper for each account. In addition,
-- create a sum_std_qty which gives you the running total for account. Repeat the last task to get the
-- avg, min, and max

select id, account_id, standard_qty,
	dense_rank() over(partition by account_id order by standard_qty) d_rank,
	sum(standard_qty) over (partition by account_id order by standard_qty) sum_std_qty,
	avg (standard_qty) over (partition by account_id order by standard_qty) avg_std_qty,
	min (standard_qty) over (partition by account_id order by standard_qty) min_std_qty,
	max (standard_qty) over (partition by account_id order by standard_qty) max_std_qty
from orders
							 
--16 Give an allias for the window function in the previous question, and call it account_window							 
select id, account_id, standard_qty,
	dense_rank() over(partition by account_id order by standard_qty) d_rank,
	sum (standard_qty) over account_window sum_std_qty,
	avg (standard_qty) over account_window avg_std_qty,
	min (standard_qty) over account_window min_std_qty,
	max (standard_qty) over account_window max_std_qty
from orders
window account_window as (partition by account_id order by standard_qty)
							 
-- 17. 
--Use the NTILE functionality to divide the accounts into 4 levels in terms of the amount of standard_qty
--for their orders. Your resulting table should have the account_id, the occurred_at time for each order,
--the total amount of standard_qty paper purchased, and one of four levels in a standard_quartile
--column.

select account_id, occurred_at, standard_qty,
	ntile(4) over(partition by account_id order by standard_qty) as standard_qty_quartile
from orders

--18.
select account_id, occurred_at, standard_qty,
	ntile(2) over(partition by account_id order by gloss_qty) as standard_qty_quartile
from orders