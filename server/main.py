from flask import Flask, jsonify
from flask_cors import CORS
import config
import json
import mysql.connector

app = Flask(__name__)

CORS(app, resources={r"/*": {"origins": "*"}})

secrets = config.key

db = mysql.connector.connect(
    host=secrets['host'],
    user=secrets['user'],
    password=secrets['password']
)

@app.route('/')
def home():
    return 'Connected to server'


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)





