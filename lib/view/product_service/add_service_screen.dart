import 'dart:io';
import 'package:biz_zinda/model/service_view_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../model/service_model.dart';

class AddServiceScreen extends StatefulWidget {
  final ServiceModel? service;

  const AddServiceScreen({super.key, this.service});

  @override
  State<AddServiceScreen> createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends State<AddServiceScreen> {
  final titleController = TextEditingController();
  final priceController = TextEditingController();
  final durationController = TextEditingController();

  final ImagePicker picker = ImagePicker();

  File? selectedImage;

  @override
  void initState() {
    super.initState();

    if (widget.service != null) {
      titleController.text = widget.service!.title;
      priceController.text = widget.service!.price.toString();
      durationController.text = widget.service!.duration;
    }
  }

  Future<void> pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        selectedImage = File(picked.path);
      });
    }
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final serviceVM = context.read<ServiceViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.service == null ? "Add Service" : "Update Service"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [

            buildTextField(
              controller: titleController,
              hint: "Title",
            ),

            buildTextField(
              controller: priceController,
              hint: "Price",
              keyboardType: TextInputType.number,
            ),

            buildTextField(
              controller: durationController,
              hint: "Duration",
            ),

            const SizedBox(height: 15),

            /// IMAGE
            GestureDetector(
              onTap: pickImage,
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                ),
                child: selectedImage != null
                    ? Image.file(selectedImage!, fit: BoxFit.cover)
                    : widget.service != null
                    ? Image.network(widget.service!.image)
                    : const Center(child: Text("Tap to select image")),
              ),
            ),

            const SizedBox(height: 20),

            /// BUTTON
            ElevatedButton(
              onPressed: () async {
                if (titleController.text.isEmpty ||
                    priceController.text.isEmpty ||
                    durationController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Fill all fields")),
                  );
                  return;
                }

                try {
                  if (widget.service == null) {
                    /// ➕ ADD
                    await serviceVM.addService(
                      context: context, // ✅ MUST ADD THIS
                      title: titleController.text,
                      price: int.parse(priceController.text),
                      duration: durationController.text,
                      imageFile: selectedImage,
                    );

                    await serviceVM.fetchMyServices(); // 🔥 refresh
                  } else {
                    /// ✏️ UPDATE
                    await serviceVM.updateService(
                      id: widget.service!.id.toString(),
                      title: titleController.text,
                      price: int.parse(priceController.text),
                      duration: durationController.text,
                      imageFile: selectedImage,
                    );

                    await serviceVM.fetchMyServices(); // 🔥 refresh
                  }

                  if (!mounted) return;
                  Navigator.pop(context);

                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error: $e")),
                  );
                }
              },
              child: Text(widget.service == null ? "Add Service" : "Update Service"),
            )
          ],
        ),
      ),
    );
  }
}