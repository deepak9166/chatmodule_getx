import 'package:client_module_getx/controllers/authController.dart';
import 'package:client_module_getx/firebase/db_method.dart';
import 'package:client_module_getx/messages/components/video_message.dart';
import 'package:client_module_getx/models/ChatMessage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants.dart';
import 'chat_input_field.dart';
import 'message.dart';

class Body extends StatelessWidget {
  getMessageType(String type) {
    switch (type) {
      case "text":
        return ChatMessageType.text;
        break;
      case "image":
        return ChatMessageType.image;
        break;
      case "video":
        return ChatMessageType.video;
        break;
      case "document":
        return ChatMessageType.document;
        break;
      case "audio":
        return ChatMessageType.audio;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvide = Get.put(AuthController());
    return Column(
      children: [
        Expanded(
          child: Container(
              child: StreamBuilder<QuerySnapshot>(
            stream: DataBase().getUserChat(userProvide.seletedChatId.value),
            builder: (context, userChatSnapshot) {
              if (userChatSnapshot.connectionState == ConnectionState.active) {
                return ListView.builder(
                  reverse: true,
                  physics: BouncingScrollPhysics(),
                  padding:
                      const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                  itemCount: userChatSnapshot.data.docs.length,
                  itemBuilder: (context, indexChat) {
                    userProvide.updateSelectedInboxMessegeLenght(
                        userChatSnapshot.data.docs.length);
                    int index =
                        (userChatSnapshot.data.docs.length - 1) - indexChat;
                    var data = ChatMessage(
                        text: "${userChatSnapshot.data.docs[index]['content']}",
                        messageType: getMessageType(
                            userChatSnapshot.data.docs[index]['type']),
                        messageStatus: userChatSnapshot.data.docs[index]
                                ['isRead']
                            ? MessageStatus.viewed
                            : MessageStatus.not_view,
                        isSender: userChatSnapshot.data.docs[index]['idFrom'] ==
                            userProvide.loginUserData.value.id,
                        isReceverActive: true,
                        messageTime: userChatSnapshot.data.docs[index]
                            ['createAt']);
                    return Message(message: data);
                  },
                );
              }
              return Container();
            },
          )),
        ),
        // userProvide.isUploading
        //     ? Align(
        //         alignment: Alignment.centerRight,
        //         child: ImageVideoMessage(
        //           isVideo: false,
        //           localFile: userProvide.uploadingImageFile,
        //           loading: userProvide.isUploading,
        //         ),
        //       )
        //     : SizedBox(),
        ChatInputField(),
      ],
    );
  }
}
