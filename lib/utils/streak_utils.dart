import '../database/database_helper.dart';

class StreakResult {
  final int current;
  final int best;

  const StreakResult({required this.current, required this.best});
}

class StreakUtils {
  /// Calculate current streak and best streak for a habit.
  /// Current streak = consecutive days ending at today (or yesterday).
  /// Best streak = longest ever consecutive run.
  static Future<StreakResult> calculate(int habitId) async {
    final dates = await DatabaseHelper.instance.getCompletionDates(habitId);
    if (dates.isEmpty) return const StreakResult(current: 0, best: 0);

    // Normalize to date-only
    final normalized = dates
        .map((d) => DateTime(d.year, d.month, d.day))
        .toSet()
        .toList()
      ..sort();

    final current = _currentStreak(normalized);
    final best = _bestStreak(normalized);

    return StreakResult(current: current, best: best);
  }

  static int _currentStreak(List<DateTime> sortedDates) {
    if (sortedDates.isEmpty) return 0;

    final today = DateTime.now();
    final todayNorm = DateTime(today.year, today.month, today.day);
    final yesterdayNorm = todayNorm.subtract(const Duration(days: 1));
    final lastDate = sortedDates.last;

    // Streak only counts if the last completion is today or yesterday
    if (!lastDate.isAtSameMomentAs(todayNorm) &&
        !lastDate.isAtSameMomentAs(yesterdayNorm)) {
      return 0;
    }

    int streak = 1;
    for (int i = sortedDates.length - 2; i >= 0; i--) {
      final expected = sortedDates[i + 1].subtract(const Duration(days: 1));
      if (sortedDates[i].isAtSameMomentAs(expected)) {
        streak++;
      } else {
        break;
      }
    }
    return streak;
  }

  static int _bestStreak(List<DateTime> sortedDates) {
    if (sortedDates.isEmpty) return 0;

    int best = 1;
    int current = 1;

    for (int i = 1; i < sortedDates.length; i++) {
      final expected = sortedDates[i - 1].add(const Duration(days: 1));
      if (sortedDates[i].isAtSameMomentAs(expected)) {
        current++;
        if (current > best) best = current;
      } else {
        current = 1;
      }
    }
    return best;
  }
}
