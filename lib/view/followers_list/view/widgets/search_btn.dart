import 'package:flutter/material.dart';
import 'package:biz_zinda/Settings/until/PColors.dart';
import 'package:biz_zinda/Settings/widgets/custom_text_feild.dart';
import 'package:biz_zinda/view_model/profile_view_model.dart';
import 'package:provider/provider.dart';

class FollowerSearchButtonUi extends StatefulWidget {
  final String? profileId;

  const FollowerSearchButtonUi({
    super.key,
    required this.profileId,
  });

  @override
  State<FollowerSearchButtonUi> createState() =>
      _FollowerSearchButtonUiState();
}

class _FollowerSearchButtonUiState
    extends State<FollowerSearchButtonUi> {

  final TextEditingController _searchController =
  TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileViewModel>(
      builder: (context, profileViewModel, child) {
        return CustomTextFeild(
          controller: _searchController,
          borderColor: const Color(0xFF8A4FFF),
          borderRadius: 18,
          hintText: "Search here...",
          filColor: PColors.white,
          suffixIcon: const Icon(Icons.close),

          // 🔥 CLEAR BUTTON
          sufixfn: () {
            _searchController.clear();

            profileViewModel.searchKeyword = '';
            profileViewModel.currentPage = 1;

            profileViewModel.followersController.refresh();
          },

          // 🔥 SEARCH TYPING
          onChanged: (val) {
            profileViewModel.searchKeyword = val ?? '';
            profileViewModel.currentPage = 1;

            profileViewModel.followersController.refresh();
          },
        );
      },
    );
  }
}