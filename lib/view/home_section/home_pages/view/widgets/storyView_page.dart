import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:biz_zinda/Settings/until/PColors.dart';
import 'package:biz_zinda/Settings/until/PImages.dart';
import 'package:biz_zinda/Settings/until/PSvgs.dart';
import 'package:biz_zinda/view/home_section/home_pages/view/widgets/linear_progress_indicator.dart';
import 'package:biz_zinda/view/home_section/home_pages/view/widgets/views_sheet.dart';
import 'package:biz_zinda/model/myStory_model.dart';
import 'package:biz_zinda/model/story_model.dart';
import 'package:biz_zinda/view_model/story_view_model.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class StoryViewerArgs {
  final StoryModel? story; // For other users' stories
  final MyStoryModel? myStory; // For the current user's own story
  final bool isMyProfile;

  StoryViewerArgs({
    this.story,
    this.myStory,
    required this.isMyProfile,
  }) : assert(isMyProfile ? myStory != null : story != null, 
             'Either myStory or story must be provided based on isMyProfile flag.');
}

class StoryViewer extends StatefulWidget {
  final StoryViewerArgs args;

  const StoryViewer({super.key, required this.args});

  @override
  _StoryViewerState createState() => _StoryViewerState();
}

class _StoryViewerState extends State<StoryViewer> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;
  double _progress = 0.0;
  VideoPlayerController? _videoController;
  bool _isVideoLoading = false;

  @override
  void initState() {
    super.initState();
    _startAutoScrollTimer();
    _initializeVideo();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  void _startAutoScrollTimer() {
    _progress = 0.0;
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() {
        if (_videoController != null &&
            _videoController!.value.isInitialized &&
            !_isVideoLoading) {
          final position = _videoController!.value.position.inMilliseconds;
          final duration =
              _videoController!.value.duration.inMilliseconds ?? 0;

          if (duration > 0) {
            _progress = position / duration;
          } else {
            _progress = 0.0;
          }
        } else if (_videoController == null) {
          _progress += 0.01; // For image stories
        }

        // Check if progress is complete
        if (_progress >= 1.0) {
          _progress = 0.0; // Reset progress

          int mediaLength;
          if (widget.args.isMyProfile) {
            mediaLength = widget.args.myStory!.media!.length;
          } else {
            mediaLength = widget.args.story!.media!.length;
          }

          // Update story view count if it's not the user's own profile and it's a new story item
          if (!widget.args.isMyProfile && _currentPage > 0) { // Check if it's not the first item
            final story = widget.args.story!;
            final currentMedia = story.media![_currentPage];
            context.read<StoryViewModel>().updateStoryView(
              storyId: story.sId.toString(), 
              lastViewedMediaId: currentMedia.sId.toString(), 
              context: context
            );
          }
          // For user's own story, fetch views if it's a new story item
          // This logic might already be in _initializeMyStoryVideo or similar, review if redundant
          if (widget.args.isMyProfile && _currentPage > 0) {
             final myStory = widget.args.myStory!;
             final currentMedia = myStory.media![_currentPage];
             context.read<StoryViewModel>().fetchStoryViews(
                mediaId: currentMedia.sId.toString(),
                storyId: myStory.sId.toString()
              );
          }

          if (_currentPage < mediaLength - 1) {
            _currentPage++;
            _pageController.animateToPage(
              _currentPage,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
            // if (context.read<StoryViewModel>().isMyProfile) {
               context.read<StoryViewModel>().fetchStoryViews(
          mediaId: widget.args.myStory!.media![_currentPage].sId.toString(),
          storyId: widget.args.myStory!.sId.toString());
            //           .toString());
            // }
            _initializeVideo();
          } else {
            print("completed");
            // All stories completed, navigate back
            _timer?.cancel();
            Navigator.pop(context);
          }
        }
      });
    });
  }

  void _initializeVideo() {
    _videoController?.dispose();
    _videoController = null; // Ensure it's null before re-initialization
    _isVideoLoading = true; // Set loading true
    if (widget.args.isMyProfile) {
      _initializeMyStoryVideo();
    } else {
      _initializeOtherStoryVideo();
    }
  }

  void _initializeMyStoryVideo() {
    final mediaList = widget.args.myStory?.media;
    if (mediaList != null && mediaList.isNotEmpty) {
      final currentStory = mediaList![_currentPage];
      if (currentStory != null && currentStory.mediaType == "video" && currentStory.content != null) {
        _videoController = VideoPlayerController.network(currentStory.content!)
          ..initialize().then((_) {
            setState(() {
              _isVideoLoading = false;
              _videoController!.play();
            });
          }).catchError((_) {
            setState(() {
              _isVideoLoading = false;
              _videoController = null;
            });
          });
      } else {
        _videoController = null;
      }
    }
  }

  void _initializeOtherStoryVideo() {
    final mediaList = widget.args.story?.media;
    if (mediaList != null && mediaList.isNotEmpty) {
      final currentStory = mediaList![_currentPage];
      if (currentStory != null && currentStory.mediaType == "video" && currentStory.content != null) {
        _videoController = VideoPlayerController.network(currentStory.content!)
          ..initialize().then((_) {
            setState(() {
              _isVideoLoading = false;
              _videoController!.play();
            });
          }).catchError((_) {
            setState(() {
              _isVideoLoading = false;
              _videoController = null;
            });
          });
      } else {
        _videoController = null;
      }
    }
  }

  void _goToNextStory(bool isMyProfile) {
    _timer?.cancel();
    final mediaLength = (isMyProfile
        ? widget.args.myStory!.media
        : widget.args.story!.media)?.length ?? 0;

    if (_currentPage < mediaLength - 1) {
      setState(() {
        _currentPage++;
        _progress = 0.0;
      });
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _initializeVideo();
    } else {
      Navigator.pop(context); // Exit if it's the last story
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<StoryViewModel>(builder: (context, value, child) {
        final isMyProfile = widget.args.isMyProfile;
        final mediaList = isMyProfile
            ? widget.args.myStory!.media
            : widget.args.story!.media;

        if (mediaList == null || mediaList.isEmpty) {
          return const Center(child: Text("No stories available"));
        }

        return Stack(
          children: [
            Positioned.fill(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                    _progress = 0.0;
                  });
                  if (widget.args.isMyProfile) {
                    final mediaId = widget.args.myStory!.media![index].sId;
                    value.fetchStoryViews(
                        mediaId: mediaId!,
                        storyId: widget.args.myStory!.sId.toString());
                  } else {
                    value.updateStoryView(
                        storyId: widget.args.story!.sId.toString(),
                        lastViewedMediaId:
                            widget.args.story!.media![index].sId.toString(),
                        context: context);
                  }

                  // _updateViewCount(stories[index]['id']);
                  _initializeVideo();
                },
                itemCount: mediaList.length,
                itemBuilder: (context, index) {
                  final story = mediaList[index];
                  return GestureDetector(
                    // onTap: () => _goToNextStory(isMyProfile),
                    child: story.mediaType == "video"
                        ? (_videoController != null &&
                                _videoController!.value.isInitialized
                            ? VideoPlayer(_videoController!)
                            : const Center(child: CircularProgressIndicator()))
                        : (story.mediaType == "image"
                            ? Image.network(story.content!)
                            : const Center(child: Text("Invalid"))),
                  );
                },
              ),
            ),
            Positioned(
              top: 40,
              left: 10,
              right: 10,
              child: Column(
                children: [
                  LinearProgressIndicatorUi(
                    currentPage: _currentPage,
                    isVideoLoading: _isVideoLoading,
                    progress: _progress,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: isMyProfile
                            ? (widget.args.myStory!.user?.profileImageUrl
                                        ?.isEmpty ??
                                    true
                                ? AssetImage(PImages.profile)
                                : NetworkImage(
                                    widget.args.myStory!.user!.profileImageUrl!))
                            : (widget.args.story!.userProfileImg?.isEmpty ?? true
                                    ? AssetImage(PImages.profile)
                                    : NetworkImage(
                                        widget.args.story!.userProfileImg!))
                                as ImageProvider,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        isMyProfile
                          ? widget.args.myStory!.user?.name ?? ""
                          : widget.args.story!.userName ?? "",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),
                      isMyProfile?     GestureDetector(
                          onTap: () {
                            _deleteStory(context);
                          },
                          child: const Icon(Icons.delete)):Container()
                    ],
                  ),
                ],
              ),
            ),
            if (isMyProfile)
              Positioned(
                bottom: 20,
                left: 120,
                right: 120,
                child: Row(
                  children: [
                    Expanded(child: _storyViewCountWidget()),
                  ],
                ),
              ),
          ],
        );
      }),
    );
  }

  Widget _storyViewCountWidget() {
    return Consumer<StoryViewModel>(
      builder: (context, value, child) => GestureDetector(
        onTap: value.storyCount == 0
            ? null
            : () {
                showBottomSheet(
                  context: context,
                  builder: (context) => const StoryViewsSheetUi(),
                );
              },
        child: Container(
          width: 150,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: PColors.whiteOff.withOpacity(0.3),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              SvgPicture.asset(PSvgs.eye),
              const SizedBox(
                width: 10,
              ),
              Text(
                "${value.storyCount.toString()} Views",
                style: TextStyle(
                    color: PColors.white, fontWeight: FontWeight.w500),
              )
            ]),
          ),
        ),
      ),
    );
  }

  void _deleteStory(BuildContext context) async {
    if (!widget.args.isMyProfile) return; // Should only be called for user's own story

    final storyViewModel = context.read<StoryViewModel>();
    final currentStoryId = widget.args.myStory!.media![_currentPage].sId;

    var success = await storyViewModel.removeStory(
        mediaId: currentStoryId.toString(),
        storyId: widget.args.myStory!.sId.toString(),
        context: context);

    if (success == true) {
      // The StoryViewModel's myStoryModel is not what we are displaying directly anymore.
      // We need to modify the local copy from widget.args if we want immediate UI update,
      // or rely on a full refresh/pop if the underlying data source changes and parent rebuilds.
      // For now, let's assume a pop or refresh will handle it, or that StoryViewModel internally updates something that causes a rebuild.
      // A more robust way would be for removeStory to return the updated MyStoryModel or for StoryViewModel to notify listeners
      // in a way that causes this widget to get new args or rebuild based on updated Provider state.
      // However, the current structure of removeStory doesn't facilitate this directly for widget.args.myStoryModel.
      // Let's pop for now if deletion is successful and the list becomes empty.
      
      // To reflect deletion locally if we don't pop immediately:
      // widget.args.myStory!.media!.removeAt(_currentPage);
      // if (widget.args.myStory!.media!.isEmpty) {
      //   Navigator.pop(context);
      //   return;
      // }
      // if (_currentPage >= widget.args.myStory!.media!.length && _currentPage > 0) {
      //   _currentPage--;
      // }
      // _initializeVideo(); // Re-initialize with potentially new current page
      // setState(() {}); // Trigger rebuild

      // Simpler approach: Pop if last story deleted, otherwise try to go to previous/next or re-init
      // This part needs careful handling of state after deletion.
      // For now, relying on the fact that if media is empty, it will pop.
      // The original code modified storyViewModel.myStoryModel.media directly.
      // We cannot modify widget.args.myStory.media directly as it's final.
      // This implies that after deletion, the StoryViewModel should probably trigger a state update
      // that leads to navigation or providing new args.

      // Let's assume for now that if successful, we pop or the parent handles refresh.
      // The best is to pop and let the parent view model refresh its state.
      Navigator.pop(context); // Pop after successful deletion to refresh the previous screen's story list.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Story deleted successfully")),
      );
      // No need to setState for _currentPage if we pop.
      return; // Exit after popping

      // If we didn't pop, and wanted to stay on the viewer:
      // widget.args.myStory!.media!.removeAt(_currentPage); // This is not allowed as args are final.
      // This indicates a deeper refactoring might be needed for live updates post-deletion
      // without popping, or the ViewModel needs to manage the displayed story list. 
      // Given the current structure, popping is the most straightforward.
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to delete story")),
      );
    }
  }
  // void _goToNextStory(bool isMyProfile) {
  //   int mediaLength = isMyProfile
  //       ? context.read<StoryViewModel>().myStoryModel.media!.length
  //       : context.read<StoryViewModel>().storyModel.media!.length;

  //   if (_currentPage < mediaLength - 1) {
  //     setState(() {
  //       _currentPage++;
  //       _progress = 0.0;
  //     });
  //     _pageController.animateToPage(
  //       _currentPage,
  //       duration: Duration(milliseconds: 300),
  //       curve: Curves.easeInOut,
  //     );
  //     _initializeVideo();
  //   } else {
  //     _timer?.cancel();
  //     Navigator.pop(context); // Exit if it's the last story
  //   }
  // }
}
