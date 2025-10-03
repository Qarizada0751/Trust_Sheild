# Mercado Insights: Brazilian E-Commerce Data Analysis

## 📌 Project Overview
This project analyzes the [Olist Brazilian E-Commerce dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) using **PostgreSQL** and **Python**.  
It demonstrates skills in **data visualization, SQL analysis, and Python-Postgres integration**.  

## ⚙️ Tools & Technologies
- PostgreSQL (Database)
- pgAdmin 4 (DB management)
- Python 3 (Analysis)
- Psycopg2 & Pandas (DB connection & data processing)
- VS Code (IDE)

## 🗂️ Project Structure
mercadoinsights-olist-ecommerce/
│── main.py # Python script to run queries
│── requirements.txt # Python dependencies
│── README.md # Documentation
│
├── sql/
│ ├── schema.sql # Database schema
│ └── queries.sql # Analytical SQL queries
│
├── outputs/ # Query results (CSV)
│ ├── query_01.csv
│ ├── query_02.csv
│ └── ...
│
├── er_diagram.png # ER diagram of DB tables
│
└── venv/ # Virtual environment

sql
Copy code

## 🛠️ Setup Instructions

### 1. Database Setup
1. Open **pgAdmin** and log in as superuser (`postgres`).
2. Create role:
   ```sql
   CREATE USER mi_user WITH PASSWORD 'strongpass' LOGIN;
Create database:

sql
Copy code
CREATE DATABASE mercadoinsights_db OWNER mi_user;
Open sql/schema.sql in pgAdmin Query Tool → run it.

Import CSVs into their matching tables (customers, orders, order_items, etc.).

2. Python Setup
bash
Copy code
cd C:\Users\musta\mercadoinsights-olist-ecommerce
venv\Scripts\activate.bat
pip install -r requirements.txt
python main.py
3. Outputs
All results are saved into the outputs/ folder as CSV files.

Example:

query_01.csv → list of recent orders

query_03.csv → monthly revenue

query_04.csv → top-selling categories

query_07.csv → payment methods analysis


# Project Startup Instructions

1️⃣ Database (pgAdmin)

Open pgAdmin 4

Connect as postgres → check that your database exists: mercadoinsights_db

Verify that it has 9 tables (olist_customers, olist_orders, etc.).

If empty → re-run schema.sql in Query Tool, then import CSVs.

2️⃣ VS Code (Python)

# navigating terminal to pgadmin or project environment
"C:\Program Files\PostgreSQL\17\bin\psql.exe" -U mi_user -d mercadoinsights_db -W
# then password: "strongpass"


# Activate virtual environment:

venv\Scripts\activate.bat


# Run project:

python main.py


👉 This will:

* Connect to Postgres

* Run queries from sql/queries.sql

* Save results into outputs/ as CSV files.

# Assignment 2 — Visualizations & Exports (MercadoInsights)

## Overview
This script generates 6 charts from the Olist e-commerce dataset (Postgres) and exports a formatted Excel report. It also provides an interactive Plotly time-slider.

## Files
- `queries.sql` — SQL queries used (each with JOINs)
- `analytics.py` — main script that creates charts, plotly slider, exports to Excel
- `insert_demo.sql` — demo insert for live update during defense
- `charts/` — generated PNG charts (output)
- `exports/` — generated Excel report

## Setup
1. Activate your project virtualenv and install packages:
python -m venv venv
venv\Scripts\activate.bat
pip install -r requirements.txt

1. Ensure .env has DB credentials (same as Assignment 1), or set environment variables:
DB_USER, DB_PASS, DB_HOST, DB_PORT, DB_NAME

## Run
- Generate charts + export:
python analytics.py

This will produce PNG files in `charts/` and Excel file in `exports/`.

- live demo:
1. Run `python analytics.py` (show a chosen chart).
2. Run `insert_demo.sql` in pgAdmin or psql to add a demo order.
3. Re-run `python analytics.py` and show that the chart changed.

