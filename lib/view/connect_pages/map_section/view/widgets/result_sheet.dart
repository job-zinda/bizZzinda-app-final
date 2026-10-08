import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:biz_zinda/Settings/until/PPages.dart';
import 'package:biz_zinda/view/other_user_profile/view/other_user_profile_screen.dart';
import 'package:biz_zinda/view/store_location/store_model.dart';
import 'package:biz_zinda/view_model/connect_page_view_model.dart';
import 'package:biz_zinda/widgets/safe_cached_network_image.dart';
import 'package:provider/provider.dart';

class ResultSheetUi extends StatelessWidget {
  const ResultSheetUi({super.key});

  static const Color primaryOrange = Color(0xFFFB8C00);

  String _calculateDistance(
    double? userLat,
    double? userLng,
    double? targetLat,
    double? targetLng,
  ) {
    if (userLat == null ||
        userLng == null ||
        targetLat == null ||
        targetLng == null ||
        (targetLat == 0 && targetLng == 0)) {
      return '';
    }
    final double distanceInMeters =
        Geolocator.distanceBetween(userLat, userLng, targetLat, targetLng);
    final double distanceInKm = distanceInMeters / 1000;
    if (distanceInKm < 1) {
      return '${(distanceInKm * 1000).round()} m away';
    }
    return '${distanceInKm.round()} km away';
  }

  void _showCustomDistanceDialog(
      BuildContext context, ConnectPageViewModel vm) {
    final textController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            "Custom Search Distance",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Enter radius in kilometers:",
                style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: textController,
                keyboardType: TextInputType.number,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: "e.g. 50, 100, 200",
                  suffixText: "Km",
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: primaryOrange, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              // Preset chips
              Wrap(
                spacing: 8,
                children: ["50", "100", "200"].map((preset) {
                  return ActionChip(
                    label: Text("${preset}Km"),
                    backgroundColor: const Color(0xFFF3F4F6),
                    labelStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF374151),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: const BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      vm.updateDistanceInKm(preset);
                    },
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryOrange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                final text = textController.text.trim();
                final val = int.tryParse(text);
                if (val != null && val > 0) {
                  Navigator.of(ctx).pop();
                  vm.updateDistanceInKm(val.toString());
                }
              },
              child: const Text("Apply", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final connectPageViewModel = context.watch<ConnectPageViewModel>();
    final List<StoreModel> stores = connectPageViewModel.nearestStores;
    final List<String> chips = ["All", "10", "20", "30", "Custom"];

    return DraggableScrollableSheet(
      initialChildSize: 0.65,
      minChildSize: 0.35,
      maxChildSize: 0.92,
      expand: false,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 15,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            children: [
              // Drag Handle
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 8),
                width: 44,
                height: 4.5,
                decoration: BoxDecoration(
                  color: const Color(0xFFD1D5DB),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),

              // Header Row
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: primaryOrange.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.storefront_rounded,
                        color: primaryOrange,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Available Stores",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1E2022),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            stores.isEmpty
                                ? "No stores found"
                                : "${stores.length} store${stores.length > 1 ? 's' : ''} available",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: stores.isEmpty
                                  ? const Color(0xFFE53935)
                                  : const Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Filter Button
                    GestureDetector(
                      onTap: () {
                        context.pushNamed(PPages.freelancerFilterPageUi);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.tune_rounded,
                          color: Color(0xFF4B5563),
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Close Button
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F4F6),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close_rounded,
                          color: Color(0xFF6B7280),
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Radius Chips Row inside Sheet
              Container(
                height: 38,
                margin:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: chips.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 6),
                  itemBuilder: (context, index) {
                    final item = chips[index];
                    final bool isCustom = item == "Custom";
                    final bool isCurrentCustom = isCustom &&
                        connectPageViewModel.distanceInKm != "All" &&
                        connectPageViewModel.distanceInKm != "10" &&
                        connectPageViewModel.distanceInKm != "20" &&
                        connectPageViewModel.distanceInKm != "30";
                    final bool isSelected =
                        connectPageViewModel.distanceInKm == item ||
                            isCurrentCustom;

                    String label;
                    if (item == "All") {
                      label = "All";
                    } else if (isCustom) {
                      label = isCurrentCustom
                          ? "${connectPageViewModel.distanceInKm}Km"
                          : "Custom";
                    } else {
                      label = "${item}Km";
                    }

                    return GestureDetector(
                      onTap: () {
                        if (isCustom) {
                          _showCustomDistanceDialog(
                              context, connectPageViewModel);
                        } else {
                          connectPageViewModel.updateDistanceInKm(item);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? primaryOrange
                              : const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(18),
                          border: isSelected
                              ? null
                              : Border.all(color: const Color(0xFFE5E7EB)),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (isCustom && !isCurrentCustom) ...[
                                Icon(
                                  Icons.tune,
                                  size: 13,
                                  color: isSelected
                                      ? Colors.white
                                      : const Color(0xFF4B5563),
                                ),
                                const SizedBox(width: 4),
                              ],
                              Text(
                                label,
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  color: isSelected
                                      ? Colors.white
                                      : const Color(0xFF4B5563),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const Divider(color: Color(0xFFF3F4F6), height: 16),

              // Store List or Empty State
              Expanded(
                child: stores.isEmpty
                    ? _buildEmptyState(context, connectPageViewModel)
                    : ListView.builder(
                        controller: scrollController,
                        padding: EdgeInsets.only(
                          left: 14,
                          right: 14,
                          top: 4,
                          bottom:
                              MediaQuery.of(context).padding.bottom + 20,
                        ),
                        itemCount: stores.length,
                        itemBuilder: (context, index) {
                          final store = stores[index];
                          final distanceStr = _calculateDistance(
                            connectPageViewModel.lat,
                            connectPageViewModel.lng,
                            store.lat,
                            store.lng,
                          );
                          return _buildStoreCard(context, store, distanceStr);
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context, ConnectPageViewModel vm) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3E0),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.location_off_rounded,
                color: primaryOrange,
                size: 38,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              vm.distanceInKm == "All"
                  ? "No stores registered yet"
                  : "No stores within ${vm.distanceInKm}Km",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1E2022),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              "Stores may be located further away. Tap below to see all available stores across the region.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF6B7280),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 18),
            if (vm.distanceInKm != "All")
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryOrange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                  elevation: 2,
                ),
                onPressed: () {
                  vm.updateDistanceInKm("All");
                },
                icon: const Icon(Icons.public_rounded, size: 18),
                label: const Text(
                  "Show All Stores",
                  style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoreCard(
    BuildContext context,
    StoreModel store,
    String distanceStr,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            if (store.id.isNotEmpty) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      OtherUserProfileScreen(userId: store.id),
                ),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Avatar
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 54,
                    height: 54,
                    color: const Color(0xFFFFF3E0),
                    child: store.profileImageUrl != null &&
                            store.profileImageUrl!.isNotEmpty
                        ? SafeCachedNetworkImage(
                            imageUrl: store.profileImageUrl!,
                            fit: BoxFit.cover,
                            width: 54,
                            height: 54,
                          )
                        : const Icon(
                            Icons.storefront_rounded,
                            color: primaryOrange,
                            size: 26,
                          ),
                  ),
                ),
                const SizedBox(width: 12),

                // Name, profession, and distance
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        store.name.isNotEmpty ? store.name : "Store",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1E2022),
                        ),
                      ),
                      if (store.profession.isNotEmpty) ...[
                        const SizedBox(height: 3),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: primaryOrange.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            store.profession,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: primaryOrange,
                            ),
                          ),
                        ),
                      ],
                      if (distanceStr.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.near_me_rounded,
                              size: 13,
                              color: Color(0xFF6B7280),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              distanceStr,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF6B7280),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                // Arrow button
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.chevron_right_rounded,
                    color: Color(0xFF9CA3AF),
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

