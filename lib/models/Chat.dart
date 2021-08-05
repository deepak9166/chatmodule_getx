import 'package:cloud_firestore/cloud_firestore.dart';

class UserChatList {
  List<UserModel> dataList;
  UserChatList({this.dataList});

  UserChatList.fromJson(QuerySnapshot<Object> json) {
    // //print("in state model $json");
    var subjectList = json.docs;
    dataList = subjectList.map((item) => UserModel.fromJson(item)).toList();
  }
}

class UserModel {
  String name, lastMessage, image;
  String userCreateAt;
  bool isActive;
  String id;
  String lastSceen;
  String currentChatRoom;
  UserModel(
      {this.name,
      this.lastMessage,
      this.image,
      this.userCreateAt,
      this.isActive,
      this.id,
      this.lastSceen,
      this.currentChatRoom});

  UserModel.fromJson(DocumentSnapshot<Object> json) {
    //print("in list data ${json}");
    // print("get name in model ${json['name']}");
    name = json['name'] ?? '';
    lastMessage = json['lastSeen'];
    image = json['image'];
    userCreateAt = json['createAt'];
    isActive = json['status'];
    lastSceen = json['lastSeen'];
    currentChatRoom = json['currentChatroom'];
    id = json.id;
  }
  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    // data['name'] = this.name;
    return data;
  }
}
