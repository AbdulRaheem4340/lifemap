import 'package:get/get.dart';
import 'package:lifemap/models/session.dart';
import 'package:lifemap/repositories/session_repository.dart';


class SessionHistoryController extends GetxController {
  final SessionRepository _repository = SessionRepository();

  final RxList<Session> allSessions = <Session>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadHistory();
  }

  void loadHistory() {
    allSessions.value = _repository.getAllSessions();
  }
}

