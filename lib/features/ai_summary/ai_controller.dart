import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../core/constants/app_constants.dart';
import '../../models/ai_insight.dart';
import '../../repositories/session_repository.dart';
import '../../services/ai_service.dart';

class AIController extends GetxController {
  final SessionRepository _repository = SessionRepository();
  final AIService _aiService = AIService();

  final Box<AIInsight> _insightsBox = Hive.box<AIInsight>(
    AppConstants.boxAiInsights,
  );

  final Rx<DateTime> weekStart = DateTime.now().obs;
  final Rxn<AIInsight> insight = Rxn<AIInsight>();
  final RxBool isGenerating = false.obs;

  @override
  void onInit() {
    super.onInit();
    weekStart.value = _mondayOf(DateTime.now());
    generate();
  }

  DateTime _mondayOf(DateTime d) {
    final day = DateTime(d.year, d.month, d.day);
    return day.subtract(Duration(days: day.weekday - 1));
  }

  DateTime get weekEnd => weekStart.value.add(const Duration(days: 7));

  String get weekLabel {
    final a = weekStart.value;
    final b = weekEnd.subtract(const Duration(days: 1));
    const m = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${m[a.month - 1]} ${a.day} – ${m[b.month - 1]} ${b.day}';
  }

  void previousWeek() {
    weekStart.value = weekStart.value.subtract(const Duration(days: 7));
    generate();
  }

  void nextWeek() {
    final next = weekStart.value.add(const Duration(days: 7));
    final thisMonday = _mondayOf(DateTime.now());
    if (next.isAfter(thisMonday)) return;
    weekStart.value = next;
    generate();
  }

  Future<void> generate({bool force = false}) async {
    final key = 'week_${weekStart.value.toIso8601String().substring(0, 10)}';

    if (!force && _insightsBox.containsKey(key)) {
      insight.value = _insightsBox.get(key);
      return;
    }

    isGenerating.value = true;

    final sessions = _repository.getAllSessions();
    final result = await _aiService.generateWeeklyInsight(
      weekStart: weekStart.value,
      weekEnd: weekEnd,
      sessions: sessions,
    );

    await _insightsBox.put(key, result);

    insight.value = result;
    isGenerating.value = false;
  }

  Future<void> regenerate() => generate(force: true);
}

