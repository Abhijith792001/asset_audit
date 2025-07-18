import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageManager {
  final FlutterSecureStorage appStorage = const FlutterSecureStorage();

  

  Future write(String key, dynamic value) async {
    await appStorage.write(key: key, value: value);
  }

  Future read(String key) async {
   return await appStorage.read(key: key);
  }

  Future deleteAll() async {
    await appStorage.deleteAll();
  }
}

