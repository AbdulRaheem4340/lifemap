import 'package:get/get.dart';

import '../../models/session.dart';
import '../../repositories/session_repository.dart';

class DashboardController extends GetxController {
  final SessionRepository _repository = SessionRepository();

  final RxDouble todayDistanceKm = 0.0.obs;
  final RxInt todayDurationSeconds = 0.obs;
  final RxInt todaySessionCount = 0.obs;
  final RxInt totalSessionCount = 0.obs;
  final RxList<Session> recentSessions = <Session>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
  }

  void loadDashboardData() {
    final allSessions = _repository.getAllSessions();
    totalSessionCount.value = allSessions.length;
    recentSessions.value = allSessions.take(5).toList();

    final now = DateTime.now();
    final todaySessions = allSessions.where((s) {
      return s.startTime.year == now.year &&
          s.startTime.month == now.month &&
          s.startTime.day == now.day;
    }).toList();

    todaySessionCount.value = todaySessions.length;

    double distMeters = 0.0;
    int durationSecs = 0;

    for (final s in todaySessions) {
      distMeters += s.totalDistanceMeters;
      durationSecs += s.totalDurationSeconds;
    }

    todayDistanceKm.value = distMeters / 1000;
    todayDurationSeconds.value = durationSecs;
  }

  String formatDuration(int seconds) {
    final duration = Duration(seconds: seconds);
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }
}

