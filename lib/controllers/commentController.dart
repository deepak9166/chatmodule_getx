import 'package:get/get.dart';

class CommentController extends GetxController {
  static CommentController instance = Get.find();

  var replayTotalCount = 0.obs;

  updateTotalReplay(int count) {
    replayTotalCount.value = count;
    update();
  }

  @override
  void onReady() {
    super.onReady();
    // ever(firebaseUser, _setInitialScreen);
    // _setInitialScreen();
  }
}
