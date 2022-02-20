import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:surf_practice_chat_flutter/data/chat/models/message.dart';
import 'package:surf_practice_chat_flutter/data/chat/repository/firebase.dart';
import 'package:surf_practice_chat_flutter/screens/chat/widgets/message_item.dart';

class MessegesList extends StatelessWidget {
  const MessegesList(
    this.controller, {
    required this.messages,
    Key? key,
  }) : super(key: key);
  final ScrollController controller;
  final List<ChatMessageDto> messages;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        controller: controller,
        physics: const BouncingScrollPhysics(),
        itemCount: messages.length,
        itemBuilder: (context, index) {
          messageItem(bool condition) => MessageItem(
              message: messages[index],
              chatRepository: GetIt.instance.get<ChatRepositoryFirebase>(),
              withAvatar: condition);

          return index == 0
              ? messageItem(true)
              : messageItem(messages[index].author.name !=
                  messages[index - 1].author.name);
        });
  }
}
