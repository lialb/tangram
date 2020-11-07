import requests
import config

neo4jSecrets = config.neo4jKey

def query_neo4j(url, user, password, query):
    r = requests.post(url, auth=(user, password), data = query)
    return r.text

def update_video_likes(postID, likes):
    query = {"query":"match(v:Video {postID : '" + str(postID) + "'}) set v.likes = " + str(likes) + " return v"}
    return query_neo4j(neo4jSecrets['url'], neo4jSecrets['user'], neo4jSecrets['password'], query)

def delete_post(postID):
    query = {"query":"match(v : Video {postID = '" + str(postID) +  "'}) detach delete v"}
    return query_neo4j(neo4jSecrets['url'], neo4jSecrets['user'], neo4jSecrets['password'], query)
    
def update_title(postID, title):
    query = {"query":"match(v : Video {postID = '" + str(postID) +  "'}) set v.title = '" + str(title) + "'"}
    return query_neo4j(neo4jSecrets['url'], neo4jSecrets['user'], neo4jSecrets['password'], query)

def update_post_coordinates(postID, x, y):
    query = {"query":"match(v : Video {postID = '" + str(postID) +  "'}) set v.coordX = " + str(x) + " set v.coordY = " + str(y)}
    return query_neo4j(neo4jSecrets['url'], neo4jSecrets['user'], neo4jSecrets['password'], query)

def create_post(postID, text, link, x, y, time, username):
    query = {"query":"create(v : Video {text : '" + str(text) + "', link : '" + str(link) + "', coordX : " + str(x) + ", coordY : " + str(y) + ", time : " + str(time) + ", Username : '" + str(username) + "'})"}
    return query_neo4j(neo4jSecrets['url'], neo4jSecrets['user'], neo4jSecrets['password'], query)

def get_all_videos():
    query = {"query":"match(v : Video) return v"}
    return query_neo4j(neo4jSecrets['url'], neo4jSecrets['user'], neo4jSecrets['password'], query)

def get_specific_video(postID):
    query = {"query":"match(v : Video{postID : '" + str(postID) + "'}) return v"}
    return query_neo4j(neo4jSecrets['url'], neo4jSecrets['user'], neo4jSecrets['password'], query)

def get_video_by_coord(x, y):
    query = {"query":"match(v : Video{coordX : " + str(x) + ", coordY: " + str(y) + "}) return v"}
    return query_neo4j(neo4jSecrets['url'], neo4jSecrets['user'], neo4jSecrets['password'], query)
