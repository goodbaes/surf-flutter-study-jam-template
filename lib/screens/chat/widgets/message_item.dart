import 'package:flutter/material.dart';
import 'package:surf_practice_chat_flutter/data/chat/models/message.dart';

class MessageItem extends StatelessWidget {
  const MessageItem({required this.message, Key? key}) : super(key: key);
  final ChatMessageDto message;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(message.author.name.substring(0, 1)),
      ),
      title: Text(message.author.name),
      subtitle: Text(message.message),
    );
  }
}
