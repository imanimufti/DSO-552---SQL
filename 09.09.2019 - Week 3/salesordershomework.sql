--1
select vendname vendor_name
from vendors
where vendcity in ('Bellevue','Ballard','Redmond');

--2
select p.productname, pv.wholesaleprice, v.vendname
from products p
join product_vendors pv
on p.productnumber= pv.productnumber
join vendors v
on v.vendorid = pv.vendorid
where pv.wholesaleprice < 100
order by 2;

--3
select distinct c.custfirstname, c.custlastname, p.productname
from customers c
join orders o
on c.customerid = o.customerid
join order_details od 
on o.ordernumber = od.ordernumber
join products p
on od.productnumber = p.productnumber
where p.productname like ('%Helmet%');

--4 
select v.vendname, v.vendstate, v.vendphonenumber, pv.daystodeliver
from vendors v
join product_vendors pv
on v.vendorid = pv.vendorid
join products p
on pv.productnumber = p.productnumber
where p.productname = 'Shinoman 105 SC Brakes'
limit 1;

--5
select distinct quantityordered, productname 
from products p
full join order_details od
on od.productnumber = p.productnumber
order by 1 desc
limit 2

--6
select o.ordernumber, o.shipdate,(od.quotedprice*od.quantityordered) as revenue
from orders o
join order_details od
on o.ordernumber = od.ordernumber
join products p
on p.productnumber = od.productnumber
join product_vendors as pv
on p.productnumber = pv.productnumber
where shipdate between ('2018-01-01') and ('2018-01-31');

--7
select distinct c.custfirstname, c.custlastname, c.custphonenumber
from customers c
join orders o
on c.customerid = o.customerid
join order_details od
on o.ordernumber = od.ordernumber
join products p
on od.productnumber = p.productnumber
where p.productname = 'Shinoman Deluxe TX-30 Pedal';
