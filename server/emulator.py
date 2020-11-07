import requests

r = requests.post('http://localhost:5000/create-user', data={ 'Username' : 'Albert' })