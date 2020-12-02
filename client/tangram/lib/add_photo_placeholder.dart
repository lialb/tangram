import 'package:flutter/material.dart';

class AddPhotoPlaceholder extends StatelessWidget {
  final Function onClick;
  const AddPhotoPlaceholder({Key key, this.onClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        decoration: BoxDecoration(
            // color: Colors.red,
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(width: 2, color: Colors.grey)),
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.all(32.0),
        child: Center(
          child: Icon(
            Icons.add,
            size: 128,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
