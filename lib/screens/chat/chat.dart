import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:surf_practice_chat_flutter/data/chat/chat.dart';
import 'package:surf_practice_chat_flutter/data/chat/repository/geolocator_repository.dart';

import 'package:surf_practice_chat_flutter/screens/chat/widgets/messages_list.dart';
import 'package:surf_practice_chat_flutter/screens/chat/widgets/my_text_form.dart';
import 'package:surf_practice_chat_flutter/widgets/my_progress_indicator.dart';

const texture =
    'https://media.istockphoto.com/vectors/paper-texture-background-vector-id1199971584';

/// Chat screen templete. This is your starting point.
class ChatScreen extends StatefulWidget {
  final ChatRepository chatRepository;
  final GeolocatorRepository geoRepository;
  const ChatScreen({
    Key? key,
    required this.geoRepository,
    required this.chatRepository,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final ChatRepository chatRepository;
  late final GeolocatorRepository geoRepository;

  Future<List<ChatMessageDto>> get messages => chatRepository.messages;
  Future<ChatGeolocationDto> get location => geoRepository.getGeo();
  bool showBottomTextField = false;
  bool showTopTextField = false;
  bool isMessageSandingProccess = false;

  String nickName = '';

  setNickName(name) {
    nickName = (name);
  }

  final ScrollController scrollController = ScrollController();

  final FocusNode nickNode = FocusNode();

  final FocusNode messageNode = FocusNode();

  final TextEditingController nickController = TextEditingController();

  final TextEditingController messageController = TextEditingController();

  void onSaveNick() async {
    setNickName(nickController.text);

    setState(() {
      showTopTextField = false;
    });

    FocusManager.instance.primaryFocus?.unfocus();
  }

  void onMessageSend() async {
    try {
      setState(() {
        isMessageSandingProccess = true;
      });
      await chatRepository.sendMessage(nickName, messageController.text);
    } catch (e) {
      log(e.toString());
    } finally {
      setState(() {
        showBottomTextField = false;
        showTopTextField = false;
        isMessageSandingProccess = false;
      });

      messageController.clear();
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  void sendGeo() async {
    setState(() {
      isMessageSandingProccess = true;
    });
    await chatRepository.sendGeolocationMessage(
      nickname: nickName,
      location: ChatGeolocationDto(latitude: 55, longitude: 55),
      message: messageController.text.isEmpty ? null : messageController.text,
    );
    setState(() {
      isMessageSandingProccess = false;
    });
  }

  @override
  void initState() {
    chatRepository = widget.chatRepository;
    geoRepository = widget.geoRepository;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    return Center(
      child: Stack(
        children: [
          _buildTextureBackground(),
          Column(
            children: <Widget>[
              Expanded(
                child: FutureBuilder<List<ChatMessageDto>>(
                  initialData: const [],
                  builder: (context, snapshot) {
                    final data = snapshot.data;
                    final state = snapshot.connectionState;

                    if (snapshot.hasError) {
                      return _buildListError(snapshot);
                    } else if (state == ConnectionState.waiting ||
                        data == null) {
                      return const Center(child: MyProgressIdicator());
                    } else if (snapshot.data != null && snapshot.hasData) {
                      return _buildSuccess(data);
                    } else if (data.isEmpty) {
                      _buildEmpty();
                    }

                    return const Center(child: MyProgressIdicator());
                  },
                  future: messages,
                ),
              ),
              MyTextForm(
                onTapGeo: () => sendGeo(),
                isLoading: isMessageSandingProccess,
                focusNode: messageNode,
                onTap: () => onMessageSend(),
                controller: messageController,
              )
            ],
          ),
          _buildAnimatedTextField(
              showTopTextField,
              MyTextForm.top(
                focusNode: nickNode,
                onTap: () => onSaveNick(),
                controller: nickController,
              )),
        ],
      ),
    );
  }

  Widget _buildTextureBackground() {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Image.network(
        texture,
        fit: BoxFit.fitHeight,
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      actions: [
        TextButton(
          onPressed: () {
            setState(() {
              nickController.text = nickName;
              showTopTextField = !showTopTextField;
            });
            if (showTopTextField) {
              nickNode.requestFocus();
            }
          },
          child: const Text(
            'Edit Nickname',
            style: TextStyle(color: Colors.amber),
          ),
        ),
        IconButton(
            onPressed: (() {
              setState(() {});
            }),
            icon: const Icon(Icons.refresh))
      ],
      leadingWidth: MediaQuery.of(context).size.width / 1.5,
      title: Text(nickName),
    );
  }

  Widget _buildAnimatedTextField(bool isVisible, Widget child) {
    return AnimatedContainer(
        height: isVisible ? 70 : 0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: child);
  }

  Widget _buildSuccess(List<ChatMessageDto> data) =>
      MessegesList(scrollController, messages: data);

  Widget _buildEmpty() => const Text('Empty List');

  Widget _buildListError(AsyncSnapshot<List<ChatMessageDto>> snapshot) =>
      Text("${snapshot.error}");
}
