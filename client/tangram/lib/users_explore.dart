import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:page_transition/page_transition.dart';
import 'package:tangram/user_info.dart';

import 'constants.dart';
import 'create_user.dart';

class UsersExplore extends StatefulWidget {
  @override
  _UsersExploreState createState() => _UsersExploreState();
}

class _UsersExploreState extends State<UsersExplore> {
  List<UserData> userData = [];
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    getUserData();
  }

  Future<void> getUserData() async {
    // This example uses the Google Books API to search for books about http.
    // https://developers.google.com/books/docs/overview
    var url = '$ip/get-all-users';

    // Await the http get response, then decode the json-formatted response.
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        userData = [];
        var jsonResponse = convert.jsonDecode(response.body);
        for (Map<String, dynamic> item in jsonResponse) {
          // if (searchController.text in newData)
          userData.add(UserData.fromJson(item));
          // }
          print('added item');
        }
        setState(() {});
        print(jsonResponse);
        // var itemCount = jsonResponse['totalItems'];
        // print('Number of books about http: $itemCount.');
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (SocketException) {
      // Scaffold.of(context).showSnackBar(SnackBar(
      //   content: Text('Unable to connect to server'),
      // ));
    }
  }

  @override
  Widget build(BuildContext context) {
    List<UserData> filtered = userData
        .where((element) =>
            element.name.contains(searchController.text) &&
            element.username.contains(searchController.text))
        .toList();

    return Scaffold(
        appBar: AppBar(
          title: Text('Add a friend'),
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () => Navigator.push(
                context,
                PageTransition(
                    type: PageTransitionType.fade, child: CreateUser())),
            child: Icon(Icons.add)),
        body: Column(children: [
          TextFormField(
            controller: searchController,
            onFieldSubmitted: (String search) {
              setState(() {});
            },
            decoration: InputDecoration(
              hintText: 'Search',
              border: InputBorder.none,
              contentPadding:
                  // TODO: fix alignment
                  EdgeInsets.only(left: 10, top: 12, bottom: 5),
              prefixIcon: Icon(Icons.search),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: getUserData,
              child: ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    return UserItemAdd(username: filtered[index].username);
                  }),
            ),
          )
        ]));
  }
}

class UserData {
  final String username;
  final String name;
  final int likes;
  final String description;
  final List<String> friends;

  static const List<String> friendsDefault = [];

  UserData(
      {this.username = 'loading...',
      this.name = 'Loading...',
      this.likes = 0,
      this.description = "Loading...",
      this.friends = friendsDefault});

  UserData.fromJson(Map<String, dynamic> json)
      : username = json['Username'],
        name = json['Name'],
        likes = json['TotalLikes'],
        description = json['Description'],
        friends =
            (json['Friends'] as List)?.map((item) => item as String)?.toList();
}

class UserItem extends StatelessWidget {
  final String username;
  const UserItem({Key key, this.username}) : super(key: key);

  Future<void> deleteUser(String username) async {
    var url = Uri.parse('$ip/delete-user?Username=$username');
    var request = http.Request("DELETE", url);
    request.send();
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: .25,
      secondaryActions: [
        IconSlideAction(
          caption: 'Remove',
          color: Colors.red,
          icon: Icons.delete_outline,
          onTap: () {
            var url = '$ip/delete-friend';
            http.post(
              url,
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(<String, String>{
                'user1': 'TheodoreSpeaks',
                'user2': username,
              }),
            );
          },
        )
      ],
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.fade,
                  child: UserInfo(
                    username: username,
                  )));
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.blue,
                child: Icon(Icons.person, color: Colors.white),
              ),
              SizedBox(width: 16.0),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text(data.name),
                  Text(username),
                ],
              )),
              Icon(Icons.chevron_right)
            ],
          ),
        ),
      ),
    );
  }
}

class UserItemAdd extends StatefulWidget {
  final String username;
  const UserItemAdd({Key key, this.username}) : super(key: key);

  @override
  _UserItemAddState createState() => _UserItemAddState();
}

class _UserItemAddState extends State<UserItemAdd> {
  bool friend = false;

  Future<void> deleteUser(String username) async {
    var url = Uri.parse('$ip/delete-user?Username=$username');
    var request = http.Request("DELETE", url);
    request.send();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.fade,
                child: UserInfo(
                  username: widget.username,
                )));
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue,
              child: Icon(Icons.person, color: Colors.white),
            ),
            SizedBox(width: 16.0),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text(data.name),
                Text(widget.username),
              ],
            )),
            IconButton(
                onPressed: () {
                  setState(() {
                    friend = !friend;
                  });

                  if (friend) {
                    var url = '$ip/add-friend';
                    http.post(
                      url,
                      headers: <String, String>{
                        'Content-Type': 'application/json; charset=UTF-8',
                      },
                      body: jsonEncode(<String, String>{
                        'user1': 'TheodoreSpeaks',
                        'user2': widget.username,
                      }),
                    );
                  } else {
                    var url = '$ip/delete-friend';
                    http.post(
                      url,
                      headers: <String, String>{
                        'Content-Type': 'application/json; charset=UTF-8',
                      },
                      body: jsonEncode(<String, String>{
                        'user1': 'TheodoreSpeaks',
                        'user2': widget.username,
                      }),
                    );
                  }
                },
                icon: Icon(friend ? Icons.check : Icons.add))
          ],
        ),
      ),
    );
  }
}
