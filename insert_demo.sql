-- insert_demo.sql
-- Warning: use a safe, unique ID for demo to avoid collisions
-- Adjust timestamps to current date if you like

BEGIN;

INSERT INTO olist_customers (customer_id, customer_unique_id, customer_zip_code_prefix, customer_city, customer_state)
VALUES ('demo_customer_0001', 'demo_unique_0001', 12345, 'DemoCity', 'XY')
ON CONFLICT (customer_id) DO NOTHING;

INSERT INTO olist_orders (order_id, customer_id, order_status, order_purchase_timestamp, order_approved_at, order_delivered_carrier_date, order_delivered_customer_date, order_estimated_delivery_date)
VALUES ('demo_order_0001', 'demo_customer_0001', 'delivered', now(), now(), now() + interval '1 day', now() + interval '3 day', now() + interval '7 day')
ON CONFLICT (order_id) DO NOTHING;

-- Insert demo product if not exist
INSERT INTO olist_products (product_id, product_category_name, product_name_length, product_description_lenght, product_photos_qty, product_weight_g, product_length_cm, product_height_cm, product_width_cm)
VALUES ('demo_prod_0001', 'demo_category', 10, 50, 1, 200, 10, 5, 5)
ON CONFLICT (product_id) DO NOTHING;

-- Insert demo seller if not exist
INSERT INTO olist_sellers (seller_id, seller_zip_code_prefix, seller_city, seller_state)
VALUES ('demo_seller_0001', 12345, 'SellerCity', 'XY')
ON CONFLICT (seller_id) DO NOTHING;

-- Insert order item
INSERT INTO olist_order_items (order_id, order_item_id, product_id, seller_id, shipping_limit_date, price, freight_value)
VALUES ('demo_order_0001', 1, 'demo_prod_0001', 'demo_seller_0001', now() + interval '1 day', 9999.99, 50.00)
ON CONFLICT (order_id, order_item_id) DO NOTHING;

-- Insert payment
INSERT INTO olist_order_payments (order_id, payment_sequential, payment_type, payment_installments, payment_value)
VALUES ('demo_order_0001', 1, 'credit_card', 1, 9999.99)
ON CONFLICT (order_id, payment_sequential) DO NOTHING;

COMMIT;
