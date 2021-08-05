import 'package:client_module_getx/firebase/db_method.dart';
import 'package:client_module_getx/models/Chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  UserChatList searchUser;
  var isSearch = false.obs;
  var myChatList = UserModel().obs;
  var loginUserData = UserModel().obs;
  var selectedId = "".obs;
  var seletedChatId = "".obs;
  TextEditingController message = TextEditingController();
  var searchController = TextEditingController().obs;
  String messageString = '';
  Rx<UserModel> selectedUserChat = UserModel().obs;
  var currectChatRoomRecever = "".obs;
  bool isUploading = false;
  var uploadingImageFile;
  var selectedUserUnReadMessage = [].obs;
  var selectedChatLenght = 0.obs;

  @override
  void onReady() {
    super.onReady();
    // ever(firebaseUser, _setInitialScreen);
    // _setInitialScreen();
  }

  updateSelectedInboxMessegeLenght(int lenght) {
    selectedChatLenght.value = lenght;
    // update();
  }

  Stream<DocumentSnapshot> getUserData(String uId) {
    return FirebaseFirestore.instance.collection('users').doc(uId).snapshots();
  }

  setUserData(UserModel data) {
    loginUserData = data.obs;
    print("data added ${loginUserData.value.name}");
  }

  imageUploading(bool uploadStatus, var file) {
    isUploading = uploadStatus;

    uploadingImageFile = file;
  }

  updateSearchUser(UserChatList user) {
    searchUser = user;

    update();
  }

  updateSearchStatus(bool search) {
    isSearch.value = search;
    if (!search) {
      searchController..value.clear();
    }
    update();
  }

  setCurrentChatRoomIdRecever(String id) {
    currectChatRoomRecever.value = id;
  }

  updateStatus(bool status) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(loginUserData.value.id)
        .update({'lastSeen': DateTime.now().toString(), "status": status});
  }

  updateReadUnReadStatus(String userId, Map unReadData) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('chatlist')
        .doc(seletedChatId.value)
        .set({
      "userId": unReadData,
    });
  }

  tabOnChat(UserModel selectUser, String chatId) {
    selectedId = selectUser.id.obs;
    seletedChatId = chatId.obs;
    selectedUserChat = selectUser.obs;

    getChatHistory(selectedId.value, seletedChatId.value);
    //

    updateCurrentChatRoom(seletedChatId.value);
  }

  readChatTrue(List unReadChat, String chatId) {
    if (unReadChat.isNotEmpty) {
      unReadChat.forEach((element) {
        try {
          print("eee ??? $element");
          DataBase().updateReadMessage(chatId, element);
        } catch (e) {
          print(e);
        }
      });
    }
  }

  getChatHistory(String id, String chatId) {
    print("chat >>>>>");

    try {
      FirebaseFirestore.instance
          .collection('users')
          .doc(id)
          .collection('chatlist')
          .doc(chatId)
          .get()
          .then((value) => {
                print(value.exists),
                if (value.exists)
                  {
                    selectedUserUnReadMessage.value = value["ureadMessge"],
                    update(),
                    updateUnReadMessage(seletedChatId.value),
                  }
              });
    } catch (e) {
      print(e);
    }
  }

  setMessage(String value) {
    messageString = value;
    update();
  }

  Future sendMessage(String messageType, List update, String messageTime,
      String messgeLength) async {
    updateCurrentChatRoom(seletedChatId.value);

    print("send string >>>>> $messageString");
    DataBase().sendMessageToChatRoom(
        seletedChatId.value,
        loginUserData.value.id,
        selectedId.value,
        messageString,
        messageType,
        (selectedUserChat.value.isActive &&
            seletedChatId == currectChatRoomRecever),
        messageTime,
        messgeLength);

// recevier user chat list update
    DataBase().updateChatRequestField(
        selectedId.value,
        messageString,
        seletedChatId.value,
        loginUserData.value.id,
        selectedId.value,
        update,
        messageTime);

// sender user chat list update
    DataBase().updateChatRequestField(
        loginUserData.value.id,
        messageString,
        seletedChatId.value,
        selectedId.value,
        loginUserData.value.id,
        [],
        messageTime);
    message.clear();
    messageString = "";

    getChatHistory(selectedId.value, seletedChatId.value);
  }

  updateUnReadMessage(String seletedChatId) {
    // clear self unread chat form a room chat
    DataBase().updateUnReadMessage(loginUserData.value.id, seletedChatId, []);
  }

  updateMessageUrl(
    String docId,
    String seletedChatId,
    String url,
  ) {
    // update url after uploaded
    DataBase().updateUrlMessage(docId, seletedChatId, url);
  }

  updateCurrentChatRoom(String id) {
    // clear self unread chat form a room chat
    DataBase().currentMyChatroom(loginUserData.value.id, seletedChatId, id);
  }
}
