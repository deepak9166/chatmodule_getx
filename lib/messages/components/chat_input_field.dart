import 'dart:io';
import 'package:client_module_getx/controllers/authController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:get/get.dart';
import '../../constants.dart';
import '../../unitl.dart';

class ChatInputField extends StatefulWidget {
  const ChatInputField({
    Key key,
  }) : super(key: key);

  @override
  _ChatInputFieldState createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  final userProvide = Get.put(AuthController());
  List message = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: kDefaultPadding,
        vertical: kDefaultPadding / 2,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 32,
            color: Color(0xFF087949).withOpacity(0.08),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: kDefaultPadding * 0.75,
                ),
                decoration: BoxDecoration(
                  color: kPrimaryColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Icon(
                        Icons.sentiment_satisfied_alt_outlined,
                        color: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .color
                            .withOpacity(0.64),
                      ),
                    ),
                    SizedBox(width: kDefaultPadding / 4),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Type message",
                          border: InputBorder.none,
                        ),
                        controller: userProvide.message,
                        onChanged: (value) {
                          userProvide.setMessage(value);
                        },
                      ),
                    ),
                    GetBuilder<AuthController>(
                      init: AuthController(),
                      builder: (controller) {
                        return controller.messageString.isEmpty
                            ? Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      uploadImage(context, false);
                                    },
                                    child: Icon(
                                      Icons.attach_file,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .color
                                          .withOpacity(0.64),
                                    ),
                                  ),
                                  SizedBox(width: kDefaultPadding / 4),
                                  InkWell(
                                    onTap: () {
                                      uploadImage(context, true);
                                    },
                                    child: Icon(
                                      Icons.camera_alt_outlined,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .color
                                          .withOpacity(0.64),
                                    ),
                                  ),
                                ],
                              )
                            : InkWell(
                                onTap: () {
                                  String messageTime =
                                      DateTime.now().toString();

                                  var timestamp =
                                      DateTime.now().millisecondsSinceEpoch;

                                  message = [];
                                  message.add(messageTime);
                                  List message2 = [
                                    ...controller.selectedUserUnReadMessage,
                                    ...message
                                  ];
                                  print(
                                      "old new chat ${controller.selectedUserChat.value.isActive}");
                                  controller.sendMessage(
                                      "text",
                                      controller.seletedChatId ==
                                                  controller
                                                      .currectChatRoomRecever &&
                                              controller.selectedUserChat.value
                                                  .isActive
                                          ? []
                                          : message2,
                                      messageTime,
                                      (controller.selectedChatLenght.value + 1)
                                          .toString());

                                  userProvide.setMessage("");
                                },
                                child: Icon(
                                  Icons.send,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .color
                                      .withOpacity(0.64),
                                ),
                              );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  uploadImage(BuildContext context, bool isCamara) {
    final userProvide = Get.put(AuthController());

    getImagePicker(isCamra: isCamara).then((result) async {
      String messageTime = DateTime.now().toString();
      print("date >>>>>>>>>>>>> $messageTime");
      try {
        print(result);

        File file = File(result.path);
        userProvide.imageUploading(true, file);
        final _storage = firebase_storage.FirebaseStorage.instance;
        String _fileName = result.path.split("/").last;

        print("file name >>>>>> $_fileName");

        var type = _fileName.split(".").last;

        print("type >>>>>>> $type");

        print("check >>>>>>>>>>> ${["png", "jpg", "jpeg"].contains(type)}");
        if (["png", "jpg", "jpeg"].contains(type)) {
          type = "image";
        } else if (type == "pdf") {
          type = "document";
        } else if (type == "mp3") {
          type = "audio";
        } else if (type == "mp4") {
          type = "video";
        } else {
          type = "file";
        }

        userProvide.setMessage("loading");
        userProvide.imageUploading(false, null);
        message = [];
        message.add(messageTime);
        List message2 = [...userProvide.selectedUserUnReadMessage, ...message];
        userProvide
            .sendMessage(
                "$type",
                userProvide.seletedChatId == userProvide.currectChatRoomRecever
                    ? []
                    : message2,
                messageTime,
                (userProvide.selectedChatLenght.value + 1).toString())
            .then((messageRes) async {
          await _storage
              .ref()
              .child(_fileName)
              .putFile(file)
              .whenComplete(() async {
            firebase_storage.Reference ref = firebase_storage
                .FirebaseStorage.instance
                .ref()
                .child(_fileName);
            await ref.getDownloadURL().then((fileURL) async {
              await ref.getDownloadURL().then((imageURL) {
                print("updating message id >>>> ${messageTime}");
                userProvide.updateMessageUrl(
                    messageTime, userProvide.seletedChatId.value, imageURL);
              });
            });
          });
        });
      } catch (e) {
        userProvide.imageUploading(false, null);
        print("Somthing wrong!!");
      }
    });
  }
}
