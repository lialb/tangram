import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tangram/tile_video.dart';

class TileView extends StatefulWidget {
  @override
  _TileViewState createState() => _TileViewState();
}

enum Direction { CENTER, LEFT, RIGHT, UP, DOWN }

class _TileViewState extends State<TileView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: GestureDetector(
          onHorizontalDragUpdate: (details) {
            if (details.delta.dx > 0) {
              transition(context, Direction.LEFT);
              // Right swipe
            } else {
              // Left swipe
              transition(context, Direction.RIGHT);
            }
          },
          onVerticalDragUpdate: (details) {
            if (details.delta.dy > 0) {
              // Right swipe
              transition(context, Direction.UP);
            } else {
              // Left swipe
              transition(context, Direction.DOWN);
            }
          },
          child: TileVideo()),
    ));
  }

  void transition(BuildContext context, Direction direction) {
    switch (direction) {
      case Direction.CENTER:
        break;
      case Direction.LEFT:
        Navigator.pushReplacement(
            context,
            PageTransition(
                type: PageTransitionType.leftToRight, child: TileView()));
        break;
      case Direction.RIGHT:
        Navigator.pushReplacement(
            context,
            PageTransition(
                type: PageTransitionType.rightToLeft, child: TileView()));
        break;
      case Direction.UP:
        Navigator.pushReplacement(
            context,
            PageTransition(
                type: PageTransitionType.topToBottom, child: TileView()));
        break;
      case Direction.DOWN:
        Navigator.pushReplacement(
            context,
            PageTransition(
                type: PageTransitionType.bottomToTop, child: TileView()));
        break;
    }
  }

  @override
  void initState() {
    super.initState();
  }
}
