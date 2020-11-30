import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tangram/tile_video.dart';

class TileView extends StatefulWidget {
  TileView();

  @override
  _TileViewState createState() => _TileViewState();
}

enum Direction { CENTER, LEFT, RIGHT, UP, DOWN }

class _TileViewState extends State<TileView> with TickerProviderStateMixin {
  Widget _current = Container(
    width: double.infinity,
    height: double.infinity,
    color: Colors.red[100],
  );

  int x = 0;
  int y = 0;

  List<Widget> _transitionWidgets;

  AnimationController _controller;
  Animation<Offset> _offsetAnimation;

  List<List<Color>> grid = [
    [Colors.red[100], Colors.red[200], Colors.red],
    [Colors.green[100], Colors.green[200], Colors.green],
    [Colors.blue[100], Colors.blue[200], Colors.blue],
  ];

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
                  // Down swipe
                  transition(context, Direction.UP);
                } else {
                  // Up swipe
                  transition(context, Direction.DOWN);
                }
              },
              child: Stack(
                children: _transitionWidgets ?? [_current],
              ),
            )
            // child: TileVideo(x: widget.x, y: widget.y)),
            ));
  }

  void transition(BuildContext context, Direction direction) {
    if (_controller != null &&
        _controller.status != AnimationStatus.completed) {
      return;
    }
    var changes = changeFromDirection(direction);

    double dx = changes[0].toDouble();
    double dy = changes[1].toDouble();

    Widget next = Container(
      width: double.infinity,
      height: double.infinity,
      color: grid[x + changes[0]][y + changes[1]],
    );

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )
      ..forward()
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            _current = next;
            _transitionWidgets = null;
            x += changes[0];
            y += changes[1];
            print("$x $y");
          });
        }
      });

    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(-1 * dx, -1 * dy),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));
    Animation<Offset> _otherOffsetAnimation = Tween<Offset>(
      begin: Offset(dx, dy),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));

    setState(() {
      _transitionWidgets = [
        SlideTransition(position: _offsetAnimation, child: _current),
        SlideTransition(position: _otherOffsetAnimation, child: next),
      ];
    });
  }

  List<int> changeFromDirection(Direction direction) {
    int dx = 0;
    int dy = 0;

    switch (direction) {
      case Direction.CENTER:
        break;
      case Direction.LEFT:
        dx = -1;
        break;
      case Direction.RIGHT:
        dx = 1;
        break;
      case Direction.UP:
        dy = -1;
        break;
      case Direction.DOWN:
        dy = 1;
        break;
    }

    return [dx, dy];
  }

  @override
  void initState() {
    super.initState();
  }
}
