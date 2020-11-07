'''
Backend API Server to connect to MySQL and Neo4j databases (hosted on AWS).
'''
from flask import Flask, jsonify, request
from flask_cors import CORS
import config
import json
import mysql.connector
import secrets
from neo4j_api import * 

app = Flask(__name__)

CORS(app, resources={r"/*": {"origins": "*"}})

'''
Config for database secrets is not saved in the repo (only locally)
'''
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


@app.route('/')
def home():
    return 'Connected to server'

@app.route('/get-user/<string:username>')
def getUser(username):
    '''
    Get specific user based on username from MySQL
    '''
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
    '''
    Get all users from `users` table from MySQL DB
    '''
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
    '''
    Create a user in the users table in MySQL.
    Body: "Username"
    '''
    username = request.form['Username']
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
    '''
    Delete user from `users` table given the username
    '''
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

@app.route('/get-all-posts')
def getAllPosts():
    '''
    Get all posts from neo4j db
    '''
    pass

@app.route('/create-post', methods=['POST'])
def createPost():
    '''
    Create a post to neo4j
    Params: text, videoURL, XCoordinate, YCoordinate, Timestamp, Username
    '''
    postID = secrets.token_hex(nbytes=16) # random hash for unique PostIDs
    text = request.form['text']
    videoURL = request.form['videoURL']
    XCoordinate = request.form['XCoordinate']
    YCoordinate = request.form['YCoordinate']
    TimeStamp = request.form['Timestamp']
    username = request.form['Username']

    result = neo4j_api.create_post(postID, text, videoURL, XCoordinate, YCoordinate, TimeStamp, username)
    print(result)
    return json.dumps([{'Status' : result }])

@app.route('/delete-post/<string:PostID>', methods=['DELETE'])
def createPost(PostID):
    result = neo4j_api.delete_post(PostID)
    print(result)
    return json.dumps([{'Status' : result}])
    

@app.route('/update-post-likes/<string:PostID>', methods=['PUT'])
def updatePostLikes(PostID):
    likes = request.form['totalLikes']
    result = neo4j_api.delete_post(PostID, likes)
    return json.dumps([{'Status' : result}])

@app.route('/update-post-title/<string:PostID>', methods=['PUT'])
def updatePostTitle(PostID):
    title = request.form['title']
    result = neo4j_api.updatePostTitle(PostID, title)
    print(result)
    return json.dumps([{'Status' : result}])

@app.route('/update-post-coordinates/<string:PostID>', methods=['PUT'])
def updatePostCoordinates(PostID):
    x = request.form['XCoordinate']
    y = request.form['YCoordinate']
    result = neo4j_api.update_post_coordinates(PostID, x, y)
    print(result)
    return json.dumps([{'Status' : result}])
    




if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)





