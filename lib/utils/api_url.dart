import '../model/logged_in_user.dart';

class AppUrl {
  static String get scurity => isProduction ? 'https' : 'http';

  // Set to false for local development, true for production:
  static const isProduction = true;

  static String get baseurl {
    if (isProduction == false) {
      return "http://localhost:4001"; // <-- Local backend on your machine
    } else {
      return "https://server2.jobzinda.com"; // <-- Production backend
    }
  }

  static String get httpBaseUrl {
    if (isProduction == false) {
      return 'localhost:4001'; // <-- Local backend host:port
    } else {
      return 'server2.jobzinda.com'; // <-- Production backend host
    }
  }

  static const String login = 'api/v1/auth/user-auth';
  static const String refreshToken = 'api/v1/auth/refresh-tokens';
  static const String checkUserExist = 'api/v1/auth/check-user-exists';
  static const String loginUrl = 'api/v1/auth/user-auth';
  static const String checkUserExistEmail = 'api/v1/auth/check-user-exists-email';
  static const String loginEmail = 'api/v1/auth/user-auth-email';
  // New username/password endpoints
  static const String loginUsername = 'api/v1/auth/login-username';
  static const String passwordSetupStatus = 'api/v1/auth/password-setup-status';
  static const String otpVerifyInitPassword = 'api/v1/auth/otp-verify-init-password';
  static const String otpVerifyChangePassword = 'api/v1/auth/otp-verify-change-password';
  static const String registerAfterOtp = 'api/v1/auth/register-after-otp';
  static const String registerUsername = 'api/v1/auth/register-username';
  static const String sendEmailOtp = 'api/v1/auth/send-email-otp';
  static const String verifyEmailOtp = 'api/v1/auth/verify-email-otp';
  static const String linkEmail = 'api/v1/auth/link-email';

}

class Api {
  static Future<Map<String, String>> getAuthorizationHeader() async {
    return {'Authorization': 'Bearer ${LoggedInUser.accessToken}'};
  }

  // Local development backend URL:
  // static const baseurl = 'http://localhost:4001';
  // Production backend URL:
  static const baseurl = 'https://server2.jobzinda.com';
  static const storiesListUrl =
      '$baseurl/api/v1/story/listStories?pageLimit=10';
  static const suggestedPostsListUrl =
      '$baseurl/api/v1/post/getAllSuggestedPosts?pageSize=10';
  static const followingsPostsListUrl =
      '$baseurl/api/v1/post/getAllFollowingPosts?pageSize=10';
  static const loginUserPostsListUrl =
      '$baseurl/api/v1/post/listMyPosts?pageSize=10';
  static const otherUserPostsListUrl =
      '$baseurl/api/v1/post/getOtherProfilePosts?pageSize=10';
  static const fetchPostDetails = '$baseurl/api/v1/post/getPostDetails';
  static const createStoryUrl = '$baseurl/api/v1/story/createStory';
  static const getSignInUrl = '$baseurl/api/v1/signed-url/get-signed-url';
  static const createPostUrl = '$baseurl/api/v1/post/addPost';
  static const profileDetailsUrl = '$baseurl/api/v1/user/get-profile-details';
  static const otherUserProfileDetailsUrl =
      '$baseurl/api/v1/user/get-other-profile';
  static const updateProfileImage = '$baseurl/api/v1/user/update-profile-image';
  static const updateProfile = '$baseurl/api/v1/user/update-profile';
  static const fetchProfileAnalyticsUrl =
      '$baseurl/api/v1/user/get-profile-analytics';
  static const updateCoverImage = '$baseurl/api/v1/user/update-cover-image';
  static const searchUserListUrl =
      '$baseurl/api/v1/user/get-other-profiles?pageSize=10';
  static const conversationListUrl =
      '$baseurl/api/v1/conversation/listConversations?pageSize=10000&&pageNumber=1';
  static const followUrl = '$baseurl/api/v1/follower/followUser';
  static const unfollowUrl = '$baseurl/api/v1/follower/unFollowUser';
  static const fetchNotificationsUrl =
      '$baseurl/api/v1/notification/listNotification?pageSize=10';
  static const deleteComment =
      '$baseurl/api/v1/notification/deleteNotification';
  static const profileVisitUrl = '$baseurl/api/v1/user/visit-profile';
  static const fetchNotificationCount =
      '$baseurl/api/v1/notification/getNotificationCount';
  static const notificationRead = '$baseurl/api/v1/notification/markAsRead';
  static const allNnotificationRead =
      '$baseurl/api/v1/notification/markAllAsRead';

  static const postLikeUrl = '$baseurl/api/v1/post/addALike';

  static const getAllMessage = '$baseurl/api/v1/conversation/getAllMessage';
  static const updateChat = '$baseurl/api/v1/conversation/updateChat';
  static const sentMessage = '$baseurl/api/v1/conversation/sentMessage';
  static const getNearestProfiles = '$baseurl/api/v1/user/get-nearest-profiles';
  static const refreshTokenUrl = '$baseurl/api/v1/auth/refresh-tokens';
  static const viewComments = '$baseurl/api/v1/postComment/viewComments';
  static const addComments = '$baseurl/api/v1/postComment/addComment';
  static const removeComments = '$baseurl/api/v1/postComment/removeComment';
  static const removePost = '$baseurl/api/v1/post/removeMyPost';

  static const addReply = '$baseurl/api/v1/postComment/reply/addReply';
  static const getMyStory = '$baseurl/api/v1/story/getMyStory';
  static const getStoryViews = '$baseurl/api/v1/story/getStoryViewCount';
  static const updateStoryView = '$baseurl/api/v1/story/updateStoryView';
  static const userLogout = '$baseurl/api/v1/auth/log-out';

  static const getProfession =
      '$baseurl/api/v1/category/customer/get-categories';
  static const getPlans = '$baseurl/api/v1/subscription/listSubscriptionPlans';
  static const createSubscriptionPayment =
      '$baseurl/api/v1/subscription/addSubscription';
  static const verifySubscriptionPayment =
      '$baseurl/api/v1/subscription/verifyPayment';
  static const reportProfile = '$baseurl/api/v1/report/reportProfile';
  static const listProfileMessages =
      '$baseurl/api/v1/conversation/listAllMessages';
  static const removeStory = '$baseurl/api/v1/story/removeStory';
  static const profilebyLocation = '$baseurl/api/v1/user/profiles-by-location';
  static const deleteProfile = '$baseurl/api/v1/user/delete-profile';
  static const sentQuery = '$baseurl/api/v1/query/sentQuery';
  static const listQueryMessages =
      '$baseurl/api/v1/conversation/listAllQueryMessages';
  static const blockUser = '$baseurl/api/v1/block/block-user';
  static const unblockUser = '$baseurl/api/v1/block/unblock-user';
  static const sendFeedback = '$baseurl/api/v1/app-rating/createAppRating';
  static const fetchReferals = '$baseurl/api/v1/referral/listMyReferrals';
  static const listBanners = '$baseurl/api/v1/banner/listBannersUser';
  static const listReplies =
      '$baseurl/api/v1/postComment/reply/listRepliesUser';
  static const deleteReply = '$baseurl/api/v1/postComment/reply/deleteReply';
  static const profileRating = '$baseurl/api/v1/user/add-profile-rating';
  static const listAllFollowers = '$baseurl/api/v1/follower/listAllFollowers';
  static const listAllFeedbacks = '$baseurl/api/v1/user/list-profile-feedBacks';

  static const userMessageUnreadCount =
      '$baseurl/api/v1/conversation/user-message-unread-count';
  static const letsplanUnreadCount =
      '$baseurl/api/v1/conversation/admin-message-unread-count';
  // Shabna
  static const freelancerPlans =
      '$baseurl/api/v1/freelancer-message/my-freelancer-messages';
  static const sentOtp =
      '$baseurl/api/v1/auth/send-email-otp';
  static const verifyOtp =
      '$baseurl/api/v1/auth/verify-email-otp';
  static const linkEmailUrl = '$baseurl/api/v1/auth/link-email';
  static const storeListUrl =
      '$baseurl/api/v1/store/get-stores?pageSize=10';
  static const addOfferUrl = '$baseurl/api/v1/offering/addOffering';
  static const searchstore = '$baseurl/api/v1/store/get-stores?searchTag=zinda&pageSize=10';
  static const nearestStoreUrl = '$baseurl/api/v1/store/get-nearest-stores';
  static const listMyOfferings =
      '$baseurl/api/v1/offering/listMyOfferings';
  static const removeMyOffering = '$baseurl/api/v1/offering/removeMyOffering';
  static const String addProduct = "$baseurl/api/v1/profile-catalog/addProduct";
  static const String listMyProducts = "$baseurl/api/v1/profile-catalog/listMyProducts";
  static const String updateProduct = "$baseurl/api/v1/profile-catalog/updateMyProduct";
  static const String deleteProduct = "$baseurl/api/v1/profile-catalog/removeMyProduct";
  static const String addService =
      "$baseurl/api/v1/profile-catalog/addService";

  static const String listMyServices =
      "$baseurl/api/v1/profile-catalog/listMyServices";

  static const String updateService =
      "$baseurl/api/v1/profile-catalog/updateMyService";

  static const String deleteService =
      "$baseurl/api/v1/profile-catalog/removeMyService";

  static const String promoteOffer =
      "$baseurl/api/v1/offer-promotion/promote";

  static const String verifyPromotePayment =
      "$baseurl/api/v1/offer-promotion/verify-promote-payment";
  static const String toggleLikeOffer =
      "$baseurl/api/v1/offering/likeOffering";
  static const createShop = '$baseurl/api/v1/shop/create';
  static const String getAllShops =
      '$baseurl/api/v1/shop/get-all';
  static const String shareOffering =
      "$baseurl/api/v1/offering/shareOffering";
  // 💬 Biz Chat APIs
  static String get initiateChat =>
      "$baseurl/api/v1/biz-chat/initiateChat";

  static String get sendMessage =>
      "$baseurl/api/v1/biz-chat/sendMessage";

  static String get listConversations =>
      "$baseurl/api/v1/biz-chat/listConversations";

  static String get unreadCount =>
      "$baseurl/api/v1/biz-chat/unreadCount";

  static String get markAsRead =>
      "$baseurl/api/v1/biz-chat/markAsRead";

  static String getMessages(String conversationId) =>
      "$baseurl/api/v1/biz-chat/getMessages/$conversationId";
  static const listAllOfferings =
      '$baseurl/api/v1/offering/listAllOfferings';
  static const getPlansstore =
      '$baseurl/api/v1/subscription/listSubscriptionPlans?platform=bizzzinda';

  static final String createSubscriptionPaymentstore =
      "${AppUrl.baseurl}/api/v1/subscription/addSubscription";

  static final String verifyPaymentUrlstore =
      "${AppUrl.baseurl}/api/v1/subscription/verifyPayment";

  static final String getMySubscriptionstore =
      "${AppUrl.baseurl}/api/v1/subscription/getMySubscription";
  static const String sharedOfferingDetails =
      '$baseurl/api/v1/offering/sharedOfferingDetails';
  static String otherUserProducts(String profileId) =>
      "$baseurl/api/v1/profile-catalog/listProfileProducts/$profileId";

  static String otherUserServices(String profileId) =>
      "$baseurl/api/v1/profile-catalog/listProfileServices/$profileId";
  static String deleteMessage(String messageId) =>
      "$baseurl/api/v1/biz-chat/deleteMessage/$messageId";

  // ------------------ Public (no-auth / guest) endpoints ------------------
  static const publicFeedUrl = '$baseurl/api/v1/post/public-feed?pageSize=10';
  static const publicOfferingsUrl =
      '$baseurl/api/v1/offering/public-offerings?pageSize=10';
  static const publicBannersUrl = '$baseurl/api/v1/banner/public-banners';
  static const publicStoresUrl = '$baseurl/api/v1/store/public-stores?pageSize=10';
  static const publicNearestStoresUrl =
      '$baseurl/api/v1/store/public-nearest-stores?distanceInKm=50';
  static String publicStoreDetailsUrl(String storeId) =>
      "$baseurl/api/v1/store/public-store-details/$storeId";
  static String publicOfferingDetailsUrl(String offeringId) =>
      "$baseurl/api/v1/offering/public-offering-details/$offeringId";
  static const publicProfilesUrl =
      '$baseurl/api/v1/user/public-profiles?pageSize=10';
  static const publicNearestProfilesUrl =
      '$baseurl/api/v1/user/public-nearest-profiles';
  static String publicProfileUrl(String profileId) =>
      "$baseurl/api/v1/user/public-profile/$profileId";
  static const publicProfileRatingsUrl =
      '$baseurl/api/v1/user/public-profile-ratings';
  static const publicProfilePostsUrl =
      '$baseurl/api/v1/post/public-profile-posts?pageSize=10';
}
