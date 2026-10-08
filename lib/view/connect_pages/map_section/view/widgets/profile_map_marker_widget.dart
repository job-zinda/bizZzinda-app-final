import 'package:flutter/material.dart';
import 'package:biz_zinda/view/store_location/store_model.dart';
import 'package:biz_zinda/widgets/safe_cached_network_image.dart';

/// Triangle pointer pointing downwards from the circular avatar to the map location.
class PinPointerPainter extends CustomPainter {
  final Color color;

  const PinPointerPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ProfileMapMarkerWidget extends StatelessWidget {
  final StoreModel store;
  final String distanceStr;
  final VoidCallback onTap;

  const ProfileMapMarkerWidget({
    super.key,
    required this.store,
    required this.distanceStr,
    required this.onTap,
  });

  static const Color primaryOrange = Color(0xFFFB8C00);

  /// Map common professions or store categories to clean icons
  Widget _buildProfessionIcon(String? profession) {
    if (profession == null || profession.trim().isEmpty) {
      return const Icon(Icons.storefront_rounded,
          size: 11, color: primaryOrange);
    }
    final p = profession.toLowerCase();

    if (p.contains('farm') || p.contains('agri')) {
      return const Icon(Icons.eco_rounded, size: 11, color: Color(0xFF2E7D32));
    } else if (p.contains('doctor') ||
        p.contains('medic') ||
        p.contains('pharm') ||
        p.contains('clinic')) {
      return const Icon(Icons.add_box_rounded,
          size: 11, color: Color(0xFFD32F2F));
    } else if (p.contains('nurse')) {
      return const Icon(Icons.medical_services_rounded,
          size: 11, color: Color(0xFF0288D1));
    } else if (p.contains('teacher') ||
        p.contains('school') ||
        p.contains('tutor') ||
        p.contains('acad')) {
      return const Icon(Icons.school_rounded,
          size: 11, color: Color(0xFF1976D2));
    } else if (p.contains('developer') ||
        p.contains('software') ||
        p.contains('tech') ||
        p.contains('it')) {
      return const Icon(Icons.laptop_chromebook_rounded,
          size: 11, color: Color(0xFF0D47A1));
    } else if (p.contains('engineer') ||
        p.contains('hardware') ||
        p.contains('construct')) {
      return const Icon(Icons.settings_rounded,
          size: 11, color: Color(0xFF455A64));
    } else if (p.contains('tailor') ||
        p.contains('boutique') ||
        p.contains('cloth') ||
        p.contains('textile') ||
        p.contains('fashion')) {
      return const Icon(Icons.content_cut_rounded,
          size: 11, color: Color(0xFF00796B));
    } else if (p.contains('chef') ||
        p.contains('food') ||
        p.contains('restaurant') ||
        p.contains('cafe') ||
        p.contains('bak') ||
        p.contains('hotel')) {
      return const Icon(Icons.restaurant_rounded,
          size: 11, color: Color(0xFFE65100));
    } else if (p.contains('photo') ||
        p.contains('studio') ||
        p.contains('video')) {
      return const Icon(Icons.camera_alt_rounded,
          size: 11, color: Color(0xFF6A1B9A));
    } else if (p.contains('electr')) {
      return const Icon(Icons.bolt_rounded, size: 11, color: Color(0xFFF57F17));
    } else if (p.contains('plumb')) {
      return const Icon(Icons.plumbing_rounded,
          size: 11, color: Color(0xFF0097A7));
    } else if (p.contains('driver') ||
        p.contains('travel') ||
        p.contains('auto') ||
        p.contains('cab')) {
      return const Icon(Icons.directions_car_rounded,
          size: 11, color: Color(0xFF388E3C));
    } else if (p.contains('supermarket') ||
        p.contains('grocery') ||
        p.contains('market') ||
        p.contains('mart')) {
      return const Icon(Icons.shopping_cart_rounded,
          size: 11, color: Color(0xFFE65100));
    }

    return const Icon(Icons.storefront_rounded, size: 11, color: primaryOrange);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 180,
        height: 74,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Details Card Bubble (attached to the right of the avatar)
            Positioned(
              left: 36,
              top: 2,
              bottom: 4,
              right: 0,
              child: Container(
                padding: const EdgeInsets.only(
                    left: 14, right: 8, top: 4, bottom: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: primaryOrange.withValues(alpha: 0.18),
                    width: 0.8,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    // Distance pill (Orange)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 1.5),
                      decoration: BoxDecoration(
                        color: primaryOrange,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.location_on,
                              size: 9, color: Colors.white),
                          const SizedBox(width: 2),
                          Text(
                            distanceStr,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Store / Business Name
                    Text(
                      store.name.isNotEmpty ? store.name : 'Store',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E2022),
                      ),
                    ),
                    // Role / Profession / Category with Icon
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildProfessionIcon(store.profession),
                        const SizedBox(width: 3),
                        Flexible(
                          child: Text(
                            store.profession.trim().isNotEmpty
                                ? store.profession
                                : 'Business',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF555555),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Store Avatar with Orange Ring + Pin Pointer at bottom
            Positioned(
              left: 0,
              top: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: primaryOrange, width: 2.8),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.18),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: SafeCachedNetworkImage(
                        imageUrl: store.profileImageUrl,
                        width: 42,
                        height: 42,
                        fit: BoxFit.cover,
                        memCacheWidth: 150,
                        memCacheHeight: 150,
                      ),
                    ),
                  ),
                  // Pin Pointer triangle pointing to exact coordinate
                  CustomPaint(
                    size: const Size(10, 7),
                    painter: const PinPointerPainter(color: primaryOrange),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
