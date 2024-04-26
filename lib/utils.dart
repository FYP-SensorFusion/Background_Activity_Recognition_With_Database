String formatDuration(int duration) {
  final int hours = duration ~/ 3600;
  final int remainingMinutes = (duration % 3600) ~/ 60;
  final int seconds = duration % 60;

  final int days = hours ~/ 24;
  final int remainingHours = hours % 24;

  return '${days}d ${remainingHours}h ${remainingMinutes}min ${seconds}sec';
}