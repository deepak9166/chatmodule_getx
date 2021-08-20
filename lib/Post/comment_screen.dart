import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comment_tree/data/comment.dart';
import 'package:comment_tree/widgets/comment_tree_widget.dart';
import 'package:comment_tree/widgets/tree_theme_data.dart';
import 'package:flutter/material.dart';

class CommentScreen extends StatefulWidget {

  CommentScreen({this.name, this.postTitle, this.id});

  final String name;
  final String postTitle;
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
      body: Container(
        height: height,
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
             stream: FirebaseFirestore.instance
                 .collection('post')
                 .doc(widget.id)
                 .collection("comments")
                 // .orderBy("messgeLength", descending: false)
             // .where('chatWith', isEqualTo: data['userId'])
                 .snapshots(),
              builder: (context, snapshot) {
               if(snapshot.hasData){
                 print("total comment > ${snapshot.data.docs.length}");
                 // print("total comment > ${snapshot.data.docs[index].id}");
                 List<Comment> temp = [];
                 for(var item in snapshot.data.docs){
                   temp.add(Comment(
                    avatar: 'null',
                    userName: 'null',
                    content: item['message']));
                 }
                 return  Flexible(
                   // height: height * 0.75,
                   child: CommentTreeWidget<Comment, Comment>(
                     Comment(
                         avatar: 'null',
                         userName: widget.name,
                         content: widget.postTitle),
                     temp,

                     treeThemeData:
                     TreeThemeData(lineColor: Colors.green[500], lineWidth: 3),
                     avatarRoot: (context, data) => PreferredSize(
                       child: CircleAvatar(
                         radius: 18,
                         backgroundColor: Colors.grey,
                         backgroundImage: NetworkImage('https://icon-library.com/images/user-icon-jpg/user-icon-jpg-22.jpg'),
                       ),
                       preferredSize: Size.fromRadius(18),
                     ),
                     avatarChild: (context, data) => PreferredSize(
                       child: CircleAvatar(
                           radius: 12,
                           backgroundColor: Colors.grey,
                           backgroundImage: NetworkImage('https://icon-library.com/images/user-icon-jpg/user-icon-jpg-22.jpg')
                       ),
                       preferredSize: Size.fromRadius(12),
                     ),
                     contentChild: (context, data) {
                       return Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Container(
                             padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                             decoration: BoxDecoration(
                                 color: Colors.grey[100],
                                 borderRadius: BorderRadius.circular(12)),
                             child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Text(
                                   '${data.userName}',
                                   style: Theme.of(context).textTheme.caption?.copyWith(
                                       fontWeight: FontWeight.w600, color: Colors.black),
                                 ),
                                 SizedBox(
                                   height: 4,
                                 ),
                                 Text(
                                   '${data.content}',
                                   style: Theme.of(context).textTheme.caption?.copyWith(
                                       fontWeight: FontWeight.w300, color: Colors.black),
                                 ),
                               ],
                             ),
                           ),
                           DefaultTextStyle(
                             style: Theme.of(context).textTheme.caption.copyWith(
                                 color: Colors.grey[700], fontWeight: FontWeight.bold),
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
                                   GestureDetector(
                                     onTap:(){
                                       showReplyBottomSheet(context);
                                     },
                                     child: Text('Reply')),
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
                             padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                             decoration: BoxDecoration(
                                 color: Colors.grey[100],
                                 borderRadius: BorderRadius.circular(12)),
                             child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Text(
                                   '${data.userName}',
                                   style: Theme.of(context).textTheme.caption.copyWith(
                                       fontWeight: FontWeight.w600, color: Colors.black),
                                 ),
                                 SizedBox(
                                   height: 4,
                                 ),
                                 Text(
                                   '${data.content}',
                                   style: Theme.of(context).textTheme.caption.copyWith(
                                       fontWeight: FontWeight.w300, color: Colors.black),
                                 ),
                               ],
                             ),
                           ),

                         ],
                       );
                     },
                   ),
                 );
               }
               if(snapshot.hasError){
                 return Text("Something wrong");
               }
               return SizedBox();
               },),
            SizedBox(height: height*0.03,),
            Container(
              // height: height * 0.1,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.grey[300]
              ),
              alignment: Alignment.bottomCenter,
              child: Row(
                children: [
                  Container(
                    width: width*0.8,
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
                        border: InputBorder.none
                      ),
                    ),
                  ),
              Container(
                width: width*0.1,
                child: GestureDetector(
                      onTap: () {
                        FirebaseFirestore.instance
                            .collection('post')
                            .doc(widget.id)
                            .collection("comments")
                            .add({
                          'message': messageEditingController.text,
                        });
                        messageEditingController.text = "";
                      },
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: Icon(Icons.send,color: Colors.black,))
                  ),
              ),
                ],
              ),
            ),
          ],
        )
      )
    );
  }

  showReplyBottomSheet(BuildContext context) {
    showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        context: context,
        builder: (BuildContext buildContext) {
          return Container(
            height: height*0.85,
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: CommentTreeWidget<Comment, Comment>(
              Comment(
                  avatar: 'null',
                  userName: 'null',
                  content: 'felangel made felangel/cubit_and_beyond public '),
              [
                Comment(
                    avatar: 'null',
                    userName: 'null',
                    content: 'A Dart template generator which helps teams'),
                Comment(
                    avatar: 'null',
                    userName: 'null',
                    content:
                    'A Dart template generator which helps teams generator which helps teams generator which helps teams'),
                Comment(
                    avatar: 'null',
                    userName: 'null',
                    content: 'A Dart template generator which helps teams'),
                Comment(
                    avatar: 'null',
                    userName: 'null',
                    content:
                    'A Dart template generator which helps teams generator which helps teams '),
              ],
              treeThemeData:
              TreeThemeData(lineColor: Colors.green[500], lineWidth: 3),
              avatarRoot: (context, data) => PreferredSize(
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.grey,
                  backgroundImage: AssetImage('assets/avatar_2.png'),
                ),
                preferredSize: Size.fromRadius(18),
              ),
              avatarChild: (context, data) => PreferredSize(
                child: CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.grey,
                  backgroundImage: AssetImage('assets/avatar_1.png'),
                ),
                preferredSize: Size.fromRadius(12),
              ),
              contentChild: (context, data) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                      decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'dangngocduc',
                            style: Theme.of(context).textTheme.caption?.copyWith(
                                fontWeight: FontWeight.w600, color: Colors.black),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            '${data.content}',
                            style: Theme.of(context).textTheme.caption?.copyWith(
                                fontWeight: FontWeight.w300, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    DefaultTextStyle(
                      style: Theme.of(context).textTheme.caption.copyWith(
                          color: Colors.grey[700], fontWeight: FontWeight.bold),
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
                            Text('Reply'),
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
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                      decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'dangngocduc',
                            style: Theme.of(context).textTheme.caption.copyWith(
                                fontWeight: FontWeight.w600, color: Colors.black),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            '${data.content}',
                            style: Theme.of(context).textTheme.caption.copyWith(
                                fontWeight: FontWeight.w300, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    DefaultTextStyle(
                      style: Theme.of(context).textTheme.caption.copyWith(
                          color: Colors.grey[700], fontWeight: FontWeight.bold),
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
                            Text('Reply'),
                          ],
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
          );
        });
  }
}
