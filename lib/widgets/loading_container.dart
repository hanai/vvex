import 'package:flutter/material.dart';

class LoadingContainer extends StatelessWidget {
  final double width;
  final double height;
  final EdgeInsetsGeometry padding;

  LoadingContainer(
      {this.width = 40, this.height = 40, EdgeInsetsGeometry? padding})
      : this.padding = padding ?? EdgeInsets.all(20);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: this.padding,
          child: Container(
            width: this.width,
            height: this.height,
            child: CircularProgressIndicator(),
          ),
        )
      ],
    );
  }
}
