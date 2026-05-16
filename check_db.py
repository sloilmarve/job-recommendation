import sqlite3
conn = sqlite3.connect('recruit.db')
cur = conn.cursor()
cur.execute("SELECT name FROM sqlite_master WHERE type='table'")
print("Tables:", cur.fetchall())
cur.execute("SELECT id, embedding FROM candidate LIMIT 2")
print("Candidates embedding:", cur.fetchall())
cur.execute("SELECT id, embedding FROM job LIMIT 2")
print("Jobs embedding:", cur.fetchall())