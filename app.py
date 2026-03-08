from flask import Flask, render_template, request, redirect
import mysql.connector

app = Flask(__name__)

db = mysql.connector.connect(
    host="contactdb.c90ieoy46fir.us-east-2.rds.amazonaws.com",
    user="admin",
    password="Obatala123#",
    database="contactdb"
)

@app.route("/")
def home():
    return render_template("index.html")

@app.route("/contact", methods=["GET", "POST"])
def contact():
    if request.method == "POST":
        name = request.form["name"]
        email = request.form["email"]
        message = request.form["message"]

        cursor = db.cursor()
        cursor.execute(
            "INSERT INTO contacts (name, email, message) VALUES (%s, %s, %s)",
            (name, email, message)
        )
        db.commit()
        cursor.close()
        return redirect("/thankyou")
    return render_template("contact.html")

@app.route("/thankyou")
def thankyou():
    return render_template("thankyou.html")

@app.route("/submissions")
def submissions():
    cursor = db.cursor()
    cursor.execute("SELECT id, name, email, message FROM contacts")
    messages = cursor.fetchall()
    cursor.close()
    return render_template("submissions.html", submissions=messages)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
