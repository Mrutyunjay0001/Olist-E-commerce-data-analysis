create database olist;
 use olist;
 
# 1 - KPI
# Weekday Vs Weekend (order_purchase_timestamp) Payment Statistics.
select 
    case when DAYOFWEEK(str_to_date(o.order_purchase_timestamp, '%Y-%m-%d')) IN (1, 7) THEN 'Weekend' Else 'Weekday' END AS DayType,
    count(distinct o.order_id) AS TOTALOrders,
	round(sum(p.payment_value)) AS TOTALPayments,
	round(AVG(p.payment_value)) AS AveragePayment
From
    orders o
Join
    orderpayments p ON o.order_id=p.order_id
group by
	DayType;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# 2 - KPI
# Number of Orders with review score 5 and payment type as credit card.

SELECT
      COUNT(DISTINCT p.order_id) AS NumberOforders
FROM
      orderpayments p
JOIN
      orderreviews r ON p.order_id = r.order_id
WHERE
      r.review_score = 5
      AND p.payment_type = 'credit_card';

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

#3rd--KPI
# Average number of days taken for order_delivered_customer_date for pet_shop.

SELECT
      product_category_name,
      round(AVG(datediff(Order_Delivered_Customer_Date, Order_Purchase_Timestamp))) AS avg_delivery_time
FROM
      orders o
Join
	  orderitems i ON i.order_id= o.order_id
Join
	  products p ON p.product_id=i.product_id
Where
      p.product_category_name='pet_shop'
      AND o.order_Delivered_Customer_Date IS NOT NULL;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#4th-- KPI
# Average price and payment values from customers of sao paulo city.

With orderItemsAvg AS(
	Select round(AVG(i.price)) AS avg_order_item_price
    from orderitems i
    join orders o ON i.order_id = o.order_id
    join customers c ON o.customer_id = c.customer_id
    where c.customer_city = "sao paulo"
)
select 
	(select avg_order_item_price from orderItemsAvg) AS avg_order_item_price,
    round(AVG(p.payment_value)) AS avg_payment_value
    from orderpayments p
    join orders o ON p.order_id = o.order_id
    join customers c ON o.customer_id = c.customer_id
    where c.customer_city = "sao paulo";
    
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#5th-- KPI
#Relationship between shipping days (order_delivered_customer_date - order_purchase_timestamp) Vs review scores.

SELECT
	round(AVG(DATEDIFF(Order_Delivered_customer_Date, Order_Purchase_Timestamp)),0) AS AvgShippingDays,
    Review_score
From
	orders o
JOIN
	orderreviews r ON o.Order_id = r.Order_id
Where
	Order_delivered_Customer_Date IS NOT NULL
    AND Order_Purchase_Timestamp IS NOT NULL
GROUP BY
	Review_score;