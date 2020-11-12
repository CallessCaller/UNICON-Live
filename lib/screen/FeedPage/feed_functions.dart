String showTime(int time) {
  var now = DateTime.now();
  var showTime = now.difference(new DateTime.fromMillisecondsSinceEpoch(time));

  if (showTime.inMinutes < 60) {
    return showTime.inMinutes.toString() + '분 전';
  } else if (showTime.inHours < 24) {
    return showTime.inHours.toString() + '시간 전';
  } else {
    var postingTime = DateTime.fromMillisecondsSinceEpoch(time);
    return '${postingTime.year}.${postingTime.month}.${postingTime.day}';
  }
}
