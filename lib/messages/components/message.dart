import 'package:client_module_getx/models/ChatMessage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import '../../constants.dart';
import 'audio_message.dart';
import 'text_message.dart';
import 'video_message.dart';

class Message extends StatelessWidget {
  const Message({
    Key key,
    @required this.message,
  }) : super(key: key);

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    Widget messageContaint(ChatMessage message, String msg) {
      switch (message.messageType) {
        case ChatMessageType.text:
          return TextMessage(message: message);
          break;
        case ChatMessageType.audio:
          return AudioMessage(message: message);
          break;
        case ChatMessageType.video:
          return ImageVideoMessage(
            isVideo: true,
            link: msg,
          );
          break;
        case ChatMessageType.image:
          return ImageVideoMessage(
            link: msg,
          );
          break;
        case ChatMessageType.document:
          return FilePdfMessage(
            link: msg,
          );
          break;
        default:
          return SizedBox();
      }
    }

    return Padding(
      padding: const EdgeInsets.only(top: kDefaultPadding),
      child: Row(
        mainAxisAlignment:
            message.isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Column(
            // mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              messageContaint(message, message.text),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: kPagingTouchSlop / 4),
                child: Row(
                  children: [
                    Text("${Jiffy(DateTime.parse(message.messageTime)).jm}"),
                    if (message.isSender)
                      MessageStatusDot(status: message.messageStatus)
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class MessageStatusDot extends StatelessWidget {
  final MessageStatus status;

  const MessageStatusDot({Key key, this.status}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Color dotColor(MessageStatus status) {
      switch (status) {
        case MessageStatus.not_sent:
          return kErrorColor;
          break;
        case MessageStatus.not_view:
          return Theme.of(context).textTheme.bodyText1.color.withOpacity(0.1);
          break;
        case MessageStatus.viewed:
          return Theme.of(context).accentColor;
          break;
        default:
          return Colors.transparent;
      }
    }

    return Container(
      margin: EdgeInsets.only(left: kDefaultPadding / 2),
      child: Stack(
        children: [
          Icon(
            Icons.check,
            size: 16,
            color: dotColor(status),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Icon(
              Icons.check,
              size: 16,
              color: dotColor(status),
            ),
          )
        ],
      ),

      //  Icon(
      //   status == MessageStatus.not_sent ? Icons.close : Icons.done,
      //   size: 8,
      //   color: Theme.of(context).accentColor,
      // ),
    );
  }
}
