import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/hr_models.dart';

class HrApi {
  HrApi({http.Client? client, this.baseUrl = 'http://10.0.2.2:8000/api/v1'}) : _client = client ?? http.Client();
  final http.Client _client;
  final String baseUrl;
  String? token;
  Map<String, String> get headers => {'Accept': 'application/json', 'Content-Type': 'application/json', if (token != null) 'Authorization': 'Bearer $token'};

  Future<HRUser> login(String email, String password) async {
    final response = await _client.post(Uri.parse('$baseUrl/auth/login'), headers: headers, body: jsonEncode({'email': email, 'password': password}));
    _check(response);
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    token = json['token'] as String;
    return HRUser.fromJson(json['user'] as Map<String, dynamic>);
  }

  Future<List<AttendanceRecord>> fetchAttendance() async {
    final response = await _client.get(Uri.parse('$baseUrl/employee/attendance'), headers: headers);
    _check(response);
    final data = jsonDecode(response.body) as List<dynamic>? ?? [];
    return data.map((item) => AttendanceRecord.fromJson(item as Map<String, dynamic>)).toList();
  }

  Future<void> clockIn({String? lat, String? lon}) async {
    final response = await _client.post(Uri.parse('$baseUrl/employee/attendance/clock-in'), headers: headers, body: jsonEncode({'latitude': lat, 'longitude': lon}));
    _check(response);
  }

  Future<void> clockOut() async {
    final response = await _client.post(Uri.parse('$baseUrl/employee/attendance/clock-out'), headers: headers);
    _check(response);
  }

  Future<List<LeaveRequest>> fetchLeaves() async {
    final response = await _client.get(Uri.parse('$baseUrl/employee/leave-requests'), headers: headers);
    _check(response);
    final data = jsonDecode(response.body) as List<dynamic>? ?? [];
    return data.map((item) => LeaveRequest.fromJson(item as Map<String, dynamic>)).toList();
  }

  Future<void> requestLeave(String type, String start, String end, String reason) async {
    final response = await _client.post(Uri.parse('$baseUrl/employee/leave-requests'), headers: headers, body: jsonEncode({'type': type, 'start_date': start, 'end_date': end, 'reason': reason}));
    _check(response);
  }

  void _check(http.Response response) { if (response.statusCode < 200 || response.statusCode >= 300) throw Exception('API error ${response.statusCode}: ${response.body}'); }
}
