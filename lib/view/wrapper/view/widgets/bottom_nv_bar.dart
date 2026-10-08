import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:biz_zinda/view/upload_pages/view/ui.dart';
import 'package:biz_zinda/view_model/connect_page_view_model.dart';
import 'package:biz_zinda/view_model/profile_view_model.dart';
import 'package:biz_zinda/utils/guest_helper.dart';
import 'package:biz_zinda/model/logged_in_user.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

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
    return SafeArea(
      top: false,
      child: Container(
        height: 76,
        margin: const EdgeInsets.only(left: 14, right: 14, bottom: 8),
        child: Stack(
          alignment: Alignment.topCenter,
          clipBehavior: Clip.none,
          children: [
            // White floating pill with arched center notch
            Positioned.fill(
              child: CustomPaint(
                painter: _NavBarCustomPainter(),
              ),
            ),

            // Tab items row (Home, Search, [Gap], Map, Profile)
            Positioned(
              top: 16,
              left: 0,
              right: 0,
              bottom: 0,
              child: Row(
                children: [
                  Expanded(
                    child: _item(
                      icon: Icons.home_rounded,
                      label: "Home",
                      selected: navigationShell.currentIndex == 0,
                      onTap: () => _onTap(0),
                    ),
                  ),
                  Expanded(
                    child: _item(
                      icon: Icons.search_rounded,
                      label: "Search",
                      selected: navigationShell.currentIndex == 1,
                      onTap: () => _onTap(1),
                    ),
                  ),
                  const SizedBox(width: 58), // Space reserved for center button
                  Expanded(
                    child: _item(
                      icon: Icons.location_on_rounded,
                      label: "Map",
                      selected: navigationShell.currentIndex == 2,
                      onTap: () => _handleConnection(context),
                    ),
                  ),
                  Expanded(
                    child: _item(
                      icon: Icons.person_rounded,
                      label: "Profile",
                      selected: navigationShell.currentIndex == 3,
                      onTap: () {
                        if (isGuestUser(context)) return;
                        _onTap(3);
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Elevated Center (+) Upload Button
            Positioned(
              top: 5,
              child: GestureDetector(
                onTap: () {
                  if (isGuestUser(context)) return;
                  _handleUpload(context);
                },
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFB8C00),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFB8C00).withValues(alpha: 0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.add_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _item({
    required IconData icon,
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    const activeColor = Color(0xFFFB8C00);
    const inactiveColor = Color(0xFF4A5568);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 22,
            color: selected ? activeColor : inactiveColor,
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
              color: selected ? activeColor : inactiveColor,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 3),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 2.5,
            width: selected ? 22 : 0,
            decoration: BoxDecoration(
              color: selected ? activeColor : Colors.transparent,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
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

    if (LoggedInUser.isGuest) {
      await _useDeviceLocation(context);
      return;
    }

    final profileVM = context.read<ProfileViewModel>();
    await profileVM.fetchProfile();
    if (!context.mounted) return;

    if (profileVM.profileModel?.lat != null &&
        profileVM.profileModel?.lng != null) {
      final connectVM = context.read<ConnectPageViewModel>();

      connectVM.updateLocation(
        profileVM.profileModel!.lat!,
        profileVM.profileModel!.lng!,
      );
    }
  }

  Future<void> _useDeviceLocation(BuildContext context) async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return;
      }
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.medium),
      );
      if (!context.mounted) return;
      context
          .read<ConnectPageViewModel>()
          .updateLocation(position.latitude, position.longitude);
    } catch (e) {
      debugPrint('[_useDeviceLocation] Error getting location: $e');
    }
  }

  void openBottomseet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      builder: (context) => const UploadPagesUi(),
    );
  }
}

class _NavBarCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    const top = 16.0;
    final bottom = size.height;
    final r = (bottom - top) / 2; // Pill radius = 30
    final cx = size.width / 2;
    const domeR = 29.0;
    const transitionW = 14.0;

    // Start at top straight line right after top-left rounded corner
    path.moveTo(r, top);

    // Line to left start of dome
    path.lineTo(cx - domeR - transitionW, top);

    // Smooth curve up to the dome apex
    path.cubicTo(
      cx - domeR, top,
      cx - domeR + 4, 1.5,
      cx, 1.5,
    );

    // Smooth curve down to right side of dome
    path.cubicTo(
      cx + domeR - 4, 1.5,
      cx + domeR, top,
      cx + domeR + transitionW, top,
    );

    // Line to top-right corner
    path.lineTo(size.width - r, top);

    // Right rounded cap
    path.arcToPoint(
      Offset(size.width - r, bottom),
      radius: Radius.circular(r),
      clockwise: true,
    );

    // Bottom straight line
    path.lineTo(r, bottom);

    // Left rounded cap
    path.arcToPoint(
      Offset(r, top),
      radius: Radius.circular(r),
      clockwise: true,
    );
    path.close();

    // 1. Soft Shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.08)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    canvas.drawPath(path.shift(const Offset(0, 3)), shadowPaint);

    // 2. White Fill
    final fillPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, fillPaint);

    // 3. Subtle Border with brand orange accent
    final borderPaint = Paint()
      ..color = const Color(0xFFFB8C00).withValues(alpha: 0.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}