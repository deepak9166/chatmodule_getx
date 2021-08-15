import 'package:client_module_getx/Post/post_list.dart';
import 'package:client_module_getx/controllers/authController.dart';
import 'package:client_module_getx/lifeCycle.dart';
import 'package:client_module_getx/models/Chat.dart';
import 'package:client_module_getx/view/chat/chats_screen.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import 'package:get/get.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final cartController = Get.put(AuthController());

  @override
  void initState() {
    bool isActive = false;

    // UserProvider userProvider = Provider.of(context, listen: false);
    WidgetsBinding.instance
        .addObserver(LifecycleEventHandler(suspendingCallBack: () async {
      isActive = true;
      if (isActive) {
        isActive = false;
        print("stop >>>>>>>>>>>>>>>>>>>>>>> ");
        print("offline");
        cartController.updateStatus(false);
      }
    }, resumeCallBack: () async {
      if (!isActive) {
        isActive = true;
        cartController.updateStatus(true);
        print("online");
        print("resume >>>>>>>>>>>>>>>>>>>>>>> ");
      }
      // isActive = false;
    }));

// login demmy
    cartController.getUserData("v6cs2TMmuxVGls5OcLrL").listen((event) {
      UserModel loginUserData = UserModel.fromJson(event);
      cartController.setUserData(loginUserData);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("login>>>>>");
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Welcome",
                style: TextStyle(color: Colors.blue, fontSize: 24),
              ),
              FittedBox(
                child: TextButton(
                    onPressed: () => {
                          // Get.to(ChatsScreen())
                          Get.to(PostList())
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //       builder: (context) => ChatsScreen(),
                          //     ),
                          //   ),
                        },
                    child: Row(
                      children: [
                        Text(
                          "Start",
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .color
                                  .withOpacity(0.8)),
                        ),
                        SizedBox(width: kDefaultPadding / 4),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Theme.of(context)
                              .textTheme
                              .bodyText1
                              .color
                              .withOpacity(0.8),
                        )
                      ],
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
