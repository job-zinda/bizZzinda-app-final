class TimeAgoClass {
static String getHoursAgo(String isoDate) {
  DateTime parsedDate = DateTime.parse(isoDate).toLocal(); // Parse and convert to local time
  DateTime now = DateTime.now(); // Get the current local time

  Duration difference = now.difference(parsedDate); // Calculate the time difference

  if (difference.inDays > 0) {
    return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
  } else if (difference.inHours > 0) {
    return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
  } else if (difference.inMinutes > 0) {
    return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
  } else {
    return 'just now';
  }
}

}
