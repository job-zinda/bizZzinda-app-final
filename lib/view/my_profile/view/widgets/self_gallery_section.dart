
import 'dart:io';

import 'package:biz_zinda/model/product_view_model.dart';
import 'package:biz_zinda/model/service_view_model.dart';
import 'package:biz_zinda/view/product_service/add_product_screen.dart';
import 'package:biz_zinda/view/product_service/add_service_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelfGallerySection extends StatefulWidget {

  final bool isOtherUser;

  const SelfGallerySection({
    super.key,
    this.isOtherUser = false,
  });

  @override
  State<SelfGallerySection> createState() =>
      _SelfGallerySectionState();
}

class _SelfGallerySectionState
    extends State<SelfGallerySection>
    with SingleTickerProviderStateMixin {

  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: 2,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [

        /// 🔹 TABS
        TabBar(
          controller: _tabController,
          labelColor: const Color(0xFFFB8C00),
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color(0xFFFB8C00),
          tabs: const [
            Tab(text: "Products"),
            Tab(text: "Services"),
          ],
        ),

        const SizedBox(height: 10),

        /// 🔹 CONTENT
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: TabBarView(
            controller: _tabController,
            children: [
              buildProducts(),
              buildServices(),
            ],
          ),
        ),
      ],
    );
  }

  // =========================================================
  // 🛍 PRODUCTS
  // =========================================================

  Widget buildProducts() {

    final productVM =
    context.watch<ProductViewModel>();

    final products = widget.isOtherUser
        ? productVM.otherUserProducts
        : productVM.products;

    return Column(
      children: [

        /// 🔹 ADD BUTTON
        if (!widget.isOtherUser)
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Row(
              mainAxisAlignment:
              MainAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFFB8C00),
                    shape: BoxShape.circle,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.add,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              AddProductScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

        /// 🔹 GRID
        Expanded(
          child: products.isEmpty
              ? const Center(
            child: Text("No Products"),
          )
              : GridView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: products.length,
            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.75,
            ),
            itemBuilder: (context, index) {

              final item = products[index];

              return Stack(
                children: [

                  /// 🔹 CARD
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [

                        /// IMAGE
                        ClipRRect(
                          borderRadius:
                          const BorderRadius.vertical(
                            top: Radius.circular(10),
                          ),
                          child: Image.network(
                            item.image,
                            height: 160,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),

                        /// TEXT
                        Padding(
                          padding:
                          const EdgeInsets.all(6),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [

                              /// NAME
                              Text(
                                item.name,
                                maxLines: 1,
                                overflow:
                                TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight:
                                  FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),

                              /// CATEGORY
                              Text(
                                item.category ??
                                    "No Category",
                                maxLines: 1,
                                overflow:
                                TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),

                              /// PRICE
                              Text(
                                "₹${item.price}",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// 🔹 EDIT DELETE
                  if (!widget.isOtherUser)
                    Positioned(
                      right: 5,
                      top: 5,
                      child:
                      PopupMenuButton<String>(

                        icon: Container(
                          decoration:
                          const BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                          padding:
                          const EdgeInsets.all(6),
                          child: const Icon(
                            Icons.more_vert,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),

                        onSelected: (value) {

                          if (value == "edit") {

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    AddProductScreen(
                                      product: item,
                                    ),
                              ),
                            );

                          } else if (value ==
                              "delete") {

                            productVM.deleteProduct(
                              item.id!,
                            );
                          }
                        },

                        itemBuilder: (context) =>
                        const [

                          PopupMenuItem(
                            value: "edit",
                            child: Text("Edit"),
                          ),

                          PopupMenuItem(
                            value: "delete",
                            child: Text("Delete"),
                          ),
                        ],
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  // =========================================================
  // 🛠 SERVICES
  // =========================================================

  Widget buildServices() {

    final serviceVM =
    context.watch<ServiceViewModel>();

    final services = widget.isOtherUser
        ? serviceVM.otherUserServices
        : serviceVM.services;

    return Column(
      children: [

        /// 🔹 ADD BUTTON
        if (!widget.isOtherUser)
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Row(
              mainAxisAlignment:
              MainAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFFB8C00),
                    shape: BoxShape.circle,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.add,
                      color: Colors.black,
                    ),
                    onPressed: () async {

                      final result =
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              AddServiceScreen(),
                        ),
                      );

                      if (result == true) {
                        context
                            .read<ServiceViewModel>()
                            .fetchMyServices();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),

        /// 🔹 GRID
        Expanded(
          child: services.isEmpty
              ? const Center(
            child: Text("No Services"),
          )
              : GridView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: services.length,
            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.75,
            ),
            itemBuilder: (context, index) {

              final item = services[index];

              return Stack(
                children: [

                  /// 🔹 CARD
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [

                        /// IMAGE
                        Expanded(
                          flex: 3,
                          child: ClipRRect(
                            borderRadius:
                            const BorderRadius.vertical(
                              top: Radius.circular(10),
                            ),
                            child: item.image
                                .startsWith("http")
                                ? Image.network(
                              item.image,
                              width:
                              double.infinity,
                              fit: BoxFit.cover,
                            )
                                : Image.file(
                              File(item.image),
                              width:
                              double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        /// TEXT
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding:
                            const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: [

                                Text(
                                  item.title,
                                  maxLines: 1,
                                  overflow:
                                  TextOverflow.ellipsis,
                                  style:
                                  const TextStyle(
                                    fontWeight:
                                    FontWeight.bold,
                                    color:
                                    Colors.black,
                                  ),
                                ),

                                const SizedBox(
                                  height: 2,
                                ),

                                Text(
                                  "₹${item.price}",
                                  style:
                                  const TextStyle(
                                    color:
                                    Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// 🔹 EDIT DELETE
                  if (!widget.isOtherUser)
                    Positioned(
                      right: 5,
                      top: 5,
                      child:
                      PopupMenuButton<String>(

                        icon: Container(
                          decoration:
                          const BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                          padding:
                          const EdgeInsets.all(6),
                          child: const Icon(
                            Icons.more_vert,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),

                        onSelected: (value) {

                          if (value == "edit") {

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    AddServiceScreen(
                                      service: item,
                                    ),
                              ),
                            );

                          } else if (value ==
                              "delete") {

                            serviceVM.deleteService(
                              item.id!,
                            );
                          }
                        },

                        itemBuilder: (context) =>
                        const [

                          PopupMenuItem(
                            value: "edit",
                            child: Text("Edit"),
                          ),

                          PopupMenuItem(
                            value: "delete",
                            child: Text("Delete"),
                          ),
                        ],
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}


// import 'dart:io';
//
// import 'package:biz_zinda/model/product_view_model.dart';
// import 'package:biz_zinda/model/service_view_model.dart';
// import 'package:biz_zinda/view/product_service/add_product_screen.dart';
// import 'package:biz_zinda/view/product_service/add_service_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
// import 'package:biz_zinda/model/post_model.dart';
// import 'package:biz_zinda/view/my_profile/view/widgets/single_gallery_widget.dart';
// import 'package:provider/provider.dart';
//
// import '../../../../view_model/post_view_model.dart';
// import '../../../../view_model/profile_view_model.dart';
//
// class SelfGallerySection extends StatefulWidget {
//   const SelfGallerySection({super.key});
//
//   @override
//   State<SelfGallerySection> createState() => _SelfGallerySectionState();
// }
//
// class _SelfGallerySectionState extends State<SelfGallerySection>
//     with SingleTickerProviderStateMixin {
//
//   late TabController _tabController;
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//     Future.microtask(() {
//       final productVM = context.watch<ProductViewModel>();
//       final serviceVM = context.watch<ServiceViewModel>();
//     });
//   }
//
//   @override
//   void dispose() {
//     _tabController.dispose(); // ✅ IMPORTANT
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//
//         /// 🔹 TABS
//         TabBar(
//           controller: _tabController,
//           labelColor: const Color(0xFFFB8C00),
//           unselectedLabelColor: Colors.grey,
//           indicatorColor: const Color(0xFFFB8C00),
//           tabs: const [
//             // Tab(text: "Posts"),
//             Tab(text: "Products"),
//             Tab(text: "Services"),
//           ],
//         ),
//
//         const SizedBox(height: 10),
//
//         /// 🔹 CONTENT
//         SizedBox(
//           height: MediaQuery.of(context).size.height * 0.6,
//           child: TabBarView(
//             controller: _tabController,
//             children: [
//               // buildPosts(),
//               buildProducts(),
//               buildServices(),
//             ],
//           ),
//         )
//       ],
//     );
//   }
//
//   // =========================================================
//   // 🔥 POSTS (PAGINATION)
//   // =========================================================
//   // Widget buildPosts() {
//   //   final postVM = context.watch<PostViewModel>();
//   //
//   //   return PagedGridView<int, PostModel>(
//   //     pagingController: postVM.selfPostController,
//   //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//   //       crossAxisCount: 3,
//   //       crossAxisSpacing: 4,
//   //       mainAxisSpacing: 4,
//   //     ),
//   //     builderDelegate: PagedChildBuilderDelegate<PostModel>(
//   //       itemBuilder: (context, item, index) {
//   //         return SingleGalleryWidget(postModel: item);
//   //       },
//   //       firstPageProgressIndicatorBuilder: (_) =>
//   //       const Center(child: CircularProgressIndicator()),
//   //       noItemsFoundIndicatorBuilder: (_) =>
//   //       const Center(child: Text("No Posts")),
//   //     ),
//   //   );
//   // }
//
//   // =========================================================
//   // 🛍 PRODUCTS
//   // =========================================================
//   Widget buildProducts() {
//     final productVM = context.watch<ProductViewModel>();
//
//     return Column(
//       children: [
//
//         /// 🔹 ADD BUTTON
//         Padding(
//           padding: const EdgeInsets.only(right: 10),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               Container(
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFFB8C00), // 🟠 orange background
//                   shape: BoxShape.circle,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black26,
//                       blurRadius: 6,
//                       offset: Offset(0, 3),
//                     ),
//                   ],
//                 ),
//                 child: IconButton(
//                   icon: const Icon(
//                     Icons.add,
//                     color: Colors.black, // ⚫ black icon
//                   ),
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => AddProductScreen(),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//
//         /// 🔹 GRID
//         Expanded(
//           child: productVM.products.isEmpty
//               ? const Center(child: Text("No Products"))
//               : GridView.builder(
//             shrinkWrap: true, // ✅ FIX
//             physics: const NeverScrollableScrollPhysics(),
//             padding: const EdgeInsets.all(10),
//             itemCount: productVM.products.length,
//             gridDelegate:
//             const SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 2,
//               crossAxisSpacing: 10,
//               mainAxisSpacing: 10,
//               childAspectRatio: 0.75,
//             ),
//             itemBuilder: (context, index) {
//               final item = productVM.products[index];
//
//               return Stack(
//                 children: [
//
//                   /// CARD
//                   Card(
//                     elevation: 3,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//
//                         /// 🔥 IMAGE
//                         ClipRRect(
//                           borderRadius: const BorderRadius.vertical(
//                             top: Radius.circular(10),
//                           ),
//                           child: Image.network(
//                             item.image,
//                             height: 160, // 👈 adjust here
//                             width: double.infinity,
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//
//                         /// 🔽 TEXT
//                         Padding(
//                           padding: const EdgeInsets.all(6), // 👈 reduced padding
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//
//                               /// NAME
//                               Text(
//                                 item.name,
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis,
//                                 style: const TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.black,
//                                 ),
//                               ),
//
//                               /// CATEGORY
//                               Text(
//                                 item.category ?? "No Category",
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis,
//                                 style: const TextStyle(
//                                   fontSize: 11, // 👈 slightly smaller
//                                   color: Colors.grey,
//                                 ),
//                               ),
//
//                               /// PRICE
//                               Text(
//                                 "₹${item.price}",
//                                 style: const TextStyle(
//                                   fontSize: 12,
//                                   color: Colors.black54,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   /// 🔥 EDIT + DELETE
//                   Positioned(
//                     right: 5,
//                     top: 5,
//                     child: PopupMenuButton<String>(
//                       icon: Container(
//                         decoration: const BoxDecoration(
//                           color: Colors.black, // 🔵 black circle
//                           shape: BoxShape.circle,
//                         ),
//                         padding: const EdgeInsets.all(6),
//                         child: const Icon(
//                           Icons.more_vert,
//                           color: Colors.white, // ⚪ white dots
//                           size: 18,
//                         ),
//                       ),
//
//                       onSelected: (value) {
//                         if (value == "edit") {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (_) =>
//                                   AddProductScreen(product: item),
//
//                             ),
//                           );
//                         } else if (value == "delete") {
//                           productVM.deleteProduct(item.id!); // ✅ FIXED
//                         }
//                       },
//
//                       itemBuilder: (context) => const [
//                         PopupMenuItem(
//                           value: "edit",
//                           child: Row(
//                             children: [
//                               Icon(Icons.edit,
//                                   size: 18, color: Colors.blue),
//                               SizedBox(width: 8),
//                               Text("Edit"),
//                             ],
//                           ),
//                         ),
//                         PopupMenuItem(
//                           value: "delete",
//                           child: Row(
//                             children: [
//                               Icon(Icons.delete,
//                                   size: 18, color: Colors.red),
//                               SizedBox(width: 8),
//                               Text("Delete"),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   )
//                 ],
//               );
//             },
//           ),
//         )
//       ],
//     );
//   }
//
//   // =========================================================
//   // 🛠 SERVICES
//   // =========================================================
//   Widget buildServices() {
//     final serviceVM = context.watch<ServiceViewModel>(); // ✅ FIX
//
//     return Column(
//       children: [
//
//         /// 🔹 ADD BUTTON
//         Padding(
//           padding: const EdgeInsets.only(right: 10),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               Container(
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFFB8C00),
//                   shape: BoxShape.circle,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black26,
//                       blurRadius: 6,
//                       offset: Offset(0, 3),
//                     ),
//                   ],
//                 ),
//                 child: IconButton(
//                   icon: const Icon(
//                     Icons.add,
//                     color: Colors.black,
//                   ),
//                   onPressed: ()async {
//                     final result = await Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => AddServiceScreen(),
//                       ),
//                     );
//
//                     if (result == true) {
//                       context.read<ServiceViewModel>().fetchMyServices();
//                     }
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//
//         /// 🔹 GRID
//         Expanded(
//           child: serviceVM.services.isEmpty
//               ? const Center(child: Text("No Services"))
//               : GridView.builder(
//             shrinkWrap: true, // ✅ FIX
//             physics: const NeverScrollableScrollPhysics(),
//             padding: const EdgeInsets.all(10),
//             itemCount: serviceVM.services.length,
//             gridDelegate:
//             const SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 2,
//               crossAxisSpacing: 10,
//               mainAxisSpacing: 10,
//               childAspectRatio: 0.75,
//             ),
//             itemBuilder: (context, index) {
//               final item = serviceVM.services[index];
//
//               return Stack(
//                 children: [
//
//                   /// CARD
//                   Card(
//                     elevation: 3,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//
//                         /// 🔥 IMAGE (75%)
//                         Expanded(
//                           flex: 3,
//                           child: ClipRRect(
//                             borderRadius: const BorderRadius.vertical(
//                               top: Radius.circular(10),
//                             ),
//                             child: item.image.startsWith("http")
//                                 ? Image.network(
//                               item.image,
//                               width: double.infinity,
//                               fit: BoxFit.cover,
//                               errorBuilder: (_, __, ___) =>
//                               const Icon(Icons.broken_image),
//                             )
//                                 : Image.file(
//                               File(item.image),
//                               width: double.infinity,
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         ),
//
//                         /// 🔽 TEXT (25%)
//                         Expanded(
//                           flex: 1,
//                           child: Padding(
//                             padding: const EdgeInsets.all(8),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//
//                                 /// TITLE
//                                 Text(
//                                   item.title,
//                                   maxLines: 1,
//                                   overflow: TextOverflow.ellipsis,
//                                   style: const TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.black
//                                   ),
//                                 ),
//
//                                 const SizedBox(height: 1),
//
//                                 /// PRICE
//                                 Text(
//                                   "₹${item.price}",
//                                   style: const TextStyle(color: Colors.black54),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   /// 🔥 EDIT + DELETE
//                   Positioned(
//                     top: 5,
//                     right: 5,
//                     child: PopupMenuButton<String>(
//                       icon: Container(
//                         decoration: const BoxDecoration(
//                           color: Colors.black, // 🔵 black circle
//                           shape: BoxShape.circle,
//                         ),
//                         padding: const EdgeInsets.all(6),
//                         child: const Icon(
//                           Icons.more_vert,
//                           color: Colors.white, // ⚪ white dots
//                           size: 18,
//                         ),
//                       ),
//
//                       onSelected: (value) {
//                         if (value == "edit") {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (_) =>
//                                   AddServiceScreen(service: item),
//                             ),
//                           );
//                         } else if (value == "delete") {
//                           serviceVM.deleteService(item.id!.toString()); // ✅ FIX
//                         }
//                       },
//
//                       itemBuilder: (context) => const [
//                         PopupMenuItem(
//                           value: "edit",
//                           child: Row(
//                             children: [
//                               Icon(Icons.edit,
//                                   size: 18, color: Colors.blue),
//                               SizedBox(width: 8),
//                               Text("Edit"),
//                             ],
//                           ),
//                         ),
//                         PopupMenuItem(
//                           value: "delete",
//                           child: Row(
//                             children: [
//                               Icon(Icons.delete,
//                                   size: 18, color: Colors.red),
//                               SizedBox(width: 8),
//                               Text("Delete"),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   )
//                 ],
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }