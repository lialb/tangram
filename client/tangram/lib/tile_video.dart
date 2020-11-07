import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tangram/users_explore.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class TileVideo extends StatefulWidget {
  const TileVideo({
    Key key,
  }) : super(key: key);

  @override
  _TileVideoState createState() => _TileVideoState();
}

class _TileVideoState extends State<TileVideo> {
  YoutubePlayerController _controller;

  bool _liked = false;

  @override
  void initState() {
    super.initState();

    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(
          "https://www.youtube.com/watch?v=xqiPZBZgW9c&ab_channel=Apple"),
      flags: YoutubePlayerFlags(
          autoPlay: true, mute: false, disableDragSeek: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: GestureDetector(
        onTap: () => _controller.play(),
        child: Stack(
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
                          Text('LOL look at this funny cat',
                              style: TextStyle(color: Colors.white)),
                          Text('@teddy', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                    Text('${145 + (_liked ? 1 : 0)}',
                        style: TextStyle(color: Colors.white)),
                    Padding(
                      padding: const EdgeInsets.only(right: 32.0),
                      child: IconButton(
                          onPressed: () => setState(() => _liked = !_liked),
                          icon: Icon(
                              _liked ? Icons.favorite : Icons.favorite_border,
                              color: _liked ? Colors.red : Colors.white)),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
