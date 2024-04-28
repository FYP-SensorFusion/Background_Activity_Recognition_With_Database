String formatDuration(int duration) {
  final int hours = duration ~/ 60;
  final int remainingMinutes = (duration % 60);

  final int days = hours ~/ 24;
  final int remainingHours = hours % 24;

  String formattedDuration = '';
  if (days > 0) {
    formattedDuration += '${days}d ';
  }
  if (remainingHours > 0) {
    formattedDuration += '${remainingHours}h ';
  }
  formattedDuration += '${remainingMinutes}min';

  return formattedDuration.trim();
}