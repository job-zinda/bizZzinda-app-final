import 'dart:developer';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../utils/api_service.dart';
import '../utils/api_url.dart';

class FileUploadViewModel with ChangeNotifier {
  final Dio _dio = Dio();

  // Map a logical fieldName/type to a backend folder
  String _folderFor(String fieldName, {String? type}) {
    final f = fieldName.toLowerCase();
    if (f.contains('thumbnail')) return 'posts/thumbnails';
    if (f == 'post') {
      if ((type ?? '').toLowerCase() == 'video') return 'posts/videos';
      return 'posts/images';
    }
    if (f.contains('profile')) return 'profiles';
    if (f.contains('cover')) return 'covers';
    if (f.contains('story')) {
      if ((type ?? '').toLowerCase() == 'video') return 'stories/videos';
      return 'stories/images';
    }
    if (f.contains('audio')) return 'audio';
    return 'media';
  }

  Future<String?> _uploadBytes(Uint8List bytes, String filename, String folder) async {
    try {
      final headers = await Api.getAuthorizationHeader();
      final formData = FormData.fromMap({
        'folder': folder,
        'file': MultipartFile.fromBytes(bytes, filename: filename),
      });
      final resp = await _dio.post(
        '${AppUrl.baseurl}/api/v1/upload/single',
        data: formData,
        options: Options(headers: {
          ...headers,
          'Content-Type': 'multipart/form-data',
        }),
      );
      if ((resp.statusCode == 200 || resp.statusCode == 201) && resp.data is Map) {
        final data = resp.data as Map;
        if (data['status'] == true) {
          return data['data']?['url'] as String?;
        }
      }
      return null;
    } catch (e) {
      print('Upload error: $e');
      return null;
    }
  }

  // Deprecated: signed-URL based flow removed

  Future<String?> pickedImageUpload(
    XFile pickedImage,
    String fieldName,
  ) async {
    EasyLoading.show(status: 'Processing image...');
    try {
      final bytes = await pickedImage.readAsBytes();
      final folder = _folderFor(fieldName, type: 'image');
      final url = await _uploadBytes(bytes, pickedImage.name, folder);
      return url;
    } catch (e) {
      print('Error in pickedImageUpload: $e');
      return null;
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<String?> pickedVideoUpload(Uint8List imageBytes, String name) async {
    try {
      EasyLoading.show(status: 'Processing video...');
      final folder = _folderFor('Post', type: 'video');
      final url = await _uploadBytes(imageBytes, name, folder);
      return url;
    } catch (e) {
      print('Error in pickedVideoUpload: $e');
      return null;
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<String?> pickedAudioUpload(
      dynamic audioBytes, String name, String audioName) async {
    EasyLoading.show(status: 'Processing audio...');
    try {
      final folder = _folderFor('audio', type: 'audio');
      final url = await _uploadBytes(audioBytes as Uint8List, audioName, folder);
      return url;
    } catch (e) {
      print('Error in pickedAudioUpload: $e');
      EasyLoading.showError('Failed to upload audio.');
      return null;
    } finally {
      EasyLoading.dismiss();
    }
  }

//   Future<CustomXFile> convertUint8ListToCustomXFile(
//       Uint8List data, String fileName) async {
//     if (data.isEmpty) {
//       print("Data is empty. Cannot create XFile.");
//       throw ArgumentError("Data cannot be empty");
//     }

//     print("Creating XFile from Uint8List...");

//     final xfile = XFile.fromData(
//       data,
//       mimeType: 'image/png', // Specify MIME type.
//     );

//     print("CustomXFile created with name: $fileName");
//     return CustomXFile(xfile, fileName);
//   }
}

// class CustomXFile {
//   final XFile xfile;
//   final String name;

//   CustomXFile(this.xfile, this.name);
// }
