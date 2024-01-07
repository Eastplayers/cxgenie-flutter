bool isSameDay(DateTime date1, DateTime date2) {
  return date1.year == date2.year &&
      date1.month == date2.month &&
      date1.day == date2.day;
}

bool isToday(DateTime date) {
  DateTime today = DateTime.now();
  return date.year == today.year &&
      date.month == today.month &&
      date.day == today.day;
}
