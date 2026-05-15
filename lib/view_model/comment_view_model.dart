import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:biz_zinda/main.dart' as main_app;
import 'package:biz_zinda/model/comment_model.dart';
import 'package:biz_zinda/model/reply_model.dart';
import 'package:biz_zinda/utils/api_service.dart';
import 'package:biz_zinda/utils/api_url.dart';
import 'package:biz_zinda/view_model/post_view_model.dart';
import 'package:provider/provider.dart';

class CommentViewModel extends ChangeNotifier {
  bool isReply = false;
  int pageNumber = 1;

  final int pageSize = 5; // Define page size for pagination
  String? postId;
  bool hasMore = true;
  Comments postComment = Comments();
  bool isPaginationLoading = false;
  List<Comments> commentList = [];
  List<Replies> repliList = [];

  TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();

  // Fetch initial comments
  Future<void> fetchComments(String postId) async {
    EasyLoading.show(status: "Loading comments...");
    this.postId = postId;
    pageNumber = 1; // Reset page number for initial fetch
    hasMore = true; // Reset hasMore
    commentList.clear(); // Clear old comments

    final url =
        "${Api.viewComments}/$postId?pageNumber=$pageNumber&pageSize=$pageSize";
    try {
      final response = await ApiService().get(url);

      if (response.statusCode == 200) {
        final data = response.data;

        // Map the comments from API to the model
        final newComments = (data['data']['comments'] as List)
            .map((e) => Comments.fromJson(e))
            .toList();

        commentList.addAll(newComments);

        // Check if more data is available
        hasMore = newComments.length == pageSize;

        notifyListeners();
      }
    } catch (e) {
      EasyLoading.showError("Error fetching comments.");
    } finally {
      EasyLoading.dismiss();
    }
  }

  // Fetch additional comments for pagination
  Future<void> getPaginationComments(BuildContext context) async {
    if (isPaginationLoading || !hasMore) return;

    isPaginationLoading = true;
    pageNumber++; // Increment the page number

    final url =
        "${Api.viewComments}/$postId?pageNumber=$pageNumber&pageSize=$pageSize";
    try {
      final response = await ApiService().get(url);

      if (response.statusCode == 200) {
        final data = response.data;

        // Map the comments from API to the model
        final newComments = (data['data']['comments'] as List)
            .map((e) => Comments.fromJson(e))
            .toList();

        commentList.addAll(newComments);

        // Check if more data is available
        hasMore = newComments.length == pageSize;

        notifyListeners();
      }
    } catch (e) {
      EasyLoading.showError("Error loading more comments.");
    } finally {
      isPaginationLoading = false;
    }
  }

  // Add a new comment
  Future<void> addComment({
    required String postId,
    required String comment,
    required BuildContext context,
  }) async {
    try {
      final response = await ApiService().post(Api.addComments, {
        'postId': postId,
        'comment': comment,
      });

      if (response.statusCode == 200) {
        final data = response.data;

        if (data['status']) {
          fetchComments(postId);
          PostViewModel postViewModel = context.read<PostViewModel>();
          postViewModel.currentPage = 0;
          postViewModel.postController.refresh();
        }
      }
    } catch (e) {
      EasyLoading.showError("Error adding comment.");
    }
  }

  bool _showReplies = false;
  bool get showReplies => _showReplies;
  set showReplies(bool value) {
    _showReplies = value;
    notifyListeners();
  }

// bool showReplies = false;
  Future<void> addReply({
    required String commentId,
    required BuildContext context,
  }) async {
    try {
      String replyText = controller.text.trim();

      if (replyText.startsWith('@')) {
        // Find the first space after the @username
        final firstSpaceIndex = replyText.indexOf(' ');
        if (firstSpaceIndex != -1) {
          // Remove the @username part
          replyText = replyText.substring(firstSpaceIndex + 1).trim();
        }
      }
      final response = await ApiService().post(Api.addReply, {
        'commentId': commentId,
        'reply': replyText,
      });

      if (response.statusCode == 200) {
        final data = response.data;
        print("add eply------$data");
        if (data['status']) {
          fetchComments(postId!);
          //  fetchReplies(commentId);
          notifyListeners();
          // PostViewModel postViewModel = context.read<PostViewModel>();
          // postViewModel.currentPage = 0;
          // postViewModel.postController.refresh();
        }
      }
    } catch (e) {
      EasyLoading.showError("Error adding comment.");
    }
  }

  // Remove a comment
  Future<void> removeComment(String commentId, String postId) async {
    EasyLoading.show(status: "Removing comment...");
    final url = "${Api.removeComments}/$commentId";
    try {
      final response = await ApiService().delete(url);

      if (response.statusCode == 200) {
        final data = response.data;

        if (data['status']) {
          PostViewModel postViewModel =
              main_app.navigatorKey.currentContext!.read<PostViewModel>();
          postViewModel.currentPage = 0;
          postViewModel.postController.refresh();
          fetchComments(postId);
        } else {
          EasyLoading.showError(data['message']);
        }
      }
    } catch (e) {
      EasyLoading.showError("Error removing comment.");
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> removeReply(String replyId, String commentId) async {
    EasyLoading.show(status: "Removing reply...");
    final url = "${Api.deleteReply}/$replyId";
    try {
      final response = await ApiService().delete(url);

      if (response.statusCode == 200) {
        final data = response.data;

        if (data['status']) {
          PostViewModel postViewModel =
              main_app.navigatorKey.currentContext!.read<PostViewModel>();
          postViewModel.currentPage = 0;
          postViewModel.postController.refresh();
          fetchReplies(commentId);
          fetchComments(postId!);
        } else {
          EasyLoading.showError(data['message']);
        }
      }
    } catch (e) {
      EasyLoading.showError("Error removing comment.");
    } finally {
      EasyLoading.dismiss();
    }
  }

  // Update reply state
  void updateIsReply(bool value, Comments comment) {
    isReply = value;
    postComment = comment;
    notifyListeners();
  }

  void setReplyTo(String username) {
    controller.text = '@$username ';
    focusNode.requestFocus(); // Automatically focus on the text field
  }

  String getRelativeTime(String apiDate) {
    // Parse the API-provided date
    DateTime postDate = DateTime.parse(apiDate);
    DateTime now = DateTime.now();

    // Calculate the difference
    Duration difference = now.difference(postDate);

    if (difference.inDays >= 1) {
      return "${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago";
    } else if (difference.inHours >= 1) {
      return "${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago";
    } else if (difference.inMinutes >= 1) {
      return "${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago";
    } else {
      return "Just now";
    }
  }

  fetchReplies(String commentId) async {
    EasyLoading.show(status: "Loading comments...");
    this.postId = postId;
    pageNumber = 1; // Reset page number for initial fetch
    hasMore = true; // Reset hasMore
    // commentList.clear(); // Clear old comments
    repliList.clear();
    final url =
        "${Api.listReplies}/$commentId?pageNumber=$pageNumber&pageSize=100";
    try {
      final response = await ApiService().get(url);

      if (response.statusCode == 200) {
        final data = response.data;

        // Map the comments from API to the model
        final replye = (data['data']['replies'] as List)
            .map((e) => Replies.fromJson(e))
            .toList();

        repliList.addAll(replye);

        // Check if more data is available
        hasMore = replye.length == pageSize;

        return repliList;
      }
    } catch (e) {
      EasyLoading.showError("Error fetching comments.");
    } finally {
      EasyLoading.dismiss();
    }
  }
}
