import 'package:get/get.dart';

import '../../models/session.dart';
import '../../repositories/session_repository.dart';

enum ChartsRange { week, month }

class ChartsController extends GetxController {
  final SessionRepository _repository = SessionRepository();

  final Rx<ChartsRange> range = ChartsRange.week.obs;

  final RxList<double> dailyDistanceKm = <double>[].obs;
  final RxList<String> dailyLabels = <String>[].obs;

  final RxList<List<double>> heatmap = <List<double>>[].obs;

  final RxDouble totalDistanceKm = 0.0.obs;
  final RxInt totalDurationSeconds = 0.obs;
  final RxDouble movingRatio = 0.0.obs;
  final RxInt sessionCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    reload();
  }

  void setRange(ChartsRange r) {
    range.value = r;
    reload();
  }

  void reload() {
    final all = _repository.getAllSessions();
    final now = DateTime.now();
    final days = range.value == ChartsRange.week ? 7 : 30;
    final start = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: days - 1));

    final inRange = all.where((s) {
      return !s.startTime.isBefore(start);
    }).toList();

    sessionCount.value = inRange.length;

    final Map<String, double> dayDist = {};
    final Map<String, int> dayDur = {};
    for (int i = 0; i < days; i++) {
      final d = start.add(Duration(days: i));
      final key = _dayKey(d);
      dayDist[key] = 0;
      dayDur[key] = 0;
    }

    double totalM = 0;
    int totalSec = 0;
    int movingSec = 0;
    int stoppedSec = 0;

    final rawHeat = List.generate(7, (_) => List.filled(24, 0.0));

    for (final s in inRange) {
      final key = _dayKey(s.startTime);
      if (dayDist.containsKey(key)) {
        dayDist[key] = dayDist[key]! + s.totalDistanceMeters;
        dayDur[key] = dayDur[key]! + s.totalDurationSeconds;
      }

      totalM += s.totalDistanceMeters;
      totalSec += s.totalDurationSeconds;

      final estStop =
          s.stopPoints.length *
          180;
      final stopSec = estStop.clamp(0, s.totalDurationSeconds);
      stoppedSec += stopSec;
      movingSec += (s.totalDurationSeconds - stopSec).clamp(
        0,
        s.totalDurationSeconds,
      );

      _accumulateHeatmap(rawHeat, s);
    }

    totalDistanceKm.value = totalM / 1000.0;
    totalDurationSeconds.value = totalSec;
    final denom = (movingSec + stoppedSec);
    movingRatio.value = denom == 0 ? 0.0 : movingSec / denom;

    final labels = <String>[];
    final distances = <double>[];
    for (int i = 0; i < days; i++) {
      final d = start.add(Duration(days: i));
      final key = _dayKey(d);
      labels.add(_shortLabel(d, days));
      distances.add((dayDist[key] ?? 0) / 1000.0);
    }
    dailyLabels.assignAll(labels);
    dailyDistanceKm.assignAll(distances);

    double maxV = 0;
    for (final row in rawHeat) {
      for (final v in row) {
        if (v > maxV) maxV = v;
      }
    }
    final normalized = rawHeat
        .map((row) => row.map((v) => maxV == 0 ? 0.0 : v / maxV).toList())
        .toList();
    heatmap.assignAll(normalized);
  }

  void _accumulateHeatmap(List<List<double>> heat, Session s) {
    if (s.locationPoints.isEmpty) {
      final wd = (s.startTime.weekday - 1) % 7;
      final hour = s.startTime.hour;
      heat[wd][hour] += s.totalDurationSeconds.toDouble();
      return;
    }

    for (int i = 0; i < s.locationPoints.length; i++) {
      final p = s.locationPoints[i];
      final nextTs = i + 1 < s.locationPoints.length
          ? s.locationPoints[i + 1].timestamp
          : (s.endTime ?? p.timestamp.add(const Duration(seconds: 30)));
      final sec = nextTs.difference(p.timestamp).inSeconds.clamp(0, 3600);
      final wd = (p.timestamp.weekday - 1) % 7;
      heat[wd][p.timestamp.hour] += sec.toDouble();
    }
  }

  String _dayKey(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  String _shortLabel(DateTime d, int days) {
    const names = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    if (days <= 7) return names[d.weekday - 1];
    return '${d.day}/${d.month}';
  }

  String formatDuration(int seconds) {
    final d = Duration(seconds: seconds);
    final h = d.inHours;
    final m = d.inMinutes % 60;
    if (h > 0) return '${h}h ${m}m';
    return '${m}m';
  }
}

