import 'package:flutter/material.dart';
import 'package:surf_practice_chat_flutter/data/chat/models/message.dart';

class MessageItem extends StatelessWidget {
  const MessageItem({required this.message, Key? key}) : super(key: key);
  final ChatMessageDto message;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.deepPurple,
            maxRadius: 35,
            child: Text(
              message.author.name.substring(0, 1),
            ),
          ),
        ),
        Row(
          children: [
            const SizedBox(
              width: 70,
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message.author.name,
                      style: const TextStyle(fontStyle: FontStyle.italic),
                      textAlign: TextAlign.start,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        message.message,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
