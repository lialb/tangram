from flask import Flask, jsonify, request
from flask_cors import CORS
import config
import json
import mysql.connector
from neo4j_api import query_neo4j

app = Flask(__name__)

CORS(app, resources={r"/*": {"origins": "*"}})

mysqlSecrets = config.mysqlKey
neo4jSecrets = config.neo4jKey

try:
    connection = mysql.connector.connect(
        host=mysqlSecrets['host'],
        user=mysqlSecrets['user'],
        password=mysqlSecrets['password'],
        database=mysqlSecrets['database']
    )
except mysql.connector.Error as e:
    print('Ran into mysql exception: {}'.format(e))

try:
    print(query_neo4j(neo4jSecrets.url, neo4jSecrets.user, neo4jSecrets.password, {"query" : "MATCH (n) RETURN n LIMIT 25"}))
    print('NEO4J CONNECTED')
except:
    print('Ran into neo4j exception')

@app.route('/')
def home():
    return 'Connected to server'

@app.route('/get-user/<string:username>')
def getUser(username):
    try:
        cur = connection.cursor()
        cur.execute("SELECT * FROM users where username = '{}'".format(username))
        headers = [x[0] for x in cur.description]
        result = [dict(zip(headers, row)) for row in cur.fetchall()]
        cur.close()
        return json.dumps(result)
    except mysql.connector.Error as e:
        print('Ran into exception: {}'.format(e))

@app.route('/get-all-users')
def getAllUsers():
    try:
        cur = connection.cursor()
        cur.execute("SELECT * FROM users")
        headers = [x[0] for x in cur.description]
        result = [dict(zip(headers, row)) for row in cur.fetchall()]
        cur.close()
        return json.dumps(result)
    except mysql.connector.Error as e:
        print('Ran into exception: {}'.format(e))

@app.route('/create-user', methods=['POST'])
def createUser():
    username = request.form['Username']
    print(username)
    try:
        cur = connection.cursor()
        cur.execute("INSERT INTO users(Username, TotalLikes, ProfilePicture) VALUES ('{}', '{}', {})".format(username, 0, 'NULL'))
        connection.commit()
        cur.close()
        return json.dumps([{ 'Insert' : 'Success' }])
    except mysql.connector.Error as e:
        print('Ran into exception: {}'.format(e))
    
@app.route('/delete-user', methods=['DELETE'])
def deleteUser():
    username = request.form['Username']
    try:
        cur = connection.cursor()
        cur.execute("DELETE FROM users where username = '{}'".format(username))
        connection.commit()
        cur.close()
        return 'Successfully added user: {}'.format(username)
    except mysql.connector.Error as e:
        print('Ran into exception: {}'.format(e))
    
@app.route('/get-post/<string:PostId>')
def getPost(PostId):
    pass

    
if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)





