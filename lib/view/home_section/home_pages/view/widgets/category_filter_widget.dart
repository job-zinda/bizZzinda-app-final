import 'package:flutter/material.dart';
import 'package:biz_zinda/view/Create_My_Offer/offer_veiw_model.dart';
import 'package:biz_zinda/view_model/profile_view_model.dart';
import 'package:provider/provider.dart';

class CategoryFilterWidget extends StatelessWidget {
  const CategoryFilterWidget({super.key});

  static const Color primaryOrange = Color(0xFFFB8C00);

  IconData _getIconForCategory(String categoryName) {
    String name = categoryName.toLowerCase();
    if (name.contains("photography") || name.contains("video")) {
      return Icons.camera_alt_outlined;
    } else if (name.contains("design") || name.contains("creative")) {
      return Icons.brush_outlined;
    } else if (name.contains("web") || name.contains("app") || name.contains("development")) {
      return Icons.computer_outlined;
    } else if (name.contains("marketing") || name.contains("digital")) {
      return Icons.campaign_outlined;
    } else if (name.contains("tuition") || name.contains("courses") || name.contains("education")) {
      return Icons.school_outlined;
    } else if (name.contains("health") || name.contains("wellness")) {
      return Icons.health_and_safety_outlined;
    } else if (name.contains("finance") || name.contains("accounting")) {
      return Icons.account_balance_wallet_outlined;
    } else if (name.contains("writing") || name.contains("translation")) {
      return Icons.edit_note_outlined;
    } else if (name.contains("admin") || name.contains("support")) {
      return Icons.support_agent_outlined;
    } else if (name.contains("legal")) {
      return Icons.gavel_outlined;
    } else if (name.contains("sales")) {
      return Icons.point_of_sale_outlined;
    }
    return Icons.category_outlined;
  }

  Color _getColorForCategory(String categoryName) {
    String name = categoryName.toLowerCase();
    if (name.contains("photography") || name.contains("video")) {
      return Colors.pink.shade100;
    } else if (name.contains("design") || name.contains("creative")) {
      return Colors.orange.shade100;
    } else if (name.contains("web") || name.contains("app") || name.contains("development")) {
      return Colors.blue.shade100;
    } else if (name.contains("marketing") || name.contains("digital")) {
      return Colors.green.shade100;
    } else if (name.contains("tuition") || name.contains("courses") || name.contains("education")) {
      return Colors.purple.shade100;
    } else if (name.contains("health") || name.contains("wellness")) {
      return Colors.teal.shade100;
    }
    return Colors.grey.shade200;
  }

  Color _getIconColorForCategory(String categoryName) {
    String name = categoryName.toLowerCase();
    if (name.contains("photography") || name.contains("video")) {
      return Colors.pink;
    } else if (name.contains("design") || name.contains("creative")) {
      return Colors.orange;
    } else if (name.contains("web") || name.contains("app") || name.contains("development")) {
      return Colors.blue;
    } else if (name.contains("marketing") || name.contains("digital")) {
      return Colors.green;
    } else if (name.contains("tuition") || name.contains("courses") || name.contains("education")) {
      return Colors.purple;
    } else if (name.contains("health") || name.contains("wellness")) {
      return Colors.teal;
    }
    return Colors.grey.shade700;
  }

  @override
  Widget build(BuildContext context) {
    final profileViewModel = context.watch<ProfileViewModel>();
    final offerViewModel = context.watch<OfferViewModel>();

    // Default "All" option
    final selectedCategory = offerViewModel.selectedCategory ?? 'All';

    // Categories list from API + 'All' option
    List<String> categories = ['All'];
    for (var prof in profileViewModel.professionList) {
      if (prof.name != null && prof.name!.isNotEmpty) {
        categories.add(prof.name!);
      }
    }

    return Container(
      height: 90,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          String category = categories[index];
          bool isSelected = selectedCategory == category;

          IconData iconData = category == 'All' ? Icons.grid_view_rounded : _getIconForCategory(category);
          Color bgColor = category == 'All'
              ? (isSelected ? primaryOrange : Colors.white)
              : (isSelected ? primaryOrange : _getColorForCategory(category));
          Color iconColor = category == 'All'
              ? (isSelected ? Colors.white : primaryOrange)
              : (isSelected ? Colors.white : _getIconColorForCategory(category));

          return GestureDetector(
            onTap: () {
              offerViewModel.selectedCategory = category == 'All' ? null : category;
              offerViewModel.refreshOffer();
            },
            child: Container(
              width: 80,
              margin: const EdgeInsets.only(right: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(12),
                      border: category == 'All' && !isSelected
                          ? Border.all(color: primaryOrange, width: 1.5)
                          : null,
                    ),
                    child: Icon(
                      iconData,
                      color: iconColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    category,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      color: isSelected ? primaryOrange : Colors.grey.shade700,
                    ),
                  ),
                  if (isSelected)
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      height: 2,
                      width: 20,
                      color: primaryOrange,
                    )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
