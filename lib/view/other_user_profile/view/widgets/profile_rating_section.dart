import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:biz_zinda/Settings/until/PColors.dart';
import 'package:biz_zinda/Settings/widgets/custom_elevated_button.dart';
import 'package:biz_zinda/Settings/widgets/custom_text_feild.dart';
import 'package:biz_zinda/Settings/widgets/text_widget.dart';
import 'package:biz_zinda/view_model/profile_view_model.dart';
import 'package:biz_zinda/view_model/post_view_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileRatingSection extends StatefulWidget {
  final String profileId;
  final Function onClose;
  final double? existingRating;
  final String? existingFeedback;
  final bool isRated;

  const ProfileRatingSection({
    Key? key,
    required this.profileId,
    required this.onClose,
    this.existingRating,
    this.existingFeedback,
    required this.isRated,
  }) : super(key: key);

  @override
  State<ProfileRatingSection> createState() => _ProfileRatingSectionState();
}

class _ProfileRatingSectionState extends State<ProfileRatingSection> {
  late TextEditingController feedbackController;
  late double rating;
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    rating = widget.existingRating ?? 1.0;
    feedbackController = TextEditingController(text: widget.existingFeedback ?? '');
    isEditing = widget.isRated;
  }

  @override
  void dispose() {
    feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              textWidget(
                text: widget.isRated ? "Your Rating" : "Rate this Profile",
                fontsize: 16,
                fontweight: FontWeight.w600,
              ),
              if (!widget.isRated || isEditing)
                GestureDetector(
                  onTap: () {
                    widget.onClose();
                  },
                  child: CircleAvatar(
                    radius: 15,
                    backgroundColor: PColors.textFeildBorderColor.withOpacity(0.3),
                    child: const Center(
                      child: Icon(
                        Icons.close,
                        size: 14,
                      ),
                    ),
                  ),
                ),
              if (widget.isRated && !isEditing)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isEditing = true;
                    });
                  },
                  child: CircleAvatar(
                    radius: 15,
                    backgroundColor: PColors.textFeildBorderColor.withOpacity(0.3),
                    child: const Center(
                      child: Icon(
                        Icons.edit,
                        size: 14,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 15),
          if (!widget.isRated || isEditing) ...[
            // Star rating section
            Center(
              child: StarRating(
                rating: rating,
                size: 35,
                color: PColors.yellow,
                starCount: 5,
                allowHalfRating: true,
                onRatingChanged: (newRating) => setState(() => rating = newRating),
              ),
            ),
            const SizedBox(height: 15),
            // Feedback text field
            CustomTextFeild(
              controller: feedbackController,
              hintText: "Write your feedback",
              textHead: "Feedback",
              onSaved: (val) {},
              onChanged: (val) {},
              validation: (val) {
                return null;
              },
              maxLine: 3,
              filColor: PColors.textFeildBorderColor,
            ),
            const SizedBox(height: 15),
            // Submit button
            CustomElavatedTextButton(
              borderRadius: 24,
              text: widget.isRated ? "Update" : "Submit",
              onPressed: () async {
                // Save to API
                context.read<ProfileViewModel>().addProfileRating(
                      context: context,
                      profileId: widget.profileId,
                      rating: rating.toString(),
                      review: feedbackController.text,
                    );
                
                // Save locally to SharedPreferences
                final prefs = await SharedPreferences.getInstance();
                final String key = 'rated_${widget.profileId}';
                await prefs.setString(key, '$rating|${feedbackController.text}');
                
                // Refresh the other user profile
                context.read<PostViewModel>().fetchOtherUserProfileDetails(
                  userID: widget.profileId,
                );
                
                widget.onClose();
              },
            ),
          ] else ...[
            // Display existing rating
            Center(
              child: StarRating(
                rating: widget.existingRating ?? 0,
                size: 30,
                color: PColors.yellow,
                starCount: 5,
                allowHalfRating: true,
                onRatingChanged: null,
              ),
            ),
            if (widget.existingFeedback != null && widget.existingFeedback!.isNotEmpty) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: PColors.textFeildBorderColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  widget.existingFeedback!,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}
