import 'dart:io';
import 'package:biz_zinda/view_model/file_view_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../utils/api_service.dart';
import '../utils/api_url.dart';
import '../model/service_model.dart';


class ServiceViewModel with ChangeNotifier {
  List<ServiceModel> services = [];
  List<ServiceModel> otherUserServices = [];

  File? selectedImageFile;
  String? selectedImageUrl;

  final ImagePicker picker = ImagePicker();

  // =========================
  // 📸 PICK IMAGE + UPLOAD
  // =========================
  Future<void> pickAndUploadImage(BuildContext context) async {
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      EasyLoading.show(status: "Uploading image...");

      selectedImageFile = File(picked.path);

      selectedImageUrl = await context
          .read<FileUploadViewModel>()
          .pickedImageUpload(picked, "service");

      EasyLoading.dismiss();
      notifyListeners();
    }
  }

  // =========================
  // ➕ ADD SERVICE (FIXED)
  // =========================
  // Future<void> addService({
  //   required String title,
  //   required String duration,
  //   required int price,
  //   File? imageFile,
  // }) async {
  //   EasyLoading.show(status: "Adding Service...");
  //
  //   try {
  //     String? imageUrl;
  //
  //     if (imageFile != null) {
  //       final xfile = XFile(imageFile.path);
  //
  //       imageUrl = await context
  //           .read<FileUploadViewModel>()
  //           .pickedImageUpload(xfile, "service");
  //
  //       if (imageUrl == null) {
  //         EasyLoading.dismiss();
  //         EasyLoading.showError("Please select image");
  //         return;
  //       }
  //
  //     final body = {
  //       "title": title,
  //       "image": imageUrl,
  //       "price": price,
  //       "duration": duration,
  //     };
  //
  //     final response = await ApiService().post(Api.addService, body);
  //
  //     if (response.statusCode == 201 && response.data['status'] == true) {
  //       EasyLoading.showSuccess("Service Added");
  //       await fetchMyServices();
  //     } else {
  //       EasyLoading.showError(response.data['message'] ?? "Failed");
  //     }
  //   } catch (e) {
  //     EasyLoading.showError("Error: $e");
  //   } finally {
  //     EasyLoading.dismiss();
  //   }
  // }
  Future<void> addService({
    required BuildContext context,
    required String title,
    required String duration,
    required int price,
    File? imageFile,
  }) async {
    EasyLoading.show(status: "Adding Service...");

    try {
      String? imageUrl;

      if (imageFile != null) {
        final xfile = XFile(imageFile.path);

        imageUrl = await context
            .read<FileUploadViewModel>()
            .pickedImageUpload(xfile, "service");
      }

      if (imageUrl == null) {
        EasyLoading.dismiss();
        EasyLoading.showError("Please select image");
        return;
      }

      final body = {
        "title": title,
        "image": imageUrl,
        "price": price, // ✅ FIXED
        "duration": duration,
      };

      final response = await ApiService().post(Api.addService, body);

      if (response.statusCode == 201 && response.data['status'] == true) {
        EasyLoading.showSuccess("Service Added");

        selectedImageFile = null;
        selectedImageUrl = null;

        await fetchMyServices();
      } else {
        EasyLoading.showError(response.data['message'] ?? "Failed");
      }
    } catch (e) {
      EasyLoading.showError("Error: $e");
    } finally {
      EasyLoading.dismiss();
    }
  }

  // =========================
  // ✏️ UPDATE SERVICE (FIXED)
  // =========================
  Future<void> updateService({
    required String id,
    String? title,
    String? duration,
    int? price,
    File? imageFile,
  }) async {
    EasyLoading.show(status: "Updating Service...");

    try {
      String? imageUrl;

      if (imageFile != null) {
        imageUrl = await contextUploadImage(imageFile);
      }

      final body = {
        if (title != null) "title": title,
        if (duration != null) "duration": duration,
        if (price != null) "price": price,
        if (imageUrl != null) "image": imageUrl,
      };

      final response = await ApiService().put(
        "${Api.updateService}/$id",
        body,
      );

      if (response.statusCode == 200 && response.data['status'] == true) {
        EasyLoading.showSuccess("Service Updated");
        await fetchMyServices();
      } else {
        EasyLoading.showError(response.data['message'] ?? "Update failed");
      }
    } catch (e) {
      EasyLoading.showError("Error: $e");
    } finally {
      EasyLoading.dismiss();
    }
  }

  // =========================
  // ❌ DELETE SERVICE
  // =========================
  Future<void> deleteService(String id) async {
    EasyLoading.show(status: "Deleting...");

    try {
      final response = await ApiService().delete(
        "${Api.deleteService}/$id",
      );

      if (response.statusCode == 200 && response.data['status'] == true) {
        EasyLoading.showSuccess("Deleted");
        await fetchMyServices();
      } else {
        EasyLoading.showError("Delete failed");
      }
    } catch (e) {
      EasyLoading.showError("Error: $e");
    } finally {
      EasyLoading.dismiss();
    }
  }

  // =========================
  // 📦 FETCH SERVICES
  // =========================
  Future<void> fetchMyServices() async {
    try {
      final response = await ApiService().get(
        "${Api.listMyServices}?pageNumber=1&pageSize=12",
      );
      print("STATUS: ${response.statusCode}");
      print("DATA: ${response.data}");

      if (response.statusCode == 200 && response.data['status'] == true) {
        services = (response.data['data']['services'] as List)
            .map((e) => ServiceModel.fromJson(e))
            .toList();

        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error fetching services: $e");
    }
  }
  Future<void> fetchOtherUserServices(
      String userId,
      ) async {

    try {

      final api = ApiService();

      final response = await api.get(
        "${Api.listMyServices}/$userId",
      );

      if (response.statusCode == 200 &&
          response.data['status'] == true) {

        final List list =
            response.data['data']['services'] ?? [];

        otherUserServices = list
            .map((e) => ServiceModel.fromJson(e))
            .toList();

        notifyListeners();
      }

    } catch (e) {

      debugPrint(
        "Error fetching other user services: $e",
      );
    }
  }

  // =========================
  // 🔼 IMAGE UPLOAD
  // =========================
  Future<String?> contextUploadImage(File file) async {
    final xfile = XFile(file.path);

    return await FileUploadViewModel().pickedImageUpload(
      xfile,
      "service",
    );
  }
}