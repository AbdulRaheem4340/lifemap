import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../core/utils/app_snackbar.dart';
import '../models/ai_insight.dart';
import '../models/session.dart';

class AIService {
  static const String _grokApiKey = 'YOUR_ACTUAL_KEY';

  Future<AIInsight> generateWeeklyInsight({
    required DateTime weekStart,
    required DateTime weekEnd,
    required List<Session> sessions,
  }) async {
    final inWeek = sessions.where((s) {
      return !s.startTime.isBefore(weekStart) && s.startTime.isBefore(weekEnd);
    }).toList();

    if (inWeek.isEmpty) {
      return AIInsight(
        id: 'week_${weekStart.toIso8601String().substring(0, 10)}',
        weekStart: weekStart,
        weekEnd: weekEnd,
        summaryText:
            'It looks like you took a restful break this week! When you are ready to venture out again, tap START on your dashboard to map your next journey.',
        highlights: const ['No sessions recorded this week'],
        generatedAt: DateTime.now(),
        sessionCount: 0,
        totalDistanceKm: 0.0,
      );
    }

    double totalM = 0;
    int totalSec = 0;
    int totalStops = 0;
    double longestKm = 0;
    int morningCount = 0;
    int afternoonCount = 0;
    int eveningCount = 0;
    int nightCount = 0;

    final dayDistances = <int, double>{};

    for (final s in inWeek) {
      final distKm = s.totalDistanceMeters / 1000.0;
      totalM += s.totalDistanceMeters;
      totalSec += s.totalDurationSeconds;
      totalStops += s.stopPoints.length;

      if (distKm > longestKm) longestKm = distKm;

      final hour = s.startTime.hour;
      if (hour >= 5 && hour < 12) {
        morningCount++;
      } else if (hour >= 12 && hour < 17) {
        afternoonCount++;
      } else if (hour >= 17 && hour < 21) {
        eveningCount++;
      } else {
        nightCount++;
      }

      final weekday = s.startTime.weekday;
      dayDistances[weekday] = (dayDistances[weekday] ?? 0.0) + distKm;
    }

    final totalKm = totalM / 1000.0;
    final hours = totalSec ~/ 3600;
    final mins = (totalSec % 3600) ~/ 60;
    final durationLabel = hours > 0 ? '${hours}h ${mins}m' : '${mins}m';

    int peakDayIndex = 1;
    double maxDayDist = 0.0;
    dayDistances.forEach((day, dist) {
      if (dist > maxDayDist) {
        maxDayDist = dist;
        peakDayIndex = day;
      }
    });
    final peakDayName = _getWeekdayName(peakDayIndex);

    final primaryTimeOfDay = _getPrimaryTimeOfDay(
      morningCount,
      afternoonCount,
      eveningCount,
      nightCount,
    );

    final avgSpeedKmH = totalSec > 0 ? (totalKm / (totalSec / 3600.0)) : 0.0;

    final highlights = [
      '${totalKm.toStringAsFixed(1)} km across ${inWeek.length} sessions',
      'Tracked time: $durationLabel',
      'Peak Day: $peakDayName (${maxDayDist.toStringAsFixed(1)} km)',
      'Longest Trip: ${longestKm.toStringAsFixed(1)} km',
      'Pattern: $primaryTimeOfDay',
      if (totalStops > 0) '$totalStops auto-detected stops',
    ];

    String summaryText = '';

    if (_grokApiKey.trim().isEmpty || _grokApiKey.contains('YOUR_ACTUAL_KEY')) {
      debugPrint('AI: Key missing. Generating local fallback summary.');
      summaryText = _generateLocalFallback(
        count: inWeek.length,
        km: totalKm,
        time: durationLabel,
        stops: totalStops,
        peakDay: peakDayName,
        longestKm: longestKm,
        timeOfDay: primaryTimeOfDay,
      );
    } else {
      debugPrint('AI: Key detected. Dispatching API request to Groq...');
      summaryText = await _callGroqApi(
        count: inWeek.length,
        km: totalKm,
        time: durationLabel,
        stops: totalStops,
        peakDay: peakDayName,
        peakDayKm: maxDayDist,
        longestKm: longestKm,
        timeOfDay: primaryTimeOfDay,
        avgSpeed: avgSpeedKmH,
      );
    }

    return AIInsight(
      id: 'week_${weekStart.toIso8601String().substring(0, 10)}',
      weekStart: weekStart,
      weekEnd: weekEnd,
      summaryText: summaryText,
      highlights: highlights,
      generatedAt: DateTime.now(),
      sessionCount: inWeek.length,
      totalDistanceKm: totalKm,
    );
  }

  Future<String> _callGroqApi({
    required int count,
    required double km,
    required String time,
    required int stops,
    required String peakDay,
    required double peakDayKm,
    required double longestKm,
    required String timeOfDay,
    required double avgSpeed,
  }) async {
    final prompt = '''
You are 'LifeMap Insights', an intuitive movement cartographer and empathetic analyst.

Analyze this weekly movement data and write a warm, highly engaging 3-paragraph summary:
- Total Journeys: $count sessions
- Total Distance: ${km.toStringAsFixed(2)} km
- Active Duration: $time
- Peak Activity Day: $peakDay (${peakDayKm.toStringAsFixed(2)} km)
- Single Longest Journey: ${longestKm.toStringAsFixed(2)} km
- Dominant Movement Window: $timeOfDay
- Average Pace: ${avgSpeed.toStringAsFixed(1)} km/h
- Micro-Stops: $stops

STRUCTURE & GOALS:
- Paragraph 1 (Rhythm & Timing): Welcome the user warmly, celebrate their consistency, note their preferred window ($timeOfDay), and highlight peak activity on $peakDay.
- Paragraph 2 (Exploration & Pace): Discuss their longest trip (${longestKm.toStringAsFixed(1)} km) and movement flow (${avgSpeed.toStringAsFixed(1)} km/h). Explain what their $stops stops say about their rhythm.
- Paragraph 3 (Wisdom & Looking Ahead): Offer one encouraging, practical micro-suggestion for next week tailored to their $timeOfDay pattern.

FORMATTING RULES:
- Output ONLY plain paragraphs separated by a single blank line.
- DO NOT use markdown bolding (**), asterisks (*), bullet points, or headers.
- DO NOT include labels like 'Paragraph 1:', 'Note:', or 'Draft:'.
''';

    const groqModels = [
      'openai/gpt-oss-120b',
      'openai/gpt-oss-20b',
      'qwen/qwen3.8-27b',
      'allam-2-7b',
    ];

    for (final model in groqModels) {
      try {
        debugPrint('AI: Querying Groq model: $model...');
        final response = await http
            .post(
              Uri.parse('https://api.groq.com/openai/v1/chat/completions'),
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $_grokApiKey',
              },
              body: jsonEncode({
                'model': model,
                'messages': [
                  {
                    'role': 'system',
                    'content': 'You are LifeMap Insights, an empathetic movement cartographer.'
                  },
                  {'role': 'user', 'content': prompt},
                ],
                'temperature': 0.7,
                'max_tokens': 600,
              }),
            )
            .timeout(const Duration(seconds: 12));

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body) as Map<String, dynamic>;
          final choices = data['choices'] as List<dynamic>?;
          if (choices != null && choices.isNotEmpty) {
            final rawText = choices[0]['message']['content'] as String?;
            if (rawText != null && rawText.trim().isNotEmpty) {
              final cleanText = _sanitizeResponse(rawText);
              debugPrint('AI SUCCESS on Groq ($model)!');
              return cleanText;
            }
          }
        } else if (response.statusCode == 401) {
          AppSnackbar.show('API Key Error', 'Groq API Key (gsk_) is invalid or unauthorized.', isError: true);
          break;
        } else {
          debugPrint('GROQ ERROR HTTP ${response.statusCode}: ${response.body}');
        }
      } catch (e) {
        debugPrint('AI Exception for Groq ($model): $e');
      }
    }

    return _generateLocalFallback(
      count: count,
      km: km,
      time: time,
      stops: stops,
      peakDay: peakDay,
      longestKm: longestKm,
      timeOfDay: timeOfDay,
    );
  }

  String _sanitizeResponse(String rawText) {
    String text = rawText.trim();

    text = text.replaceAll(
      RegExp(r'^\s*(?:para(?:graph)?|p)\s*\d+\s*:\s*', caseSensitive: false, multiLine: true),
      '',
    );
    text = text.replaceAll(RegExp(r'\*+'), '');
    text = text.replaceAll(RegExp(r'\n{3,}'), '\n\n');

    return text.trim();
  }

  String _getWeekdayName(int weekday) {
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return days[(weekday - 1) % 7];
  }

  String _getPrimaryTimeOfDay(int morning, int afternoon, int evening, int night) {
    int max = morning;
    String label = 'Morning Explorer';

    if (afternoon > max) {
      max = afternoon;
      label = 'Afternoon Wanderer';
    }
    if (evening > max) {
      max = evening;
      label = 'Evening Stroller';
    }
    if (night > max) {
      label = 'Night Walker';
    }

    return label;
  }

  String _generateLocalFallback({
    required int count,
    required double km,
    required String time,
    required int stops,
    required String peakDay,
    required double longestKm,
    required String timeOfDay,
  }) {
    final distanceText = km >= 1 ? '${km.toStringAsFixed(1)} km' : '${(km * 1000).round()} m';

    return '''
You built solid momentum this week across $count journeys covering $distanceText in $time. As a clear $timeOfDay, your rhythm really stood out on $peakDay, which became your peak activity day.

Your longest single journey stretched across ${longestKm.toStringAsFixed(1)} km. With $stops micro-stops along the way, your movement balances steady continuous flow with moments to pause and take in your surroundings.

To build on this next week, consider adding one extra 10-minute walk during your preferred $timeOfDay window. Every trip enriches your personal LifeMap!
''';
  }
}