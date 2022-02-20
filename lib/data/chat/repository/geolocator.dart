import 'package:surf_practice_chat_flutter/data/chat/chat.dart';
import 'package:surf_practice_chat_flutter/data/chat/repository/geolocator_repository.dart';

class GeolocatorImpl extends GeolocatorRepository {
  @override
  Future<ChatGeolocationDto> getGeo() async {
    return ChatGeolocationDto(
      latitude: 37.566,
      longitude: 126.978,
    );
  }
}
