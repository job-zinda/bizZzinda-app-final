import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
// No runtime storage permission needed: we save to app-specific directory.

class DownloadHelper {
  /// Downloads a file from [url] and saves it to the app-specific directory.
  /// Returns the file path if successful, or throws an error.
  static Future<String> downloadFile(String url, {String? fileName}) async {
    Directory? downloadsDir;
    if (Platform.isAndroid) {
      // App-specific external storage (no permission required)
      downloadsDir = await getExternalStorageDirectory();
    } else {
      downloadsDir = await getApplicationDocumentsDirectory();
    }
    if (downloadsDir == null) throw Exception('Could not access download directory');

    final String name = fileName ?? url.split('/').last;
    final String savePath = '${downloadsDir.path}/$name';

    final dio = Dio();
    await dio.download(url, savePath);
    return savePath;
  }
}
