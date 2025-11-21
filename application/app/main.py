from flask import Flask, request, render_template, redirect
import os
import psycopg2
import redis

app = Flask(__name__)

DB_HOST = os.getenv("DATABASE_HOST", "localhost")
DB_NAME = os.getenv("DATABASE_NAME", "demo")
DB_USER = os.getenv("DATABASE_USER", "user")
DB_PASSWORD = os.getenv("DATABASE_PASSWORD", "pass")

REDIS_HOST = os.getenv("REDIS_HOST", "localhost")
REDIS_PORT = int(os.getenv("REDIS_PORT", "6379"))

def get_db_conn():
    return psycopg2.connect(
        host=DB_HOST,
        dbname=DB_NAME,
        user=DB_USER,
        password=DB_PASSWORD,
    )

def get_redis():
    return redis.Redis(host=REDIS_HOST, port=REDIS_PORT, decode_responses=True)

def init_db():
    conn = get_db_conn()
    cur = conn.cursor()
    cur.execute(
        """
        CREATE TABLE IF NOT EXISTS names (
            id SERIAL PRIMARY KEY,
            name TEXT NOT NULL
        );
        """
    )
    conn.commit()
    cur.close()
    conn.close()

@app.route("/", methods=["GET", "POST"])
def index():
    init_db()
    r = get_redis()

    if request.method == "POST":
        name = request.form["name"]
        conn = get_db_conn()
        cur = conn.cursor()
        cur.execute("INSERT INTO names (name) VALUES (%s);", (name,))
        conn.commit()
        cur.close()
        conn.close()
        r.incr("names_total")
        return redirect("/")

    conn = get_db_conn()
    cur = conn.cursor()
    cur.execute("SELECT id, name FROM names ORDER BY id;")
    names = cur.fetchall()
    cur.close()
    conn.close()

    total = r.get("names_total") or "0"

    return render_template("index.html", names=names, total=total)

@app.route("/delete", methods=["POST"])
def delete_name():
    init_db()
    id_to_delete = request.form.get("id")

    conn = get_db_conn()
    cur = conn.cursor()
    cur.execute("DELETE FROM names WHERE id = %s;", (id_to_delete,))
    conn.commit()
    cur.close()
    conn.close()

    r = get_redis()
    current = r.get("names_total")
    if current and int(current) > 0:
        r.decr("names_total")

    return redirect("/")

@app.route("/clear", methods=["POST"])
def clear_all():
    init_db()

    conn = get_db_conn()
    cur = conn.cursor()
    cur.execute("DELETE FROM names;")
    conn.commit()
    cur.close()
    conn.close()

    r = get_redis()
    r.set("names_total", 0)

    return redirect("/")

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5001)
