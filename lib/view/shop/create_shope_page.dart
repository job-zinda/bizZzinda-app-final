import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:biz_zinda/utils/api_url.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:biz_zinda/model/logged_in_user.dart';


class CreateShopPage extends StatefulWidget {
  const CreateShopPage({super.key});

  @override
  State<CreateShopPage> createState() => _CreateShopPageState();
}

class _CreateShopPageState extends State<CreateShopPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController shopNameController = TextEditingController();
  final TextEditingController ownerNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  bool isActive = true;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    await LoggedInUser.getUserDetails();

    setState(() {
      ownerNameController.text = LoggedInUser.name ?? "";
      phoneController.text = LoggedInUser.phoneNumber ?? "";
      emailController.text = LoggedInUser.email ?? "";
    });
  }

  Future<void> createShop() async {
    if (!_formKey.currentState!.validate()) return;

    EasyLoading.show(status: "Creating shop...");

    try {
      final url = Uri.parse("${AppUrl.baseurl}/api/v1/shop/create");

      final payload = {
        "shopName": shopNameController.text.trim(),
        "ownerName": ownerNameController.text.trim(),
        "mobileNumber": phoneController.text.trim(),
        "email": emailController.text.trim(),
        "address": addressController.text.trim(),
        "category": categoryController.text.trim(),
        "description": descriptionController.text.trim(),
        "latitude": LoggedInUser.lat ?? 0.0,
        "longitude": LoggedInUser.long ?? 0.0,
        "profileImage": "https://cdn.example.com/shop/profile.jpg",
        "coverImage": "https://cdn.example.com/shop/cover.jpg",
        "isActive": isActive,
      };

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${LoggedInUser.accessToken ?? ''}",
        },
        body: jsonEncode(payload),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201 && data["status"] == true) {
        EasyLoading.showSuccess(data["message"]);

        print("✅ Shop ID: ${data["data"]["shopData"]["_id"]}");

        // 👉 navigate if needed
        // context.push('/shop-list');

      } else {
        EasyLoading.showError(data["message"] ?? "Failed");
      }
    } catch (e) {
      EasyLoading.showError("Error: $e");
    } finally {
      EasyLoading.dismiss();
    }
  }

  InputDecoration inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    );
  }

  @override
  void dispose() {
    shopNameController.dispose();
    ownerNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    categoryController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFFFB8C00);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Shop"),
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              /// 🏪 Shop Name
              TextFormField(
                controller: shopNameController,
                style: const TextStyle(color: Colors.black),
                decoration: inputDecoration("Shop Name").copyWith(
                  hintStyle: const TextStyle(color: Colors.grey), // optional
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return "Enter shop name";
                  if (v.length < 3) return "Minimum 3 characters";
                  return null;
                },
              ),
              const SizedBox(height: 12),

              /// 👤 Owner Name
              TextFormField(
                controller: ownerNameController,
                style: const TextStyle(color: Colors.black),
                decoration: inputDecoration("Owner Name").copyWith(
                  hintStyle: const TextStyle(color: Colors.grey), // optional
                ),
                validator: (v) =>
                v == null || v.isEmpty ? "Enter owner name" : null,
              ),
              const SizedBox(height: 12),

              /// 📱 Phone (Readonly)
              TextFormField(
                controller: phoneController,
                readOnly: true,
                style: const TextStyle(color: Colors.black),
                decoration: inputDecoration("Phone Number").copyWith(
                  hintStyle: const TextStyle(color: Colors.grey), // optional
                ),
              ),
              const SizedBox(height: 12),

              /// 📧 Email (Readonly)
              TextFormField(
                controller: emailController,
                readOnly: true,
                style: const TextStyle(color: Colors.black),
                decoration: inputDecoration("Email").copyWith(
                  hintStyle: const TextStyle(color: Colors.grey), // optional
                ),
              ),
              const SizedBox(height: 12),

              /// 📍 Address
              TextFormField(
                controller: addressController,
                style: const TextStyle(color: Colors.black),
                decoration: inputDecoration("Address").copyWith(
                  hintStyle: const TextStyle(color: Colors.grey), // optional
                ),
                validator: (v) =>
                v == null || v.isEmpty ? "Enter address" : null,
              ),
              const SizedBox(height: 12),

              /// 🏷️ Category
              TextFormField(
                controller: categoryController,
                style: const TextStyle(color: Colors.black),
                decoration:
                inputDecoration("Category (Retail, Service...)").copyWith(
                  hintStyle: const TextStyle(color: Colors.grey), // optional
                ),
              ),
              const SizedBox(height: 12),

              /// 📝 Description
              TextFormField(
                controller: descriptionController,
                maxLines: 3,
                style: const TextStyle(color: Colors.black), // 👈 text color
                decoration: inputDecoration("Description").copyWith(
                  hintStyle: const TextStyle(color: Colors.grey), // optional
                ),
              ),
              const SizedBox(height: 12),

              /// 🔘 Active Switch
              SwitchListTile(
                title: const Text("Shop Active"),
                value: isActive,
                onChanged: (val) {
                  setState(() => isActive = val);
                },
              ),

              const SizedBox(height: 20),

              /// 🚀 Create Button
              ElevatedButton(
                onPressed: createShop,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  "Create Store",
                  style: TextStyle(fontSize: 16,color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}