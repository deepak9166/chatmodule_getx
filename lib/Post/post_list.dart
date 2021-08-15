import 'package:client_module_getx/Post/post_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comment_tree/data/comment.dart';
import 'package:comment_tree/widgets/comment_tree_widget.dart';
import 'package:comment_tree/widgets/tree_theme_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostList extends StatefulWidget {
  @override
  _PostListState createState() => _PostListState();
}

class _PostListState extends State<PostList> {

  var height, width;

  @override
  Widget build(BuildContext context) {

    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        title: Text("Post Lists",style: TextStyle(color: Colors.black),),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          Get.to(PostForm());
        },
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('post').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView(
            children: snapshot.data.docs.map((document) {
              return Container(
                height: 100,
                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey[200]
                ),
                child: Column(
                  children: [
                    Center(child: Text(document['title'])),
                    SizedBox(height: 10,),
                    Center(child: Text(document['description'])),
                    SizedBox(height: 10,),
                    GestureDetector(
                      onTap: (){
                        _showCommentBottomSheet(context);
                      },
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Icon(Icons.message)
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  _showCommentBottomSheet(BuildContext context) {
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
