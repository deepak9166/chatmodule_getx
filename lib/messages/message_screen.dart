import 'package:client_module_getx/controllers/authController.dart';
import 'package:client_module_getx/models/Chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import '../constants.dart';
import 'components/chatInbox.dart';

class MessagesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userController = Get.put(AuthController());

    return Scaffold(
      appBar: buildAppBar(userController, context),
      body: Body(),
    );
  }

  AppBar buildAppBar(AuthController userProvide, BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: true,
      elevation: 2,
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_rounded,
          color: Colors.black,
        ),
        onPressed: () {
          userProvide.updateCurrentChatRoom("");
          Navigator.pop(context);
        },
      ),
      title: Row(
        children: [
          // BackButton(
          //   color: Colors.black,
          // ),
          CircleAvatar(
            backgroundImage: userProvide.selectedUserChat.value.image.isEmpty
                ? AssetImage("assets/images/user_2.png")
                : NetworkImage(userProvide.selectedUserChat.value.image),
          ),
          SizedBox(width: kDefaultPadding * 0.75),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${userProvide.selectedUserChat.value.name.capitalize}",
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              StreamBuilder<DocumentSnapshot>(
                stream: userProvide
                    .getUserData(userProvide.selectedUserChat.value.id),
                builder: (context, userStatus) {
                  if (userStatus.connectionState == ConnectionState.active) {
                    UserModel selectedUser =
                        UserModel.fromJson(userStatus.data);

                    userProvide.tabOnChat(
                      selectedUser,
                      userProvide.seletedChatId.value,
                    );

                    userProvide.setCurrentChatRoomIdRecever(
                        selectedUser.currentChatRoom);

                    return Text(
                      selectedUser.isActive
                          ? "Online"
                          : "${Jiffy(DateTime.parse(selectedUser.lastMessage)).fromNow()}",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    );
                  }
                  return Text("Loading...");
                },
              )
            ],
          )
        ],
      ),
    );
  }
}
