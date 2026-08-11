class AttendanceRecord {
  const AttendanceRecord({required this.id, required this.date, this.clockIn, this.clockOut, required this.status});
  final int id;
  final String date;
  final String? clockIn;
  final String? clockOut;
  final String status;

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) => AttendanceRecord(
        id: int.tryParse(json['id'].toString()) ?? 0,
        date: json['date'] as String? ?? '',
        clockIn: json['clock_in'] as String?,
        clockOut: json['clock_out'] as String?,
        status: json['status'] as String? ?? 'present',
      );
}

class LeaveRequest {
  const LeaveRequest({required this.id, required this.type, required this.startDate, required this.endDate, required this.status, this.reason});
  final int id;
  final String type;
  final String startDate;
  final String endDate;
  final String status;
  final String? reason;

  factory LeaveRequest.fromJson(Map<String, dynamic> json) => LeaveRequest(
        id: int.tryParse(json['id'].toString()) ?? 0,
        type: json['type'] as String? ?? 'annual',
        startDate: json['start_date'] as String? ?? '',
        endDate: json['end_date'] as String? ?? '',
        status: json['status'] as String? ?? 'pending',
        reason: json['reason'] as String?,
      );
}

class HRUser {
  const HRUser({required this.id, required this.name, required this.email, required this.role, this.companyName});
  final int id;
  final String name;
  final String email;
  final String role;
  final String? companyName;

  bool get isHR => role == 'admin' || role == 'hr';

  factory HRUser.fromJson(Map<String, dynamic> json) => HRUser(
        id: int.tryParse(json['id'].toString()) ?? 0,
        name: json['name'] as String? ?? '',
        email: json['email'] as String? ?? '',
        role: json['role'] as String? ?? 'employee',
        companyName: (json['company'] as Map<String, dynamic>?)?['name'] as String?,
      );
}
