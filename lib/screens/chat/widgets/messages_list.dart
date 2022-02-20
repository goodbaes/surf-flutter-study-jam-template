import 'package:flutter/material.dart';
import 'package:surf_practice_chat_flutter/data/chat/models/message.dart';
import 'package:surf_practice_chat_flutter/screens/chat/widgets/message_item.dart';

class MessegesList extends StatelessWidget {
  const MessegesList({
    required this.messages,
    Key? key,
  }) : super(key: key);
  final List<ChatMessageDto> messages;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: messages.length,
        itemBuilder: (context, index) {
          if (index == 0) {
            return MessageItem(
              message: messages[index],
            );
          } else {
            return messages[index].author.name ==
                    messages[index - 1].author.name
                ? MessageItem.withOutAvatar(message: messages[index])
                : MessageItem(message: messages[index]);
          }
        });
  }
}
