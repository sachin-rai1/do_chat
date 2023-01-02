import 'package:flutter/material.dart';

class MyDateUtil {
  static String getFormattedTime(
      {required BuildContext context, required String time}) {
    final date = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    return TimeOfDay.fromDateTime(date).format(context);
  }

  static String getLastMessageTime(
      {required BuildContext context, required String time, bool showYear = false}) {
    final DateTime sent = DateTime.fromMillisecondsSinceEpoch(int.parse(time));

    final DateTime now = DateTime.now();

    if (now.day == sent.day &&
        now.month == sent.month &&
        now.year == sent.year) {
      return TimeOfDay.fromDateTime(sent).format(context);
    }
    return (showYear)
        ? '${sent.day} ${getMonth(date: sent)} ${sent.year}'
        : '${sent.day} ${getMonth(date: sent)}';
  }

  static String getMonth({required DateTime date}) {
    switch (date.month) {
      case 1 :
        return 'Jan';
      case 2 :
        return 'Feb';
      case 3 :
        return 'Mar';
      case 4 :
        return 'Apr';
      case 5 :
        return 'May';
      case 6 :
        return 'Jun';
      case 7 :
        return 'Jul';
      case 8 :
        return 'Aug';
      case 9 :
        return 'Sep';
      case 10 :
        return 'Oct';
      case 11 :
        return 'Nov';
      case 12 :
        return 'Dec';
    }
    return "NA";
  }


  static String getMessageTime(
      {required BuildContext context, required String time}) {
    final DateTime sent = DateTime.fromMillisecondsSinceEpoch(int.parse(time));

    final DateTime now = DateTime.now();

    final formattedTime = TimeOfDay.fromDateTime(sent).format(context);
    if (now.day == sent.day &&
        now.month == sent.month &&
        now.year == sent.year) {
      return formattedTime;
    }
    return now.year == sent.year ? '$formattedTime - ${sent.day} ${getMonth(
        date: (sent))}' : '$formattedTime - ${sent.day} ${getMonth(
        date: sent)} ${sent.year}';
  }

  static String getLastActiveTime(
      {required BuildContext context, required String lastActiveTime}) {
    final int i = int.tryParse(lastActiveTime) ?? -1;

    if (i == -1) return 'Last Seen not Available';

    DateTime time = DateTime.fromMillisecondsSinceEpoch(i);
    DateTime now = DateTime.now();

    String formattedTime = TimeOfDay.fromDateTime(time).format(context);
    if (time.day == now.day && time.month == now.month &&
        time.year == now.year) {
      return 'Last Seen Today at $formattedTime';
    }

    if ((now.difference(time).inHours).round() == 1){
    return 'Last Seen Yesterday at $formattedTime';
    }

    String month = getMonth(date: time);
    return 'Last Seen on ${time.day} $month on $formattedTime';


  }

}
