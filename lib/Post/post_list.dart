import 'package:client_module_getx/Post/comment_screen.dart';
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
                height: 130,
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
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>CommentScreen(id: document.id,name:document['title'] ,postTitle: document['description'],)));
                        // _showCommentBottomSheet(context);
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

  //the model sheet



}
