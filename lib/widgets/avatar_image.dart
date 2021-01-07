import 'package:flutter/material.dart';
import 'package:vvex/widgets/v_network_image.dart';

class AvatarImage extends StatefulWidget {
  final double size;
  final String imageUrl;

  AvatarImage({required this.size, required this.imageUrl});

  @override
  _AvatarImageState createState() => _AvatarImageState();
}

class _AvatarImageState extends State<AvatarImage> {
  late String _imageUrl;

  @override
  void initState() {
    super.initState();

    _imageUrl = widget.imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: VNetworkImage(
        key: ValueKey<String>(_imageUrl),
        imageUrl: _imageUrl,
        width: widget.size,
        height: widget.size,
        errorWidget: (context, url, err) {
          return Icon(Icons.refresh);
        },
        placeholder: (context, url) => Padding(
          padding: EdgeInsets.all(4),
          child: CircularProgressIndicator(),
        ),
        fit: BoxFit.contain,
      ),
    );
  }
}
