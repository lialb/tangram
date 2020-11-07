import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class TileView extends StatefulWidget {
  @override
  _TileViewState createState() => _TileViewState();
}

class _TileViewState extends State<TileView> {
  List<List<Color>> _colors = [
    [Colors.red, Colors.red[300], Colors.red[200]],
    [Colors.blue, Colors.blue[300], Colors.blue[200]],
    [Colors.green, Colors.green[300], Colors.green[200]]
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Tile(),
    ));
  }
}

class Tile extends StatefulWidget {
  const Tile({
    Key key,
  }) : super(key: key);

  @override
  _TileState createState() => _TileState();
}

class _TileState extends State<Tile> {
  YoutubePlayerController _controller;

  bool _liked = false;

  @override
  void initState() {
    super.initState();

    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(
          "https://www.youtube.com/watch?v=xqiPZBZgW9c&ab_channel=Apple"),
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _controller.play(),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            child: YoutubePlayer(
                controller: _controller,
                showVideoProgressIndicator: false,
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
    );
  }
}
