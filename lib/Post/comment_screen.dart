import 'package:client_module_getx/controllers/commentController.dart';
import 'package:client_module_getx/messages/components/chat_input_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comment_tree/widgets/comment_tree_widget.dart';
import 'package:comment_tree/widgets/tree_theme_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommentScreen extends StatefulWidget {
  CommentScreen({this.name, this.postcontent, this.id});

  final String name;
  final String postcontent;
  final String id;
  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  TextEditingController messageEditingController = TextEditingController();
  var height, width;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("Comments"),
      ),
      resizeToAvoidBottomInset: true,
      extendBody: true,
      body: chatBody(
          fun: getPost(),
          id: widget.id,
          img:
              "https://icon-library.com/images/user-icon-jpg/user-icon-jpg-22.jpg",
          isReplay: false,
          name: widget.name,
          post: widget.postcontent),
    );
  }

  Stream<QuerySnapshot> getPost() {
    return FirebaseFirestore.instance
        .collection('post')
        .doc(widget.id)
        .collection("comments")
        .orderBy("createAt")
        .snapshots();
  }

  Stream<QuerySnapshot> getReplayPost(String selectedPostId) {
    return FirebaseFirestore.instance
        .collection('post')
        .doc(widget.id)
        .collection("comments")
        .doc(selectedPostId)
        .collection("subcomment")
        .snapshots();
  }

  Widget inputText(bool isReplay) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        height: 55,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15), color: Colors.grey[300]),
        alignment: Alignment.bottomCenter,
        child: Row(
          children: [
            Expanded(
              flex: 8,
              child: Container(
                // width: width * 0.8,
                padding: EdgeInsets.only(left: 10),
                child: TextFormField(
                  controller: messageEditingController,
                  minLines: 1,
                  decoration: InputDecoration(
                      hintText: "write a message...",
                      hintStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      border: InputBorder.none),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                // width: width * 0.1,
                padding: EdgeInsets.only(right: 6),
                child: GestureDetector(
                    onTap: () {
                      final commentController = Get.put(CommentController());
                      // sender name and sender id use accoridng current login user
                      FocusScope.of(context).unfocus();

                      if (isReplay) {
                        print(
                            "total comment send @@@@@@@@@@@@@@@@@@@@ ${commentController.totalRepay.value}");

                        print(
                            "selected comment id >>>>>>>>>>>>>>>>>>>>>> ${commentController.replaycommentId.value}");
                        // replay of comment
                        FirebaseFirestore.instance
                            .collection('post')
                            .doc(widget.id)
                            .collection("comments")
                            .doc(commentController.replaycommentId.value)
                            .collection("subcomment")
                            .add({
                          'message': messageEditingController.text,
                          'createAt': DateTime.now().millisecondsSinceEpoch,
                          "senderName": "deepak",
                          "senderId": "12235"
                        });

//update count of post comment
                        FirebaseFirestore.instance
                            .collection('post')
                            .doc(widget.id)
                            .collection("comments")
                            .doc(commentController.replaycommentId.value)
                            .update({
                          'totalComment':
                              commentController.totalRepay.value.toString(),
                        });
                      } else {
                        FirebaseFirestore.instance
                            .collection('post')
                            .doc(widget.id)
                            .collection("comments")
                            .add({
                          'message': messageEditingController.text,
                          'createAt': DateTime.now().millisecondsSinceEpoch,
                          "senderName": "deepak",
                          "senderId": "12235",
                          "totalComment": "0",
                        });
                      }

                      messageEditingController.text = "";
                    },
                    child: Align(
                        alignment: Alignment.centerRight,
                        child: Icon(
                          Icons.send,
                          color: Colors.black,
                        ))),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget chatBody({
    Stream fun,
    isReplay,
    String name,
    String img,
    String id,
    String post,
  }) {
    return Column(
      children: [
        Expanded(
          child: ChatBodyView(
            fun: fun,
            id: id,
            img: img,
            isReplay: isReplay,
            name: name,
            post: post,
            onTabReplay: (totalCmd, cmdId) {
              final commentController = Get.put(CommentController());

              commentController.updateCommentId(cmdId).then((value) {
                showReplyBottomSheet(context, cmdId, name, post);
              });
            },
            onreplayLoad: (count) {
              print("loaded listtt >>>>>>>> $count");
              final commentController = Get.put(CommentController());

              commentController.updateTotalReplay(count);
            },
          ),
          //child: chatCenterBody(fun, isReplay, name,  img,  id, post),
        ),
        inputText(isReplay)
      ],
    );
  }

  showReplyBottomSheet(
      BuildContext context, String selectedId, String name, String comment) {
    showModalBottomSheet(
        isScrollControlled: false,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        context: context,
        builder: (BuildContext buildContext) {
          return Container(
            height: height * 0.85,
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: chatBody(
              fun: getReplayPost(selectedId),
              id: selectedId,
              img:
                  "https://icon-library.com/images/user-icon-jpg/user-icon-jpg-22.jpg",
              isReplay: true,
              name: name,
              post: comment,
            ),
          );
        });
  }
}

class Comment {
  static const TAG = 'Comment';

  String avatar;
  String userName;
  String content;
  String id;
  String totalComment;

  Comment({
    @required this.avatar,
    @required this.userName,
    @required this.content,
    @required this.id,
    this.totalComment,
  });
}

class ChatBodyView extends StatelessWidget {
  const ChatBodyView(
      {Key key,
      @required this.fun,
      @required this.id,
      @required this.img,
      @required this.isReplay,
      @required this.name,
      @required this.post,
      this.onreplayLoad,
      this.onTabReplay})
      : super(key: key);

  final Stream fun;
  final bool isReplay;
  final String name;
  final String img;
  final String id;
  final String post;
  final Function(String totalPost, String cmtId) onTabReplay;
  final Function(String totalReplay) onreplayLoad;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: fun,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Comment> temp = [];
          for (var item in snapshot.data.docs) {
            temp.add(Comment(
                totalComment:
                    !isReplay ? item['totalComment'].toString() ?? "" : "",
                id: item.id,
                avatar:
                    'https://icon-library.com/images/user-icon-jpg/user-icon-jpg-22.jpg',
                userName: item['senderName'] ?? "null",
                content: item['message']));
          }

          if (isReplay) {
            onreplayLoad((temp.length + 1).toString());
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: CommentTreeWidget<Comment, Comment>(
                Comment(
                    totalComment: "",
                    id: id,
                    avatar:
                        'https://icon-library.com/images/user-icon-jpg/user-icon-jpg-22.jpg',
                    userName: name,
                    content: post),
                temp,
                treeThemeData:
                    TreeThemeData(lineColor: Colors.green[500], lineWidth: 3),
                avatarRoot: (context, data) => PreferredSize(
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.grey,
                    backgroundImage: NetworkImage('${data.avatar}'),
                  ),
                  preferredSize: Size.fromRadius(18),
                ),
                avatarChild: (context, data) => PreferredSize(
                  child: CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.grey,
                      backgroundImage: NetworkImage('${data.avatar}')),
                  preferredSize: Size.fromRadius(12),
                ),
                contentChild: (context, data) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                        decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${data.userName}',
                              style: Theme.of(context)
                                  .textTheme
                                  .caption
                                  ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              '${data.content}',
                              style: Theme.of(context)
                                  .textTheme
                                  .caption
                                  ?.copyWith(
                                      fontWeight: FontWeight.w300,
                                      color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      DefaultTextStyle(
                        style: Theme.of(context).textTheme.caption.copyWith(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.bold),
                        child: Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 8,
                              ),
                              Text('Like'),
                              SizedBox(
                                width: 24,
                              ),
                              isReplay
                                  ? SizedBox()
                                  : GestureDetector(
                                      onTap: () => onTabReplay(
                                          temp.length.toString(), data.id),
                                      child: Text(
                                          '${data.totalComment == "0" ? "" : data.totalComment} Reply')),
                            ],
                          ),
                        ),
                      )
                    ],
                  );
                },
                contentRoot: (context, data) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                        decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${data.userName}',
                              style: Theme.of(context)
                                  .textTheme
                                  .caption
                                  .copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              '${data.content}',
                              style: Theme.of(context)
                                  .textTheme
                                  .caption
                                  .copyWith(
                                      fontWeight: FontWeight.w300,
                                      color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        }
        if (snapshot.hasError) {
          return Text("Something wrong");
        }
        return Center(
          child: SizedBox(
            child: Text("Loading..."),
          ),
        );
      },
    );
  }
}
