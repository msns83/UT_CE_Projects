import pandas as pd
from database_connection import get_connection

def load_table(table_name):
    conn = get_connection()
    df = pd.read_sql_query(f"SELECT * FROM {table_name}", conn)
    conn.close()
    return df
    
for table in ["applicants", "assets", "locations", "finances"]:
    df = load_table(table)
    df.to_pickle(f"./database/{table}.pkl")
    print(f"Loaded {table}: {df.shape}")

conn = get_connection()
queries = [
    ("Defaulters vs Non-defaulters",
    "SELECT risk_flag, COUNT(*) AS count "
    "FROM finances GROUP BY risk_flag;"),

    ("Average Income by House Ownership",
    "SELECT a.house_ownership, ROUND(AVG(f.income), 2) AS avg_income "
    "FROM assets a "
    "JOIN finances f ON a.applicant_id = f.applicant_id "
    "GROUP BY a.house_ownership;"),

    ("Default Rate by Profession",
    "SELECT ap.profession, "
    "       ROUND(AVG(f.risk_flag)*100, 1) AS default_rate_pct "
    "FROM applicants ap "
    "JOIN finances f ON ap.applicant_id = f.applicant_id "
    "GROUP BY ap.profession "
    "ORDER BY default_rate_pct DESC;"),

    ("Top 5 Cities by Number of Defaults",
    "SELECT l.city, COUNT(*) AS num_defaults "
    "FROM locations l "
    "JOIN finances f ON l.applicant_id = f.applicant_id "
    "WHERE f.risk_flag = 1 "
    "GROUP BY l.city "
    "ORDER BY num_defaults DESC "
    "LIMIT 5;"),

    ("Average Experience by Default Flag",
    "SELECT f.risk_flag, ROUND(AVG(ap.experience), 1) AS avg_experience "
    "FROM finances f "
    "JOIN applicants ap ON f.applicant_id = ap.applicant_id "
    "GROUP BY f.risk_flag;")
]

for title, sql in queries:
    df_q = pd.read_sql_query(sql, conn)
    print(f"\n{title}\n{df_q}")

conn.close()