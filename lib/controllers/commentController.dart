import 'package:get/get.dart';

class CommentController extends GetxController {
  static CommentController instance = Get.find();

  var totalRepay = "".obs;
  var replaycommentId = "".obs;

  Future updateCommentId(String cmtId) async {
    replaycommentId.value = cmtId;
    update();

    return true;
  }

  Future updateTotalReplay(String count) async {
    totalRepay.value = count;
    update();

    return true;
  }

  @override
  void onReady() {
    super.onReady();
    // ever(firebaseUser, _setInitialScreen);
    // _setInitialScreen();
  }
}
