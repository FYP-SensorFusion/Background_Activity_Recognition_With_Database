String formatDuration(int duration) {
  final int hours = duration ~/ 3600;
  final int remainingMinutes = (duration % 3600) ~/ 60;
  final int seconds = duration % 60;

  final int days = hours ~/ 24;
  final int remainingHours = hours % 24;

  String formattedDuration = '';
  if (days > 0) {
    formattedDuration += '${days}d ';
  }
  if (remainingHours > 0) {
    formattedDuration += '${remainingHours}h ';
  }
  if (remainingMinutes > 0) {
    formattedDuration += '${remainingMinutes}min ';
  }
  formattedDuration += '${seconds}sec';

  return formattedDuration.trim();
}