import 'package:flutter/material.dart';

class LoadingContainer extends StatelessWidget {
  final double width;
  final double height;
  LoadingContainer({this.width = 40, this.height = 40});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: this.width,
          height: this.height,
          child: CircularProgressIndicator(),
        )
      ],
    );
  }
}
