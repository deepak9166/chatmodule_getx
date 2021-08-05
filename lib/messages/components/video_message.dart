import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../unitl.dart';
import 'imagesViewer.dart';

class ImageVideoMessage extends StatelessWidget {
  ImageVideoMessage(
      {this.link = "",
      this.isVideo = false,
      this.loading = false,
      this.localFile});
  final String link;
  final isVideo;
  final bool loading;
  final localFile;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.45,
      child: AspectRatio(
        aspectRatio: 1.6,
        child: Stack(
          alignment: Alignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: link == "loading"
                  ? messageLoader()
                  : link.isNotEmpty
                      ? InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ImageViewer(
                                    link: "$link",
                                  ),
                                ));
                          },
                          child: Image.network(link))
                      : SizedBox(),
            ),
            isVideo
                ? Container(
                    height: 25,
                    width: 25,
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.play_arrow,
                      size: 16,
                      color: Colors.white,
                    ))
                : SizedBox()
          ],
        ),
      ),
    );
  }
}

class FilePdfMessage extends StatelessWidget {
  FilePdfMessage(
      {this.link = "",
      this.isVideo = false,
      this.loading = false,
      this.localFile});
  final String link;
  final isVideo;
  final bool loading;
  final localFile;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.35,
      child: AspectRatio(
        aspectRatio: 1.6,
        child: Stack(
          alignment: Alignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: link == "loading"
                  ? messageLoader()
                  : link.isNotEmpty
                      ? InkWell(
                          onTap: () {
                            launchURL(link);
                          },
                          child: Container(
                            height: 60,
                            width: 160,
                            decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.file_copy,
                                  color: Colors.blue.withOpacity(0.6),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "File",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                        )
                      : SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}
