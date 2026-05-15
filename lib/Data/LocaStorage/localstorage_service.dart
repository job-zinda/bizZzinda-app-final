import 'package:shared_preferences/shared_preferences.dart';

import 'base_local_service.dart';


class LocalStorageService implements BaseLocalService {
  @override
  Future clearAllLocalData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      prefs.clear();
    } catch (e) {
      throw "Unable to delete the local storage";
    }
  }

  @override
  Future<String?> getSavedData(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(key);
    } catch (e) {
      throw "Unable to add data to local";
    }
  }

  @override
  Future clearTheKeyData(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString(key, '');
    } catch (e) {
      throw "Unable to delete the local storage";
    }
  }

  @override
  Future addData(String key, {required String jsonData}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString(key, jsonData);
    } catch (e) {
      throw "Unable to delete the local storage";
    }
  }

  @override
  Future updateData(String key, {required String jsonData}) async {
    try {
      await addData(key, jsonData: jsonData);
    } catch (e) {
      throw "Un able to update the local storage";
    }
  }
}
