import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:biz_zinda/Settings/until/PColors.dart';
import 'package:biz_zinda/Settings/until/PSvgs.dart';
import 'package:biz_zinda/view/upload_pages/view/ui.dart';
import 'package:biz_zinda/view_model/connect_page_view_model.dart';
import 'package:biz_zinda/view_model/profile_view_model.dart';
import 'package:provider/provider.dart';

// class BottomNavBar extends StatelessWidget {
//   final StatefulNavigationShell navigationShell;
//
//   const BottomNavBar({super.key, required this.navigationShell});
//
//   void _onTap(int index) {
//     navigationShell.goBranch(
//       index,
//       initialLocation: index == navigationShell.currentIndex,
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BottomAppBar(
//       padding: EdgeInsets.zero,
//       height: 110,
//       clipBehavior: Clip.hardEdge,
//       shadowColor: PColors.white,
//       color:  Color(0xFF8A4FFF),
//       child: Container(
//         decoration: BoxDecoration(
//             color:  Color(0xFF8A4FFF),
//             border: Border(
//                 top: BorderSide(color: PColors.white.withOpacity(0.3)))),
//         child: Padding(
//           padding: const EdgeInsets.all(17),
//           child: Align(
//             alignment: Alignment.bottomCenter,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 bottombaritem(
//                     icon: PSvgs.home,
//                     label: "Home",
//                     fun: () => _onTap(0),
//                     selected: navigationShell.currentIndex == 0),
//                 bottombaritem(
//                     icon: PSvgs.search,
//                     label: "Search",
//                     fun: () => _onTap(1),
//                     selected: navigationShell.currentIndex == 1),
//                 bottombaritem(
//                     icon: PSvgs.upload,
//                     label: "Upload",
//                     fun: () => _handleUpload(context),
//                     selected: false), // Upload is a bottom sheet, not a route
//                 bottombaritem(
//                     icon: PSvgs.connect,
//                     label: "Connection",
//                     fun: () => _handleConnection(context),
//                     selected: navigationShell.currentIndex == 2),
//                 bottombaritem(
//                     icon: PSvgs.profile,
//                     label: "Profile",
//                     fun: () => _onTap(3),
//                     selected: navigationShell.currentIndex == 3),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _handleUpload(BuildContext context) {
//     final profileVM = context.read<ProfileViewModel>();
//     final profileTypeRaw = profileVM.profileModel?.accountType ?? '';
//     final profileType = profileTypeRaw.trim().toLowerCase();
//     debugPrint('[BottomNav] Upload tapped. accountType="$profileTypeRaw" (normal=$profileType)');
//     // Block only if accountType is "normal" or empty; allow freelancer and premium.
//     if (profileType.isEmpty || profileType == "normal") {
//       _onTap(3); // Go to profile tab which shows PlanUi for normal users
//     } else {
//       openBottomseet(context);
//     }
//   }
//
//   void _handleConnection(BuildContext context) {
//     // Navigate to the Connect tab immediately for better UX.
//     _onTap(2);
//
//     // Fetch latest profile/location data in the background.
//     // Ignore any errors here; Connect page will display placeholders or retry.
//     () async {
//       final profileVM = context.read<ProfileViewModel>();
//       await profileVM.fetchProfile();
//       if (profileVM.profileModel?.lat != null &&
//           profileVM.profileModel?.lng != null) {
//         final connectVM = context.read<ConnectPageViewModel>();
//         connectVM.updateLocation(
//             profileVM.profileModel!.lat!, profileVM.profileModel!.lng!);
//         connectVM.fetchNearestProfiles();
//       }
//     }();
//   }
//
//   Widget bottombaritem(
//       {required String label,
//         required String icon,
//         required Function()? fun,
//         required bool selected}) {
//     return GestureDetector(
//       onTap: fun,
//       child: Container(
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               children: [
//                 SvgPicture.asset(
//                   icon,
//                   height: label == 'Upload' ? 50 : 24,
//                 ),
//                 const SizedBox(
//                   height: 9,
//                 ),
//                 label == 'Upload'
//                     ? Container()
//                     : Container(
//                   color: selected ? PColors.white : Colors.transparent,
//                   height: 2,
//                   width: 40,
//                 )
//               ],
//             ),
//           )),
//     );
//   }
//
//   void openBottomseet(BuildContext context) {
//     showModalBottomSheet(
//       shape: const BeveledRectangleBorder(),
//       backgroundColor: PColors.white,
//       context: context,
//       builder: (context) => const UploadPagesUi(),
//     );
//   }
// }
class BottomNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const BottomNavBar({super.key, required this.navigationShell});

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.orange.shade100,

        /// border
        border: Border.all(
          color: const Color(0xFFFB8C00).withOpacity(.25),
        ),

        borderRadius: BorderRadius.circular(30),

        /// shadow
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.10),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [

          _item(
            icon: Icons.home,
            selected: navigationShell.currentIndex == 0,
            onTap: () => _onTap(0),
          ),

          _item(
            icon: Icons.search,
            selected: navigationShell.currentIndex == 1,
            onTap: () => _onTap(1),
          ),

          /// Upload Button
          GestureDetector(
            onTap: () => _handleUpload(context),
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFFB8C00),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFB8C00).withOpacity(.4),
                    blurRadius: 8,
                  )
                ],
              ),
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),

          _item(
            icon: Icons.location_on_outlined,
            selected: navigationShell.currentIndex == 2,
            onTap: () => _handleConnection(context),
          ),

          /// Profile
          _item(
            icon: Icons.store,
            selected: navigationShell.currentIndex == 3,
            onTap: () => _onTap(3),
          ),
        ],
      ),
    );
  }

  Widget _item({
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          size: 22,
          color: selected
              ? const Color(0xFFFB8C00)
              : Colors.black54,
        ),
      ),
    );
  }

  void _handleUpload(BuildContext context) {
    final profileVM = context.read<ProfileViewModel>();
    final profileType =
    (profileVM.profileModel?.accountType ?? '').trim().toLowerCase();

    if (profileType.isEmpty || profileType == "normal") {
      _onTap(3);
    } else {
      openBottomseet(context);
    }
  }
  void _handleConnection(BuildContext context) async {
    _onTap(2);

    final profileVM = context.read<ProfileViewModel>();
    await profileVM.fetchProfile();

    if (profileVM.profileModel?.lat != null &&
        profileVM.profileModel?.lng != null) {

      final connectVM = context.read<ConnectPageViewModel>();

      connectVM.updateLocation(
        profileVM.profileModel!.lat!,
        profileVM.profileModel!.lng!,
      );
    }
  }

  // void _handleConnection(BuildContext context) {
  //   _onTap(2);
  //
  //   () async {
  //     final profileVM = context.read<ProfileViewModel>();
  //     await profileVM.fetchProfile();
  //
  //     if (profileVM.profileModel?.lat != null &&
  //         profileVM.profileModel?.lng != null) {
  //
  //       final connectVM = context.read<ConnectPageViewModel>();
  //
  //       connectVM.updateLocation(
  //           profileVM.profileModel!.lat!,
  //           profileVM.profileModel!.lng!);
  //
  //       connectVM.fetchNearestStores();
  //     }
  //   }();
  // }

  void openBottomseet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      builder: (context) => const UploadPagesUi(),
    );
  }
}