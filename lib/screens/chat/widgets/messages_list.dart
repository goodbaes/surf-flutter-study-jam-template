import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:surf_practice_chat_flutter/data/chat/models/message.dart';
import 'package:surf_practice_chat_flutter/data/chat/repository/firebase.dart';
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
          final messageItem = MessageItem(
              message: messages[index],
              chatRepository: GetIt.instance.get<ChatRepositoryFirebase>(),
              withAvatar: messages[index].author.name !=
                  messages[index - 1].author.name);

          return messageItem;
        });
  }
}
