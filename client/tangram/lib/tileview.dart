import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tangram/tile_video.dart';

class TileView extends StatefulWidget {
  final int x;
  final int y;

  TileView({this.x = 0, this.y = 0});

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
            if (details.delta.dx > 0 && widget.x > 0) {
              transition(context, Direction.LEFT);
              // Right swipe
            } else {
              // Left swipe
              transition(context, Direction.RIGHT);
            }
          },
          onVerticalDragUpdate: (details) {
            if (details.delta.dy > 0 && widget.y > 0) {
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
                type: PageTransitionType.leftToRight,
                child: TileView(x: widget.x - 1, y: widget.y)));
        break;
      case Direction.RIGHT:
        Navigator.pushReplacement(
            context,
            PageTransition(
                type: PageTransitionType.rightToLeft,
                child: TileView(x: widget.x + 1, y: widget.y)));
        break;
      case Direction.UP:
        Navigator.pushReplacement(
            context,
            PageTransition(
                type: PageTransitionType.topToBottom,
                child: TileView(x: widget.x, y: widget.y - 1)));
        break;
      case Direction.DOWN:
        Navigator.pushReplacement(
            context,
            PageTransition(
                type: PageTransitionType.bottomToTop,
                child: TileView(x: widget.x, y: widget.y + 1)));
        break;
    }
  }

  @override
  void initState() {
    super.initState();
  }
}
