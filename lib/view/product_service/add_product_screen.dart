import 'dart:io';

import 'package:biz_zinda/model/product_view_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../model/product_model.dart';
import '../../../view_model/file_view_model.dart';

class AddProductScreen extends StatefulWidget {
  final ProductModel? product;
  const AddProductScreen({super.key, this.product});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final ImagePicker picker = ImagePicker();

  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final categoryController = TextEditingController();

  XFile? selectedImage;
  String? uploadedImageUrl;

  @override
  void initState() {
    super.initState();

    if (widget.product != null) {
      nameController.text = widget.product!.name;
      priceController.text = widget.product!.price.toString();
      categoryController.text = widget.product!.category ?? "";
      uploadedImageUrl = widget.product!.image;
    }
  }

  Future<void> pickImage(BuildContext context) async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (pickedFile != null) {
      selectedImage = pickedFile;

      uploadedImageUrl = await context
          .read<FileUploadViewModel>()
          .pickedImageUpload(pickedFile, "product");

      setState(() {});
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
    final vm = context.read<ProductViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? "Add Product" : "Update Product"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [

            buildTextField(
              controller: nameController,
              hint: "Name",
            ),

            buildTextField(
              controller: priceController,
              hint: "Price",
              keyboardType: TextInputType.number,
            ),

            buildTextField(
              controller: categoryController,
              hint: "Category",
            ),

            const SizedBox(height: 15),

            /// IMAGE PICK
            GestureDetector(
              onTap: () => pickImage(context),
              child: Container(
                height: 160,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: uploadedImageUrl != null
                    ? Image.network(uploadedImageUrl!, fit: BoxFit.cover)
                    : const Center(child: Text("Tap to select image")),
              ),
            ),

            const SizedBox(height: 20),

            /// BUTTON
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isEmpty ||
                    priceController.text.isEmpty ||
                    uploadedImageUrl == null ||
                    categoryController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please fill all fields")),
                  );
                  return;
                }

                try {
                  if (widget.product == null) {
                    /// ➕ ADD PRODUCT
                    await vm.addProduct(
                      name: nameController.text,
                      price: int.parse(priceController.text),
                      imageUrl: uploadedImageUrl!,
                      category: categoryController.text,
                    );

                    /// 🔥 IMPORTANT: refresh list
                    await vm.fetchMyProducts();
                  } else {
                    /// ✏️ UPDATE PRODUCT
                    await vm.updateProduct(
                      id: widget.product!.id!,
                      name: nameController.text,
                      price: int.parse(priceController.text),
                      category: categoryController.text,
                      imageFile: selectedImage != null
                          ? File(selectedImage!.path)
                          : null,
                    );

                    /// 🔥 refresh after update
                    await vm.fetchMyProducts();
                  }

                  if (!mounted) return;
                  Navigator.pop(context);

                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error: $e")),
                  );
                }
              },
              child: Text(widget.product == null ? "Add Product" : "Update Product"),
            ),
          ],
        ),
      ),
    );
  }
}

// import 'dart:io';
//
// import 'package:biz_zinda/model/product_view_model.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';
//
// import '../../../model/product_model.dart';
// import '../../../view_model/file_view_model.dart';
//
// class AddProductScreen extends StatefulWidget {
//   final ProductModel? product;
//   const AddProductScreen({super.key, this.product});
//
//   @override
//   State<AddProductScreen> createState() => _AddProductScreenState();
// }
//
// class _AddProductScreenState extends State<AddProductScreen> {
//   final ImagePicker picker = ImagePicker();
//
//   final nameController = TextEditingController();
//   final priceController = TextEditingController();
//   final categoryController = TextEditingController();
//
//   XFile? selectedImage;
//   String? uploadedImageUrl;
//   Widget buildTextField({
//     required TextEditingController controller,
//     required String hint,
//     TextInputType? keyboardType,
//   }) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(10),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 6,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: TextField(
//         controller: controller,
//         keyboardType: keyboardType,
//         style: const TextStyle(
//           color: Colors.black, // ✅ text black
//         ),
//         decoration: InputDecoration(
//           hintText: hint,
//           hintStyle: const TextStyle(color: Colors.grey),
//           border: InputBorder.none,
//           contentPadding: const EdgeInsets.symmetric(
//             horizontal: 15,
//             vertical: 14,
//           ),
//         ),
//       ),
//     );
//   }
//
//   @override
//   void initState() {
//     super.initState();
//
//     if (widget.product != null) {
//       nameController.text = widget.product!.name;
//       priceController.text = widget.product!.price.toString();
//       uploadedImageUrl = widget.product!.image;
//     }
//   }
//
//   Future<void> pickImage(BuildContext context) async {
//     final pickedFile = await picker.pickImage(
//       source: ImageSource.gallery,
//       imageQuality: 70,
//     );
//
//     if (pickedFile != null) {
//       selectedImage = pickedFile;
//
//       uploadedImageUrl = await context
//           .read<FileUploadViewModel>()
//           .pickedImageUpload(pickedFile, "product");
//
//       setState(() {});
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final vm = context.read<ProductViewModel>();
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.product == null ? "Add Product" : "Update Product"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(15),
//         child: Column(
//           children: [
//
//             buildTextField(
//               controller: nameController,
//               hint: "Name",
//             ),
//
//             buildTextField(
//               controller: priceController,
//               hint: "Price",
//               keyboardType: TextInputType.number,
//             ),
//
//             buildTextField(
//               controller: categoryController,
//               hint: "Category",
//             ),
//
//
//             const SizedBox(height: 15),
//
//             /// IMAGE
//             GestureDetector(
//               onTap: () => pickImage(context),
//               child: Container(
//                 height: 160,
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.grey),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: uploadedImageUrl != null
//                     ? Image.network(uploadedImageUrl!, fit: BoxFit.cover)
//                     : const Center(child: Text("Tap to select image")),
//               ),
//             ),
//
//             const SizedBox(height: 20),
//
//             ElevatedButton(
//               onPressed: () async {
//                 if (nameController.text.isEmpty ||
//                     priceController.text.isEmpty ||
//                     uploadedImageUrl == null) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text("Please fill all fields")),
//                   );
//                   return;
//                 }
//
//                 if (widget.product == null) {
//                   /// ➕ ADD
//                   vm.addProduct(
//                     name: nameController.text,
//                     price: int.parse(priceController.text),
//                     imageUrl: uploadedImageUrl!,
//                     category: categoryController.text,
//
//                   );
//                 } else {
//                   /// ✏️ UPDATE
//                   await vm.updateProduct(
//                     id: widget.product!.id!,
//                     name: nameController.text,
//                     price: int.parse(priceController.text),
//                     category: categoryController.text,
//                     imageFile: selectedImage != null ? File(selectedImage!.path) : null,
//                   );
//                 }
//
//                 Navigator.pop(context);
//               },
//               child: Text(widget.product == null ? "Add Product" : "Update Product"),
//             ),
//           ],
//         ),
//       ),
//
//     );
//   }
// }