import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:page_transition/page_transition.dart';
import 'package:tangram/user_info.dart';

import 'constants.dart';

class UsersExplore extends StatefulWidget {
  @override
  _UsersExploreState createState() => _UsersExploreState();
}

class _UsersExploreState extends State<UsersExplore> {
  List<UserData> userData = [];
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
    var response = await http.get(url);
    if (response.statusCode == 200) {
      userData = [];
      var jsonResponse = convert.jsonDecode(response.body);
      for (Map<String, dynamic> item in jsonResponse) {
        userData.add(UserData.fromJson(item));
        print('added item');
      }
      setState(() {});
      print(jsonResponse);
      // var itemCount = jsonResponse['totalItems'];
      // print('Number of books about http: $itemCount.');
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Users'),
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: getUserData, child: Icon(Icons.add)),
        body: Column(children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: getUserData,
              child: ListView.builder(
                  itemCount: userData.length,
                  itemBuilder: (context, index) {
                    return UserItem(data: userData[index]);
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

  UserData({this.username, this.name, this.likes, this.description});

  UserData.fromJson(Map<String, dynamic> json)
      : username = json['Username'],
        name = json['Name'],
        likes = json['TotalLikes'],
        description = json['Description'];
}

class UserItem extends StatelessWidget {
  final UserData data;
  const UserItem({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.fade, child: UserInfo(data: data)));
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
                Text(data.name),
                Text('@${data.username}'),
              ],
            )),
            Icon(Icons.chevron_right)
          ],
        ),
      ),
    );
  }
}
