import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:biz_zinda/Settings/until/PPages.dart';
import 'package:biz_zinda/view/connect_pages/map_section/view/widgets/result_sheet.dart';
import 'package:biz_zinda/view/connect_pages/map_section/view/widgets/simple_map.dart';
import 'package:biz_zinda/view_model/connect_page_view_model.dart';
import 'package:provider/provider.dart';

class ConnectPagesUi extends StatefulWidget {
  const ConnectPagesUi({super.key});

  @override
  State<ConnectPagesUi> createState() => _ConnectPagesUiState();
}

class _ConnectPagesUiState extends State<ConnectPagesUi> {
  final TextEditingController textController = TextEditingController();
  final List<String> distanceList = ["All", "10", "20", "30", "Custom"];

  static const Color primaryOrange = Color(0xFFFB8C00);
  static const Color headerGradientStart = Color(0xFFFFA726);
  static const Color headerGradientEnd = Color(0xFFFB8C00);

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  void _showCustomDistanceDialog(
    BuildContext context,
    ConnectPageViewModel vm,
  ) {
    final customController = TextEditingController();
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
                controller: customController,
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
                    borderSide:
                        const BorderSide(color: primaryOrange, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 14),
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
                final text = customController.text.trim();
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

    return Scaffold(
      body: Stack(
        children: [
          // Map Widget
          const SimpleMap(),

          // Top Header Section (Search & Location)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 8,
                left: 14,
                right: 14,
                bottom: 14,
              ),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [headerGradientStart, headerGradientEnd],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(22),
                  bottomRight: Radius.circular(22),
                ),
                boxShadow: [
                  BoxShadow(
                    color: primaryOrange.withValues(alpha: 0.35),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // White Pill Search Field
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 12),
                          const Icon(
                            Icons.storefront_rounded,
                            color: primaryOrange,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: textController,
                              style: const TextStyle(
                                color: Color(0xFF1E2022),
                                fontSize: 13.5,
                                fontWeight: FontWeight.w500,
                              ),
                              decoration: const InputDecoration(
                                hintText:
                                    "Search stores, people, skills...",
                                hintStyle: TextStyle(
                                  color: Color(0xFF8E8E93),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                              onChanged: (val) {
                                setState(() {});
                                connectPageViewModel.updateSearchTag(val);
                              },
                              onSubmitted: (val) {
                                connectPageViewModel.updateSearchTag(val);
                              },
                            ),
                          ),
                          if (textController.text.isNotEmpty)
                            GestureDetector(
                              onTap: () {
                                textController.clear();
                                setState(() {});
                                connectPageViewModel.updateSearchTag("");
                                connectPageViewModel.clear();
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 6),
                                child: Icon(
                                  Icons.close_rounded,
                                  size: 18,
                                  color: Color(0xFF888888),
                                ),
                              ),
                            ),
                          const Padding(
                            padding: EdgeInsets.only(right: 14, left: 4),
                            child: Icon(
                              Icons.search_rounded,
                              color: Color(0xFF666666),
                              size: 22,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Red Pin Location Button
                  GestureDetector(
                    onTap: () {
                      context.pushNamed(PPages.searchLocation, extra: "map");
                    },
                    child: Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.location_on_rounded,
                          color: Color(0xFFE53935),
                          size: 26,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Floating Distance Chips & Filter Row
          Positioned(
            top: MediaQuery.of(context).padding.top + 72,
            left: 14,
            right: 14,
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 38,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: distanceList.length,
                      separatorBuilder: (context, index) => const SizedBox(width: 6),
                      itemBuilder: (context, index) {
                        final dist = distanceList[index];
                        final bool isCustom = dist == "Custom";
                        final bool isCurrentCustom = isCustom &&
                            connectPageViewModel.distanceInKm != "All" &&
                            connectPageViewModel.distanceInKm != "10" &&
                            connectPageViewModel.distanceInKm != "20" &&
                            connectPageViewModel.distanceInKm != "30";
                        final bool isSelected =
                            connectPageViewModel.distanceInKm == dist ||
                                isCurrentCustom;

                        String label;
                        if (dist == "All") {
                          label = "All";
                        } else if (isCustom) {
                          label = isCurrentCustom
                              ? "${connectPageViewModel.distanceInKm}Km"
                              : "Custom";
                        } else {
                          label = "${dist}Km";
                        }

                        return GestureDetector(
                          onTap: () {
                            if (isCustom) {
                              _showCustomDistanceDialog(
                                context,
                                connectPageViewModel,
                              );
                            } else {
                              connectPageViewModel.updateDistanceInKm(dist);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            decoration: BoxDecoration(
                              color: isSelected ? primaryOrange : Colors.white,
                              borderRadius: BorderRadius.circular(22),
                              border: isSelected
                                  ? null
                                  : Border.all(
                                      color: const Color(0xFFE5E7EB),
                                      width: 1,
                                    ),
                              boxShadow: [
                                BoxShadow(
                                  color: isSelected
                                      ? primaryOrange.withValues(alpha: 0.35)
                                      : Colors.black.withValues(alpha: 0.06),
                                  blurRadius: isSelected ? 6 : 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
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
                ),
                const SizedBox(width: 8),
                // Filter / Sliders Button
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      useRootNavigator: true,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => const ResultSheetUi(),
                    );
                  },
                  child: Container(
                    height: 38,
                    width: 44,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: const Color(0xFFE5E7EB),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.tune_rounded,
                        color: primaryOrange,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Fallback Banner if no stores within selected radius
          if (connectPageViewModel.distanceInKm != "All" &&
              connectPageViewModel.nearestStores.isEmpty)
            Positioned(
              top: MediaQuery.of(context).padding.top + 118,
              left: 14,
              right: 14,
              child: GestureDetector(
                onTap: () {
                  connectPageViewModel.updateDistanceInKm("All");
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.95),
                    borderRadius: BorderRadius.circular(20),
                    border:
                        Border.all(color: primaryOrange.withValues(alpha: 0.3)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.info_outline_rounded,
                          size: 16, color: primaryOrange),
                      const SizedBox(width: 6),
                      Text(
                        "No stores within ${connectPageViewModel.distanceInKm}Km • Tap to View All",
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E2022),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
