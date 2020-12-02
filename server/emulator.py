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
        print(users[i]['Username'])
        userSet.add(users[i]['Username'])

    return userSet

def addRandomUsers(num, currUsers):
    i = 0
    fails = 0
    while i < num:
        toAdd = names.get_full_name()
        firstName = toAdd.split()[0]
        if (firstName not in currUsers):
            i += 1
            requests.post(CREATE_USER, json={'Username' : firstName, 'Name' : toAdd, 'Description' : 'I love Tangram! It is the best!'})
            currUsers.add(firstName)
            print(firstName + ' added to DB\n')
        else:
            fails += 1
            if fails >= 100000:
                print("Pick a bigger len")
                break
        

# requests.post(CREATE_USER, json = {'Username' : 'TheodoreSpeaks', 'Name' : 'Teddy Li', 'Description' : 'I like CS and Bees'})
# requests.post(CREATE_USER, json = {'Username' : 'Albear', 'Name' : 'Albert Li', 'Description' : 'Our database got hacked'})
# requests.post(CREATE_USER, json = {'Username' : 'Mdpham', 'Name' : 'Matthew Pham', 'Description' : 'ECE for life'})
# requests.post(CREATE_USER, json = {'Username' : 'Aritrooo', 'Name' : 'Aritro Nandi', 'Description' : 'Epic'})

x = requests.get(GET_ALL_USERS)
s = convertUsersToSet(x)

addRandomUsers(20, s)

print(requests.get(GET_ALL_USERS).text)
