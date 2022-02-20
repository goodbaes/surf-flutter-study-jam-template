import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:surf_practice_chat_flutter/data/chat/models/message.dart';
import 'package:surf_practice_chat_flutter/data/chat/repository/firebase.dart';

import 'package:surf_practice_chat_flutter/data/chat/repository/repository.dart';
import 'package:surf_practice_chat_flutter/screens/chat/widgets/messages_list.dart';
import 'package:surf_practice_chat_flutter/screens/chat/widgets/my_text_form.dart';
import 'package:surf_practice_chat_flutter/widgets/my_progress_indicator.dart';

/// Chat screen templete. This is your starting point.
class ChatScreen extends StatefulWidget {
  final ChatRepository chatRepository;

  const ChatScreen({
    Key? key,
    required this.chatRepository,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final chatRepository = ChatRepositoryFirebase(FirebaseFirestore.instance);
  Future<List<ChatMessageDto>> get messages => chatRepository.messages;

  bool showBottomTextField = false;
  bool showTopTextField = false;

  var nickName = 'nickName';

  final TextEditingController nickController = TextEditingController();

  final TextEditingController messageController = TextEditingController();

  final List<ChatMessageDto> previouseMessageList = [];

  void onSaveNick() async {
    setState(() {
      nickName = nickController.text;
    });
  }

  void onMessageSend() async {
    await chatRepository.sendMessage(nickName, messageController.text);
    messageController.clear();
    setState(() {
      showBottomTextField = false;
      showTopTextField = false;
    });
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: showBottomTextField
          ? const SizedBox()
          : FloatingActionButton(
              onPressed: () {
                setState(() {
                  nickController.text = nickName;
                  showBottomTextField = !showBottomTextField;
                });
              },
              child: const Icon(Icons.send),
            ),
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                showTopTextField = !showTopTextField;
              });
            },
            child: const Text(
              'Edit Nickname',
              style: TextStyle(color: Colors.amber),
            ),
          ),
          IconButton(
              onPressed: (() => setState(() {
                    previouseMessageList.clear();
                  })),
              icon: Icon(Icons.refresh))
        ],
        leadingWidth: MediaQuery.of(context).size.width / 1.5,
        title: Text(nickName),
      ),
      body: Center(
        child: Stack(
          children: [
            Column(
              children: <Widget>[
                Expanded(
                  child: FutureBuilder<List<ChatMessageDto>>(
                    initialData: [],
                    builder: (context, snapshot) {
                      final data = snapshot.data;
                      final state = snapshot.connectionState;

                      if (snapshot.hasError) {
                        return _buildListError(snapshot);
                      } else if (state == ConnectionState.waiting ||
                          data == null) {
                        if (previouseMessageList.isNotEmpty) {
                          return _buildSuccess(previouseMessageList);
                        }
                        return const Center(child: MyProgressIdicator());
                      } else if (snapshot.data != null && snapshot.hasData) {
                        previouseMessageList.clear();
                        previouseMessageList.addAll(data);
                        return _buildSuccess(data);
                      } else if (data.isEmpty) {
                        _buildEmpty();
                      }

                      return const Center(child: MyProgressIdicator());
                    },
                    future: messages,
                  ),
                ),
                _buildAnimatedTextField(
                    showBottomTextField,
                    MyTextForm(
                      onTap: () => onMessageSend(),
                      controller: messageController,
                    )),
              ],
            ),
            _buildAnimatedTextField(
                showTopTextField,
                MyTextForm.top(
                  onTap: () => onSaveNick(),
                  controller: nickController,
                )),
          ],
        ),
      ),
    );
  }

  AnimatedContainer _buildAnimatedTextField(bool isVisible, Widget child) {
    return AnimatedContainer(
        height: isVisible ? 70 : 0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: child);
  }

  Widget _buildSuccess(List<ChatMessageDto> data) =>
      MessegesList(messages: data);

  Widget _buildEmpty() => const Text('Empty List');

  Widget _buildListError(AsyncSnapshot<List<ChatMessageDto>> snapshot) =>
      Text("${snapshot.error}");
}
