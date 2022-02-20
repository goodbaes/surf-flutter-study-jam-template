import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:surf_practice_chat_flutter/data/chat/chat.dart';
import 'package:surf_practice_chat_flutter/data/chat/models/message.dart';
import 'package:surf_practice_chat_flutter/data/chat/repository/firebase.dart';

class MessageItem extends StatelessWidget {
  const MessageItem({
    required this.message,
    required this.chatRepository,
    Key? key,
    this.withAvatar = true,
  }) : super(key: key);

  const MessageItem.withOutAvatar({
    required this.message,
    required this.chatRepository,
    key,
    this.withAvatar = false,
  }) : super(key: key);

  final ChatMessageDto message;
  final bool withAvatar;
  final ChatRepositoryFirebase chatRepository;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(8, withAvatar ? 8 : 0, 8, 8),
          child: Stack(
            alignment: chatRepository.name == message.author.name
                ? Alignment.centerRight
                : Alignment.centerLeft,
            children: <Widget>[
              Visibility(
                visible: withAvatar,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.deepPurple,
                    maxRadius: 35,
                    child: Text(
                      message.author.name.substring(0, 1),
                    ),
                  ),
                ),
              ),
              Positioned(
                child: Row(
                  children: [
                    const SizedBox(
                      width: 70,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Visibility(
                                visible: withAvatar,
                                child: Text(
                                  message.author.name,
                                  style: const TextStyle(
                                      fontStyle: FontStyle.italic),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  child: Flexible(
                                    child: Text(
                                      message.message,
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
