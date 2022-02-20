import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:surf_practice_chat_flutter/data/chat/repository/firebase.dart';
import 'package:surf_practice_chat_flutter/data/chat/repository/geolocator.dart';
import 'package:surf_practice_chat_flutter/firebase_options.dart';
import 'package:surf_practice_chat_flutter/screens/chat/chat.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform(
      androidKey: 'AIzaSyD5bCOfO29kCv2mIdmYa6CEKhud4Gs1YIU',
      iosKey: 'AIzaSyBZo6-selWq9F-oQqwjr9eB2VpSvFc9DYE',
      webKey: 'AIzaSyAtMxD7Nb6Z06IL2yg8DbI56xoneVhXSNQ',
    ),
  );
  GetIt.instance.registerSingleton<ChatRepositoryFirebase>(
      ChatRepositoryFirebase(FirebaseFirestore.instance));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final chatRepository = GetIt.instance.get<ChatRepositoryFirebase>();
    final geoRepository = GeolocatorImpl();
    return MaterialApp(
      theme: ThemeData(
        colorSchemeSeed: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: ChatScreen(
        geoRepository: geoRepository,
        chatRepository: chatRepository,
      ),
    );
  }
}
