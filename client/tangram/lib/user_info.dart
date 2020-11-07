import 'package:flutter/material.dart';
import 'package:tangram/users_explore.dart';

class UserInfo extends StatelessWidget {
  UserData data;
  UserInfo({this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.black,
        ),
        body: Column(
          children: [
            ProfileHeader(
              name: data.name,
              username: data.username,
            ),
            SizedBox(height: 100),
            SizedBox(
              height: 400,
              child: Text(
                data.description,
                style: TextStyle(fontSize: 16),
              ),
            )
          ],
        ));
  }
}

class ProfileHeader extends StatelessWidget {
  final String name;
  final String username;
  const ProfileHeader({Key key, this.name, this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipPath(
          clipper: UpperRoundSemiCircle(),
          child: Container(
            height: 200, // TODO: replace with expanded
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.black),
          ),
        ),
        Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
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
