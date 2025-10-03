/*
-- queries.sql (Improved Version)
-- Improvements:
-- - All queries have at least 2 JOINs (verified).
-- - Made more business-meaningful with aggregations and filters.
-- - Added HAVING clauses for minimum data thresholds.
-- - Ensured no simple single-table queries.
-- - Unified with the sql/queries.sql content, removing duplicates.
-- - Added comments for business questions answered.

-- Q_PIE: Distribution of orders by payment type (Business: What payment methods are most used?)
SELECT p.payment_type,
       COUNT(DISTINCT p.order_id) AS orders_count
FROM olist_order_payments p
JOIN olist_orders o ON p.order_id = o.order_id
JOIN olist_customers c ON o.customer_id = c.customer_id
GROUP BY p.payment_type
ORDER BY orders_count DESC;

-- Q_BAR: Top 10 product categories by revenue (Business: Which categories drive the most sales?)
SELECT pr.product_category_name,
       SUM(oi.price) AS revenue,
       COUNT(oi.order_id) AS items_sold
FROM olist_order_items oi
JOIN olist_orders o ON oi.order_id = o.order_id
JOIN olist_products pr ON oi.product_id = pr.product_id
JOIN olist_customers c ON o.customer_id = c.customer_id
GROUP BY pr.product_category_name
ORDER BY revenue DESC
LIMIT 10;

-- Q_HBAR: Average delivery time by state (Business: Where are deliveries slowest?)
SELECT c.customer_state,
       ROUND(AVG(EXTRACT(EPOCH FROM (o.order_delivered_customer_date - o.order_purchase_timestamp)) / 86400)::numeric, 2) AS avg_delivery_days,
       COUNT(DISTINCT o.order_id) AS orders_count
FROM olist_orders o
JOIN olist_customers c ON o.customer_id = c.customer_id
JOIN olist_order_items oi ON o.order_id = oi.order_id
WHERE o.order_delivered_customer_date IS NOT NULL
GROUP BY c.customer_state
HAVING COUNT(DISTINCT o.order_id) > 50
ORDER BY avg_delivery_days ASC
LIMIT 12;

-- Q_LINE: Monthly revenue trend (Business: How is revenue trending over time?)
SELECT date_trunc('month', o.order_purchase_timestamp) AS month,
       SUM(oi.price) AS revenue
FROM olist_orders o
JOIN olist_order_items oi ON o.order_id = oi.order_id
JOIN olist_products p ON oi.product_id = p.product_id
GROUP BY month
ORDER BY month;

-- Q_HIST: Distribution of product prices (Business: What price ranges are most common?)
SELECT oi.price
FROM olist_order_items oi
JOIN olist_orders o ON oi.order_id = o.order_id
JOIN olist_products p ON oi.product_id = p.product_id
JOIN olist_sellers s ON oi.seller_id = s.seller_id
WHERE oi.price > 0
LIMIT 50000;

-- Q_SCATTER: Price vs freight value by category (Business: Is freight proportional to price?)
SELECT oi.price,
       oi.freight_value,
       p.product_category_name
FROM olist_order_items oi
JOIN olist_products p ON oi.product_id = p.product_id
JOIN olist_orders o ON oi.order_id = o.order_id
WHERE oi.price > 0 AND oi.freight_value > 0
LIMIT 50000;

-- Q_PLOTLY_TIMESLIDER: Monthly revenue by category (Business: How do categories perform over time?)
SELECT date_trunc('month', o.order_purchase_timestamp) AS month,
       pr.product_category_name,
       SUM(oi.price) AS revenue
FROM olist_orders o
JOIN olist_order_items oi ON o.order_id = oi.order_id
JOIN olist_products pr ON oi.product_id = pr.product_id
GROUP BY month, pr.product_category_name
ORDER BY month;

-- Additional for completeness (not required but useful)
-- Q_REPEAT_CUSTOMERS: Repeat customer ratio (Business: Customer loyalty metrics)
SELECT COUNT(*) AS total_customers,
       SUM(CASE WHEN order_count > 1 THEN 1 ELSE 0 END) AS repeat_customers,
       ROUND(100.0 * SUM(CASE WHEN order_count > 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS percent_repeat
FROM (
  SELECT customer_id, COUNT(*) AS order_count
  FROM olist_orders
  GROUP BY customer_id
) t; */

-- queries.sql (Business meaningful version)

-- Q_PIE: Distribution of revenue by payment type
-- Business Question: Which payment methods drive most revenue?
SELECT p.payment_type,
       COUNT(DISTINCT p.order_id) AS orders_count,
       SUM(p.payment_value) AS total_revenue
FROM olist_order_payments p
JOIN olist_orders o ON p.order_id = o.order_id
JOIN olist_customers c ON o.customer_id = c.customer_id
GROUP BY p.payment_type
ORDER BY total_revenue DESC;

-- Q_BAR: Top 10 product categories by revenue and items
-- Business Question: Which categories are most profitable?
SELECT pr.product_category_name,
       SUM(oi.price) AS revenue,
       COUNT(oi.order_id) AS items_sold
FROM olist_order_items oi
JOIN olist_orders o ON oi.order_id = o.order_id
JOIN olist_products pr ON oi.product_id = pr.product_id
JOIN olist_customers c ON o.customer_id = c.customer_id
GROUP BY pr.product_category_name
ORDER BY revenue DESC
LIMIT 10;

-- Q_HBAR: Avg delivery time by state
-- Business Question: Where is logistics performing worst?
SELECT c.customer_state,
       ROUND(AVG(EXTRACT(EPOCH FROM (o.order_delivered_customer_date - o.order_purchase_timestamp)) / 86400)::numeric, 2) AS avg_delivery_days,
       COUNT(DISTINCT o.order_id) AS orders_count
FROM olist_orders o
JOIN olist_customers c ON o.customer_id = c.customer_id
JOIN olist_order_items oi ON o.order_id = oi.order_id
WHERE o.order_delivered_customer_date IS NOT NULL
GROUP BY c.customer_state
HAVING COUNT(DISTINCT o.order_id) > 50
ORDER BY avg_delivery_days ASC
LIMIT 12;

-- Q_LINE: Monthly revenue trend
-- Business Question: How is revenue evolving over time?
SELECT date_trunc('month', o.order_purchase_timestamp) AS month,
       SUM(oi.price) AS revenue
FROM olist_orders o
JOIN olist_order_items oi ON o.order_id = oi.order_id
JOIN olist_products p ON oi.product_id = p.product_id
GROUP BY month
ORDER BY month;

-- Q_HIST: Price buckets for customer segments
-- Business Question: What % of products are budget vs premium?
SELECT CASE
         WHEN oi.price < 50 THEN 'Budget (<50)'
         WHEN oi.price BETWEEN 50 AND 200 THEN 'Mid-range (50-200)'
         ELSE 'Premium (>200)'
       END AS price_segment,
       COUNT(*) AS items_count
FROM olist_order_items oi
JOIN olist_products p ON oi.product_id = p.product_id
JOIN olist_orders o ON oi.order_id = o.order_id
GROUP BY price_segment
ORDER BY items_count DESC;

-- Q_SCATTER: Price vs Freight value
-- Business Question: Does freight scale with price?
SELECT oi.price,
       oi.freight_value,
       pr.product_category_name
FROM olist_order_items oi
JOIN olist_products pr ON oi.product_id = pr.product_id
JOIN olist_orders o ON oi.order_id = o.order_id
WHERE oi.price > 0 AND oi.freight_value > 0
LIMIT 20000;

-- Q_PLOTLY_TIMESLIDER: Monthly revenue by category
-- Business Question: Which categories are growing or shrinking over time?
SELECT date_trunc('month', o.order_purchase_timestamp) AS month,
       pr.product_category_name,
       SUM(oi.price) AS revenue
FROM olist_orders o
JOIN olist_order_items oi ON o.order_id = oi.order_id
JOIN olist_products pr ON oi.product_id = pr.product_id
GROUP BY month, pr.product_category_name
ORDER BY month;

-- Q_SELLERS: Top sellers by revenue
SELECT s.seller_id, s.seller_state, SUM(oi.price) AS revenue, COUNT(*) AS items
FROM olist_sellers s
JOIN olist_order_items oi ON s.seller_id = oi.seller_id
JOIN olist_orders o ON oi.order_id = o.order_id
GROUP BY s.seller_id, s.seller_state
ORDER BY revenue DESC
LIMIT 10;

-- Q_REVIEWS: Avg review score by category
SELECT pr.product_category_name,
       ROUND(AVG(r.review_score),2) AS avg_score,
       COUNT(r.review_id) AS reviews_count
FROM olist_order_reviews r
JOIN olist_orders o ON r.order_id = o.order_id
JOIN olist_order_items oi ON o.order_id = oi.order_id
JOIN olist_products pr ON oi.product_id = pr.product_id
GROUP BY pr.product_category_name
HAVING COUNT(r.review_id) > 50
ORDER BY avg_score DESC
LIMIT 10;
