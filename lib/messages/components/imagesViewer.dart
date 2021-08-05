import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewer extends StatelessWidget {
  const ImageViewer({Key key, this.link}) : super(key: key);
  final String link;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Container(
          child: PhotoView(
        imageProvider: NetworkImage("$link"),
      )),
    );
  }
}
