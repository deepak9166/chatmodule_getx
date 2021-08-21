import 'package:client_module_getx/Post/post_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostForm extends StatefulWidget {
  @override
  _PostFormState createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("user name"),
            SizedBox(
              height: 5,
            ),
            TextFormField(
              controller: title,
            ),
            SizedBox(
              height: 10,
            ),
            Text("Enter post"),
            SizedBox(
              height: 5,
            ),
            TextFormField(
              controller: description,
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                FirebaseFirestore.instance.collection('post').add({
                  'title': title.text,
                  'description': description.text,
                });

                Get.back();
              },
              child: Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}
