abstract interface class BaseLocalService {
  Future<String?> getSavedData(String key);
  Future<dynamic> clearAllLocalData();
  Future<dynamic> clearTheKeyData(String key);
  Future<dynamic> addData(String key, {required String jsonData});
  Future<dynamic> updateData(String key, {required String jsonData});
}
