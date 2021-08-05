import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

import '../constants.dart';

class ChatCard extends StatefulWidget {
  ChatCard(
      {Key key,
      @required this.press,
      this.isActive,
      this.lastMessage,
      this.lastSeen,
      this.name,
      this.userImage,
      this.unReadCount = 0,
      this.deleteCallBack});

  final String name;
  final String lastMessage;
  final String lastSeen;
  final bool isActive;
  final String userImage;
  final int unReadCount;
  final VoidCallback press;
  final Function deleteCallBack;

  @override
  _ChatCardState createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    //print(chat.time);
    return InkWell(
      onTap: widget.press,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(12)),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 7,
                offset: Offset(15, 20),
              ),
            ]),
        margin: const EdgeInsets.symmetric(
            horizontal: kDefaultPadding, vertical: kDefaultPadding * 0.75),
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: kDefaultPadding, vertical: kDefaultPadding * 0.75),
          child: Row(
            children: [
              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        // BoxShape.circle or BoxShape.retangle
                        color: Colors.white,
                        // borderRadius: BorderRadius.all(Radius.circular(12)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 7,
                            offset: Offset(10, 2),
                          ),
                        ]),
                    child: CircleAvatar(
                      radius: 24,
                      backgroundImage: widget.userImage == null
                          ? AssetImage("assets/images/user.png")
                          : NetworkImage(widget.userImage),
                    ),
                  ),
                  // if (isActive)
                  widget.isActive
                      ? Positioned(
                          right: 0,
                          bottom: 35,
                          child: Container(
                            height: 16,
                            width: 16,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  width: 3),
                            ),
                          ),
                        )
                      : SizedBox()
                ],
              ),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 130,
                        child: Text(
                          widget.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ),
                      SizedBox(height: 8),
                      Opacity(
                        opacity: 0.64,
                        child: Text(
                          widget.lastMessage,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  widget.lastSeen.isEmpty
                      ? SizedBox()
                      : Opacity(
                          opacity: 0.64,
                          child: Text(
                            Jiffy(DateTime.parse(widget.lastSeen)).jm,
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                  SizedBox(height: 8),

                  widget.unReadCount > 0
                      ? Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.deepPurpleAccent,
                          ),
                          child: Center(
                            child: Text(
                              "${widget.unReadCount}",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            if (isSelected) {
                              isSelected = false;
                            } else {
                              isSelected = true;
                            }
                            setState(() {});
                            print(isSelected);
                          },
                          child: AnimatedContainer(
                            // height: 30,
                            padding: EdgeInsets.only(
                                right: isSelected ? 10 : 5.0, left: 10),
                            // decoration: BoxDecoration(
                            //     color: Color(0xffCAF3BB),
                            //     borderRadius: BorderRadius.only(
                            //         topLeft: Radius.circular(30),
                            //         bottomLeft: Radius.circular(30))),
                            child: Center(
                              child: Row(
                                children: [
                                  isSelected
                                      ? InkWell(
                                          onTap: widget.deleteCallBack,
                                          child: Icon(
                                            Icons.clear,
                                            color: Colors.red,
                                            size: 20,
                                          ),
                                        )
                                      : SizedBox(),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Icon(
                                    isSelected
                                        ? Icons.more_horiz
                                        : Icons.more_vert_rounded,
                                    color: Colors.black,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                            duration: Duration(milliseconds: 800),
                            curve: Curves.easeInOut,
                          ),
                        ),

                  //   Icon(Icons.more_vert_rounded,color: Colors.black,),
                  // Icon(Icons.more_horiz),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
