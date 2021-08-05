import 'package:client_module_getx/models/ChatMessage.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../unitl.dart';

class AudioMessage extends StatelessWidget {
  final ChatMessage message;
  final link;
  const AudioMessage({Key key, this.message, this.link}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return message.text == "loading"
        ? messageLoader()
        : Container(
            width: MediaQuery.of(context).size.width * 0.55,
            padding: EdgeInsets.symmetric(
              horizontal: kDefaultPadding * 0.75,
              vertical: kDefaultPadding / 2.5,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: kPrimaryColor.withOpacity(message.isSender ? 1 : 0.1),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.play_arrow,
                  color: message.isSender ? Colors.white : kPrimaryColor,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: kDefaultPadding / 2),
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 2,
                          color: message.isSender
                              ? Colors.white
                              : kPrimaryColor.withOpacity(0.4),
                        ),
                        Positioned(
                          left: 0,
                          child: Container(
                            height: 8,
                            width: 8,
                            decoration: BoxDecoration(
                              color: message.isSender
                                  ? Colors.white
                                  : kPrimaryColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
