from flask import Flask, render_template
import os, socket

app = Flask(__name__)


@app.route("/")
def hello():
    name = os.environ.get("USER_NAME")
    hostname = socket.gethostname()
    return render_template("hello.html", name=name, hostname=hostname)
