import 'package:flutter/foundation.dart';
import '../models/hr_models.dart';
import '../services/hr_api.dart';

class HrProvider extends ChangeNotifier {
  HrProvider({HrApi? api}) : _api = api ?? HrApi();
  final HrApi _api;
  final List<AttendanceRecord> _attendance = [];
  final List<LeaveRequest> _leaves = [];
  HRUser? _user;
  bool _loading = false;
  String? _error;

  List<AttendanceRecord> get attendance => List.unmodifiable(_attendance);
  List<LeaveRequest> get leaves => List.unmodifiable(_leaves);
  HRUser? get user => _user;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> connectDemo() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _user = await _api.login('ahmed@techcorp.test', 'password');
      await refresh();
    } catch (error) {
      _error = error.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    if (_user == null) return;
    _attendance..clear()..addAll(await _api.fetchAttendance());
    _leaves..clear()..addAll(await _api.fetchLeaves());
    notifyListeners();
  }

  Future<void> clockIn() async {
    await _api.clockIn();
    await refresh();
  }

  Future<void> clockOut() async {
    await _api.clockOut();
    await refresh();
  }

  Future<void> submitLeave(String type, String start, String end, String reason) async {
    await _api.requestLeave(type, start, end, reason);
    await refresh();
  }
}
