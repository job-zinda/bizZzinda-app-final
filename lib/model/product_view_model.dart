import 'dart:io';
import 'package:biz_zinda/model/logged_in_user.dart';
import 'package:biz_zinda/view_model/file_view_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../utils/api_service.dart';
import '../utils/api_url.dart';
import '../model/product_model.dart';


class ProductViewModel with ChangeNotifier {
  final Dio dio = Dio();
  /// 📦 PRODUCTS LIST
  List<ProductModel> products = [];
  List<ProductModel> otherUserProducts = [];

  /// 🖼️ IMAGE TEMP
  File? selectedImageFile;
  String? selectedImageUrl;

  final ImagePicker picker = ImagePicker();

  /// =========================
  /// 📸 PICK & UPLOAD IMAGE
  /// =========================
  Future<void> pickAndUploadImage(BuildContext context) async {
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      EasyLoading.show(status: "Uploading image...");

      selectedImageFile = File(picked.path);

      /// 🔼 upload image → get URL
      selectedImageUrl = await context
          .read<FileUploadViewModel>()
          .pickedImageUpload(
        picked,
        "product",
      );

      EasyLoading.dismiss();
      notifyListeners();
    }
  }

  /// =========================
  /// ➕ ADD PRODUCT
  /// =========================
  Future<void> addProduct({
    required String name,
    required int price,
    required String imageUrl,
    required String category,
  }) async {
    EasyLoading.show(status: "Adding Product...");

    try {
      final body = {
        "name": name,
        "price": price,
        "image": imageUrl,
        "category": category,
      };

      final response = await ApiService().post(
        Api.addProduct,
        body,
      );

      if (response.statusCode == 201 && response.data['status'] == true) {
        EasyLoading.showSuccess("Product Added Successfully");

        // refresh list
        await fetchMyProducts();
      } else {
        EasyLoading.showError(
          response.data['message'] ?? "Failed to add product",
        );
      }
    } catch (e) {
      EasyLoading.showError("Error: $e");
    } finally {
      EasyLoading.dismiss();
    }
  }

  /// =========================
  /// ✏️ UPDATE PRODUCT
  /// =========================
  Future<void> updateProduct({
    required String id,
    String? name,
    int? price,
    String? category,
    File? imageFile,
  }) async {
    EasyLoading.show(status: "Updating Product...");

    try {
      String? imageUrl;

      /// ✅ FIXED
      if (imageFile != null) {
        imageUrl = await contextUploadImage(imageFile);
      }

      final data = {
        if (name != null) "name": name,
        if (price != null) "price": price,
        if (category != null) "category": category,
        if (imageUrl != null) "image": imageUrl,
      };

      final response = await ApiService().put(
        "${Api.updateProduct}/$id",
        data,
      );

      if (response.statusCode == 200 && response.data['status'] == true) {
        EasyLoading.showSuccess("Product Updated");
        await fetchMyProducts();
      } else {
        EasyLoading.showError(response.data['message'] ?? "Update failed");
      }
    } catch (e) {
      EasyLoading.showError("Error: $e");
    } finally {
      EasyLoading.dismiss();
    }
  }

  /// =========================
  /// ❌ DELETE PRODUCT
  /// =========================
  Future<void> deleteProduct(String id) async {
    EasyLoading.show(status: "Deleting...");

    try {
      final response = await ApiService().delete(
        "${Api.deleteProduct}/$id",
      );

      if (response.statusCode == 200 && response.data['status'] == true) {
        EasyLoading.showSuccess("Deleted");
        await fetchMyProducts();
      } else {
        EasyLoading.showError("Delete failed");
      }
    } catch (e) {
      EasyLoading.showError("Error: $e");
    } finally {
      EasyLoading.dismiss();
    }
  }

  /// =========================
  /// 📦 FETCH PRODUCTS
  /// =========================

  // Future<void> fetchMyProducts() async {
  //   try {
  //     final response = await ApiService().get(Api.listMyProducts);
  //
  //     if (response.statusCode == 200 && response.data['status'] == true) {
  //       products = (response.data['data']['products'] as List)
  //           .map((e) => ProductModel.fromJson(e))
  //           .toList();
  //
  //       notifyListeners();
  //     }
  //   } catch (e) {
  //     debugPrint("Error fetching products: $e");
  //   }
  // }
  Future<void> fetchMyProducts() async {
    try {
      var isLoading = true;
      notifyListeners();

      final api = ApiService();
      final response = await api.get(Api.listMyProducts);

      if (response.statusCode == 200 &&
          response.data['status'] == true) {

        final List list =
            response.data['data']['products'] ?? [];

        products = list
            .map((e) => ProductModel.fromJson(e))
            .toList();
      }

    } catch (e) {
      debugPrint("Error fetching products: $e");
    } finally {
      var isLoading = false;
      notifyListeners();
    }
  }

  /// =========================
  /// 🔼 IMAGE UPLOAD HELPER
  /// =========================
  Future<String?> contextUploadImage(File file) async {
    final xfile = XFile(file.path);

    return await FileUploadViewModel().pickedImageUpload(
      xfile,
      "product",
    );
  }
  /// ================= FETCH OTHER USER PRODUCTS =================

  Future<void> fetchOtherUserProducts(String profileId) async {

    try {

      print("FETCHING PRODUCTS...");

      final headers =
      await LoggedInUser.getAuthorizationHeader();

      final response = await Dio().get(
        Api.otherUserProducts(profileId),

        options: Options(
          headers: {
            ...headers,
            "verifyPlatform": "bizzinda",
          },
        ),
      );

      print("PRODUCT RESPONSE => ${response.data}");

      if (response.statusCode == 200 &&
          response.data["status"] == true) {

        final List data =
            response.data["data"]["products"] ?? [];

        otherUserProducts = data
            .map((e) => ProductModel.fromJson(e))
            .toList();

        notifyListeners();

      } else {

        print("PRODUCT FETCH FAILED");
      }

    } catch (e) {

      print("PRODUCT ERROR => $e");
    }
  }
}