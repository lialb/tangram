import 'package:flutter/material.dart';
import 'package:tangram/users_explore.dart';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'constants.dart';

class UserInfo extends StatefulWidget {
  // final UserData data;
  final bool isUser;
  final String username;

  UserInfo({@required this.username, this.isUser = false});

  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  bool edit = false;
  final descriptionController = TextEditingController();
  UserData data;

  Future<void> updateDescription(String description) async {
    // This example uses the Google Books API to search for books about http.
    // https://developers.google.com/books/docs/overview
    var url =
        '$ip/update-description?Username=${widget.username}&Description=$description';

    // Await the http get response, then decode the json-formatted response.
    var response = await http.put(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: convert.jsonEncode(
            {'Username': widget.username, 'Description': description}));
    if (response.statusCode == 200) {
      // var jsonResponse = convert.jsonDecode(response.body);
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() {
    data = UserData();
    descriptionController.text = data.description;
  }

  @override
  void dispose() {
    super.dispose();
    descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   elevation: 0,
        //   backgroundColor: Colors.black,
        //   actions: [

        //   ],
        // ),
        body: ListView.builder(
      itemCount: data.friends.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return buildListWidget(context);
        }
        return UserItem(username: data.friends[index - 1]);
      },
    ));
  }

  Column buildListWidget(BuildContext context) {
    return Column(
      children: [
        ProfileHeader(
          name: data.name,
          username: data.username,
          edit: widget.isUser
              ? IconButton(
                  icon: Icon(edit ? Icons.check : Icons.edit),
                  onPressed: () {
                    if (edit) {
                      updateDescription(descriptionController.text);
                    }
                    setState(() {
                      edit = !edit;
                    });
                  },
                )
              : Container(),
        ),
        SizedBox(
          height: 40,
          child: edit
              ? TextFormField(
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  controller: descriptionController,
                  decoration: InputDecoration(
                    // labelText: 'Name',
                    hintText: 'Add a new description!',
                    contentPadding:
                        // TODO: fix alignment
                        EdgeInsets.only(left: 10, top: 12, bottom: 5),
                  ),
                )
              : Text(
                  descriptionController.text,
                  style: TextStyle(fontSize: 16),
                ),
        ),
        InkWell(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.all(8.0),
            margin: const EdgeInsets.symmetric(horizontal: 64.0),
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: LinearGradient(
                    colors: [Colors.yellow, Colors.orange, Colors.red])),
            child: Row(
              children: [
                Spacer(),
                Icon(
                  Icons.map,
                  size: 36,
                ),
                SizedBox(width: 8.0),
                Text(
                  'View posts',
                  style: TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.w700),
                ),
                Spacer(),
              ],
            ),
          ),
        ),
        Row(
          children: [
            SizedBox(
              width: 16,
            ),
            Text(
              'Friends',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w300),
            ),
            Spacer(),
            IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => UsersExplore(),
                  ));
                },
                icon: Icon(Icons.add)),
          ],
        ),
      ],
    );
  }
}

class ProfileHeader extends StatelessWidget {
  final String name;
  final String username;
  final Widget edit;
  const ProfileHeader({Key key, this.name, this.username, this.edit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipPath(
          clipper: UpperRoundSemiCircle(),
          child: Container(
            height: 350, // TODO: replace with expanded
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.black,
                image: DecorationImage(
                    image: AssetImage('assets/mosaic.jpg'), fit: BoxFit.cover)),
          ),
        ),
        Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Spacer(),
                  edit,
                ],
              ),
              Text(this.name,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold)),
              SizedBox(
                height: 8,
              ),
              Text('@${this.username}',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w400)),
              SizedBox(
                height: 16,
              ),
              CircleAvatar(
                backgroundColor: Colors.blue,
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 64,
                ),
                // child: Image(
                //   image: AssetImage('assets/male_profile1.png'),
                // ),
                radius: 60,
              )
            ],
          ),
        ),
      ],
    );
  }
}

class UpperRoundSemiCircle extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    // TODO: magic numbers
    path.lineTo(0, size.height - 100);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 100);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
