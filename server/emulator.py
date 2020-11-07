import json
import names
import random
import requests

CREATE_USER = 'http://localhost:5000/create-user'
GET_ALL_USERS = 'http://localhost:5000/get-all-users'

def convertUsersToSet(allUsers):
    # arg is a request type object
    users = allUsers.json()
    userSet = set()
    
    for i in range(len(users)):
        userSet.add(users[i]['Username'])

    return userSet

def addRandomUsers(len, num, currUsers):
    i = 0
    fails = 0
    while (i < num):
        # https://www.askpython.com/python/examples/generate-random-strings-in-python
        toAdd = ""
        for _ in range(len):
            # Considering only upper and lowercase letters
            random_integer = random.randint(97, 97 + 26 - 1)
            flip_bit = random.randint(0, 1)
            # Convert to lowercase if the flip bit is on
            random_integer = random_integer - 32 if flip_bit == 1 else random_integer
            # Keep appending random characters using chr(x)
            toAdd += (chr(random_integer))
        if (toAdd not in currUsers):
            i += 1;
            requests.post(CREATE_USER, data = {'Username' : toAdd, 'Name' : names.get_full_name(), 'Description' : "I love Tangram! It's the best!"})
            currUsers.add(toAdd)
            print(toAdd + ' added to DB\n')
        else:
            fails += 1
            if (fails >= 100000):
                print("Pick a bigger len")
                break
        

#r = requests.post('http://localhost:5000/create-user', data={ 'Username' : 'Albert' })

x = requests.get(GET_ALL_USERS)
s = convertUsersToSet(x)

addRandomUsers(4, 20, s)

print(requests.get(GET_ALL_USERS).text)
