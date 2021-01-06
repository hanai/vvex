import 'package:flutter/material.dart';
import 'package:vvex/widgets/v_network_image.dart';

class AvatarImage extends StatelessWidget {
  final double size;
  final String imageUrl;

  AvatarImage({required this.size, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: VNetworkImage(
        imageUrl: imageUrl,
        width: size,
        height: size,
        placeholder: (context, url) => CircularProgressIndicator(),
        fit: BoxFit.contain,
      ),
    );
  }
}
