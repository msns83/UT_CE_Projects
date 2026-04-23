import sqlite3

def get_connection(db_path = "./database/dataset.db"):
    conn = sqlite3.connect(db_path)
    conn.row_factory = sqlite3.Row
    return conn

conn = get_connection()
print("Connected to", conn, "\n")
conn.close()