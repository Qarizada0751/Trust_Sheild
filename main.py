# main.py
import os
from sqlalchemy import create_engine, text # type: ignore
import pandas as pd # type: ignore
from dotenv import load_dotenv  # type: ignore

# Load .env file
load_dotenv()

DB_USER = os.getenv("DB_USER", "mi_user")
DB_PASS = os.getenv("DB_PASS", "strongpass")
DB_HOST = os.getenv("DB_HOST", "localhost")
DB_PORT = os.getenv("DB_PORT", "5432")
DB_NAME = os.getenv("DB_NAME", "mercadoinsights_db")

CONN_STR = f"postgresql+psycopg2://{DB_USER}:{DB_PASS}@{DB_HOST}:{DB_PORT}/{DB_NAME}"
engine = create_engine(CONN_STR)

def read_queries(path="sql/queries.sql"):
    with open(path, "r", encoding="utf-8") as f:
        raw = f.read()
    return [q.strip() for q in raw.split(";") if q.strip()]

def run_and_save(queries):
    out_dir = "outputs"
    os.makedirs(out_dir, exist_ok=True)
    for i, q in enumerate(queries, start=1):
        try:
            print(f"\n--- Running query {i} ---")
            df = pd.read_sql_query(text(q), engine)
            print(df.head(10).to_string(index=False))
            csv_path = os.path.join(out_dir, f"query_{i:02d}.csv")
            df.to_csv(csv_path, index=False)
            print(f"Saved: {csv_path}")
        except Exception as e:
            print(f"Query {i} failed: {e}")

if __name__ == "__main__":
    queries = read_queries("sql/queries.sql")
    run_and_save(queries)
