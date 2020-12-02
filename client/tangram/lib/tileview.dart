import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tangram/tile_video.dart';

class TileView extends StatefulWidget {
  final int initialX;
  final int initialY;

  TileView({this.initialX = 0, this.initialY = 0});

  @override
  _TileViewState createState() => _TileViewState();
}

enum Direction { CENTER, LEFT, RIGHT, UP, DOWN }

class _TileViewState extends State<TileView> with TickerProviderStateMixin {
  Widget _current // = TileVideo();
      = Container(
    width: double.infinity,
    height: double.infinity,
    color: Colors.red[100],
  );

  int x = 0;
  int y = 0;

  List<Widget> _transitionWidgets;

  AnimationController _animationController;
  AnimationController _fadeController;

  Animation<Offset> _offsetAnimation;
  Animation<double> _fadeAnimation;

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
    if (_animationController != null &&
        _animationController.status != AnimationStatus.completed) {
      return;
    }
    var changes = changeFromDirection(direction);

    double dx = changes[0].toDouble();
    double dy = changes[1].toDouble();

    Widget placeholder // = TileVideo();
        = Container(
      color: Colors.black,
      width: double.infinity,
      height: double.infinity,
      child: Center(
          child: Image.asset(
        'assets/logo_grey.png',
        width: 256,
      )),
    );

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..forward();

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          // _current = next;
          _transitionWidgets = null;
          x += changes[0];
          y += changes[1];

          _fadeController = AnimationController(
            duration: const Duration(milliseconds: 300),
            vsync: this,
          )..forward();

          _fadeAnimation = Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(CurvedAnimation(
            parent: _fadeController,
            curve: Interval(0.5, 1.0, curve: Curves.easeIn),
          ));

          // _current = TileVideo(x: x, y: y);
          _current = FadeTransition(
              opacity: _fadeAnimation, child: TileVideo(x: x, y: y));

          print("$x $y");
        });
      }
    });

    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(-1 * dx, -1 * dy),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));
    Animation<Offset> _otherOffsetAnimation = Tween<Offset>(
      begin: Offset(dx, dy),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    setState(() {
      _transitionWidgets = [
        SlideTransition(position: _offsetAnimation, child: _current),
        SlideTransition(position: _otherOffsetAnimation, child: placeholder),
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

    x = widget.initialX;
    y = widget.initialY;
  }
}
