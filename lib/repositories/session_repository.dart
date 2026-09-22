import 'package:hive_flutter/hive_flutter.dart';

import '../core/constants/app_constants.dart';
import '../models/location_point.dart';
import '../models/session.dart';

class SessionRepository {
  Box<Session> get _sessionBox => Hive.box<Session>(AppConstants.boxSessions);
  Box<LocationPoint> get _pointBox =>
      Hive.box<LocationPoint>(AppConstants.boxLocationPoints);

  Future<void> saveSession(Session session) async {
    await _sessionBox.put(session.id, session);


  }


  Session? getSession(String id) {
    return _sessionBox.get(id);
  }

  List<Session> getAllSessions() {
    final sessions = _sessionBox.values.toList();
    sessions.sort((a, b) => b.startTime.compareTo(a.startTime));
    return sessions;
  }

  Future<void> deleteSession(String id) async {
    await _sessionBox.delete(id);
    final keysToDelete = _pointBox.values
        .where((point) => point.sessionId == id)
        .map((point) => point.id)
        .toList();
    await _pointBox.deleteAll(keysToDelete);
  }

  Future<void> saveLocationPoint(LocationPoint point) async {
    await _pointBox.put(point.id, point);
  }

  double getTodayTotalDistanceMeters() {
    final now = DateTime.now();
    final todaySessions = _sessionBox.values.where((s) {
      return s.startTime.year == now.year &&
          s.startTime.month == now.month &&
          s.startTime.day == now.day;
    });

    double total = 0.0;
    for (final s in todaySessions) {
      total += s.totalDistanceMeters;
    }
    return total;
  }
}

