import requests
r = requests.post('http://18.206.145.36:7474/db/data/cypher', auth=('neo4j', 'tangram'), data = {"query" : "MATCH (n) RETURN n LIMIT 25"})
print(r.text)