import 'dart:ui';
import 'package:client_module_getx/constants.dart';
import 'package:client_module_getx/controllers/authController.dart';
import 'package:client_module_getx/firebase/db_method.dart';
import 'package:client_module_getx/messages/message_screen.dart';
import 'package:client_module_getx/models/Chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'chat_card.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final userController = Get.put(AuthController());

  @override
  void initState() {
    super.initState();
  }

  Stream<QuerySnapshot> getSuggestion(String suggestion) {
    return FirebaseFirestore.instance
        .collection('users')
        .where('name', isGreaterThanOrEqualTo: suggestion)
        .where('name', isLessThan: suggestion + 'z')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
              margin: const EdgeInsets.symmetric(
                  vertical: 20, horizontal: kPagingTouchSlop),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: Offset(2, 5),
                    ),
                  ]),
              child: Center(
                  child: GetBuilder<AuthController>(
                init: AuthController(),
                builder: (controllerUser) {
                  return TextField(
                    decoration: InputDecoration(
                        hintText: "Search ",
                        enabledBorder: InputBorder.none,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.fromLTRB(12, 12, 12, 8),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.black,
                        )),
                    controller: controllerUser.searchController.value,
                    cursorColor: Colors.black,
                    onChanged: (text) {
                      setState(() {
                        userController.updateSearchStatus(true);
                        getSuggestion(text).listen((value) {
                          UserChatList searchUser =
                              UserChatList.fromJson(value);
                          userController.updateSearchUser(searchUser);
                        });
                      });
                    },
                  );
                },
              ))),
          Padding(
            padding: const EdgeInsets.only(left: kDefaultPadding),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Message",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                )),
          ),
          userController.isSearch.value && userController.searchUser != null
              ? Expanded(
                  child: ListView.builder(
                    itemCount: userController.searchUser.dataList.length,
                    itemBuilder: (context, index) {
                      return userController.searchUser.dataList[index].id ==
                              userController.loginUserData.value.id
                          ? SizedBox()
                          : ChatCard(
                              isActive: userController
                                  .searchUser.dataList[index].isActive,
                              lastMessage: '',
                              lastSeen: userController
                                  .searchUser.dataList[index].lastSceen,
                              name: userController
                                  .searchUser.dataList[index].name,
                              userImage: userController
                                  .searchUser.dataList[index].image,
                              press: () async {
                                var chatId = DataBase().makeChatId(
                                    userController.loginUserData.value.id,
                                    userController
                                        .searchUser.dataList[index].id);
                                userController.tabOnChat(
                                    userController.searchUser.dataList[index],
                                    chatId);
                                // messege
                                FocusScope.of(context).unfocus();

                                var comeBack = await Get.to(MessagesScreen());

                                userController.updateSearchStatus(false);
                                userController.updateSearchUser(null);
                              });
                    },
                  ),
                )
              : Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(userController.loginUserData.value.id)
                          .collection('chatlist')
                          .orderBy('createAt', descending: true)
                          .snapshots(),
                      builder: (context, usersListSnapshot) {
                        if (usersListSnapshot.connectionState ==
                            ConnectionState.active) {
                          if (usersListSnapshot.hasData) {
                            return ListView.builder(
                              itemCount: usersListSnapshot.data.docs.length,
                              itemBuilder: (context, index) {
                                return StreamBuilder<DocumentSnapshot>(
                                    stream: userController.getUserData(
                                        usersListSnapshot.data.docs[index]
                                            ['chatWith']),
                                    builder: (context, userDetail) {
                                      if (userDetail.connectionState ==
                                          ConnectionState.active) {
                                        UserModel uData =
                                            UserModel.fromJson(userDetail.data);
                                        QueryDocumentSnapshot<Object>
                                            chatListData =
                                            usersListSnapshot.data.docs[index];
                                        return ChatCard(
                                          unReadCount:
                                              chatListData['ureadMessge']
                                                      .length ??
                                                  0,
                                          isActive: uData.isActive,
                                          lastMessage:
                                              chatListData['lastChat'] ==
                                                      "loading"
                                                  ? "@ Media File"
                                                  : chatListData['lastChat'],
                                          lastSeen: chatListData['createAt'],
                                          name: "${uData.name.capitalize}",
                                          userImage: "${uData.image}",
                                          press: () {
                                            // get or create chat id
                                            // if usere click on first time chat id will create a new document on firebase or always update document
                                            var chatId = DataBase().makeChatId(
                                                userController
                                                    .loginUserData.value.id,
                                                uData.id);

                                            userController.readChatTrue(
                                                chatListData['ureadMessge'] ??
                                                    [],
                                                chatId);

                                            userController.tabOnChat(
                                              uData,
                                              chatId,
                                            );

                                            // navigate to message inbox
                                            Get.to(MessagesScreen());
                                          },
                                          deleteCallBack: () {
                                            var chatId = DataBase().makeChatId(
                                                userController
                                                    .loginUserData.value.id,
                                                uData.id);
                                            DataBase().deleteChat(
                                                userController
                                                    .loginUserData.value.id,
                                                chatId);
                                          },
                                        );
                                      }
                                      return Container();
                                    });
                              },
                            );
                          } else if (usersListSnapshot.hasError) {
                            return Text("Somthing Error");
                          }
                        }
                        return Text("No data");
                      }),
                )
        ],
      ),
    );
  }
}

class Firestore {}
