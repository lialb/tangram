import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tangram/users_explore.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'constants.dart';

class PostData {
  final String title;
  final String username;
  final int likes;
  final String video;
  final String postID;

  PostData(
      {this.title = 'LOL look at this video!!',
      this.username = 'theodorespeaks',
      this.likes = 13,
      this.postID = '0',
      this.video =
          'https://www.youtube.com/watch?v=xqiPZBZgW9c&ab_channel=Apple'});

  PostData.fromJson(Map<String, dynamic> json)
      : title = json['data'][0][0]['data']['text'],
        likes = json['data'][0][0]['data']['likes'],
        username = json['data'][0][0]['data']['userName'],
        video = json['data'][0][0]['data']['link'],
        postID = json['data'][0][0]['data']['postID'];
}

class TileVideo extends StatefulWidget {
  final int x;
  final int y;
  const TileVideo({Key key, this.x = 0, this.y = 0}) : super(key: key);

  @override
  _TileVideoState createState() => _TileVideoState();
}

class _TileVideoState extends State<TileVideo> {
  YoutubePlayerController _controller;
  PostData data;

  bool _liked = false;
  final _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final urlController = TextEditingController();
  bool isForm = false;

  @override
  void initState() {
    super.initState();
    // TODO: uncomment
    // getData();
  }

  Future<void> getData() async {
    var url = '$ip/get-post-by-coordinates/${widget.x}/${widget.y}';
    print(url);

    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      // if (jsonResponse['data'] == []) {
      // print(jsonResponse['data']);
      // print(jsonResponse['data'][0][0]['title']);
      try {
        data = PostData.fromJson(jsonResponse);

        _controller = YoutubePlayerController(
          initialVideoId: YoutubePlayer.convertUrlToId(data.video),
          flags: YoutubePlayerFlags(
              autoPlay: true, mute: false, disableDragSeek: true),
        );
        // }
      } on RangeError {
        isForm = true;
      }
      setState(() {});
      // var itemCount = jsonResponse['totalItems'];
      // print('Number of books about http: $itemCount.');
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: InkWell(
        onTap: () => _controller.play(),
        child: isForm
            ? buildForm()
            : data == null
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: YoutubePlayer(
                            controller: _controller,
                            aspectRatio: MediaQuery.of(context).size.width /
                                MediaQuery.of(context).size.height),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        child: Container(
                          height: 160,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [Colors.transparent, Colors.black],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter),
                          ),
                        ),
                      ),
                      Positioned(
                          right: 16,
                          top: 64,
                          child: IconButton(
                            icon: Icon(Icons.people, color: Colors.white),
                            onPressed: () => Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.fade,
                                    child: UsersExplore())),
                          )),
                      Positioned(
                        bottom: 16,
                        left: 16,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(data.title,
                                        style: TextStyle(color: Colors.white)),
                                    Text('@${data.username}',
                                        style: TextStyle(color: Colors.white)),
                                  ],
                                ),
                              ),
                              Text(
                                  '${(data.likes == null ? 0 : data.likes) + (_liked ? 1 : 0)}',
                                  style: TextStyle(color: Colors.white)),
                              Padding(
                                padding: const EdgeInsets.only(right: 32.0),
                                child: IconButton(
                                    onPressed: () =>
                                        setState(() => _liked = !_liked),
                                    icon: Icon(
                                        _liked
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: _liked
                                            ? Colors.red
                                            : Colors.white)),
                              )
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                          left: 16,
                          top: 64,
                          child: IconButton(
                              icon: Icon(Icons.delete, color: Colors.white),
                              onPressed: () {
                                print(data.postID);
                                deletePost(data.postID);
                                setState(() {
                                  isForm = true;
                                });
                              })),
                    ],
                  ),
      ),
    );
  }

  Future<void> deletePost(String username) async {
    var url = Uri.parse('$ip/delete-post/$username');
    var request = http.Request("DELETE", url);
    request.send();
  }

  SafeArea buildForm() {
    return SafeArea(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  hintText: 'An interesting title',
                  contentPadding:
                      // TODO: fix alignment
                      EdgeInsets.only(left: 10, top: 12, bottom: 5),
                ),
              ),
              TextFormField(
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                controller: urlController,
                decoration: InputDecoration(
                  labelText: 'Youtube link',
                  hintText: 'link to a video',
                  contentPadding:
                      // TODO: fix alignment
                      EdgeInsets.only(left: 10, top: 12, bottom: 5),
                ),
              ),
              SizedBox(height: 32),
              FloatingActionButton.extended(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      var url = '$ip/create-post';
                      http.post(
                        url,
                        headers: <String, String>{
                          'Content-Type': 'application/json; charset=UTF-8',
                        },
                        body: jsonEncode(<String, String>{
                          'text': titleController.text,
                          'videoURL': urlController.text,
                          'XCoordinate': widget.x.toString(),
                          'YCoordinate': widget.y.toString(),
                          'Username': 'Teddy',
                          'Timestamp': '1000'
                        }),
                      );
                      getData();
                      isForm = false;
                      setState(() {});
                    }
                  },
                  label: Row(
                    children: [Icon(Icons.file_upload), Text('Post')],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
