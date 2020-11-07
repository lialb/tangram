import requests
def query_neo4j(url, user, password, query):
    r = requests.post(url, auth=(user, password), data = query)
    return r.text