import 'package:surf_practice_chat_flutter/data/chat/chat.dart';

abstract class GeolocatorRepository {
  Future<ChatGeolocationDto> getGeo();
}
