import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/hr_provider.dart';

class EmployeePortal extends StatefulWidget {
  const EmployeePortal({super.key});
  @override
  State<EmployeePortal> createState() => _EmployeePortalState();
}

class _EmployeePortalState extends State<EmployeePortal> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => context.read<HrProvider>().connectDemo());
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HrProvider>();
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white, surfaceTintColor: Colors.white,
        title: const Row(children: [Icon(Icons.badge_rounded, color: Color(0xFF2C3E50)), SizedBox(width: 10), Text('PeopleFlow', style: TextStyle(fontWeight: FontWeight.w800))]),
        actions: [IconButton(onPressed: provider.refresh, icon: const Icon(Icons.refresh_rounded))],
      ),
      body: provider.loading && provider.user == null ? const Center(child: CircularProgressIndicator()) : ListView(padding: const EdgeInsets.all(16), children: [
        if (provider.error != null) _ErrorBanner(provider.error!),
        _ProfileHeader(user: provider.user),
        const SizedBox(height: 20),
        _AttendanceCard(provider: provider),
        const SizedBox(height: 20),
        const Text('Leave Requests', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
        const SizedBox(height: 10),
        ...provider.leaves.map((leave) => _LeaveTile(leave: leave)),
        if (provider.leaves.isEmpty) const Center(child: Padding(padding: EdgeInsets.all(20), child: Text('No leave requests found.', style: TextStyle(color: Colors.black38)))),
      ]),
      floatingActionButton: FloatingActionButton.extended(onPressed: () => _showLeaveSheet(context), icon: const Icon(Icons.add_rounded), label: const Text('Request Leave')),
    );
  }

  void _showLeaveSheet(BuildContext context) { showModalBottomSheet(context: context, builder: (context) => const _LeaveForm()); }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.user});
  final dynamic user;
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: const Color(0xFF2C3E50), borderRadius: BorderRadius.circular(20)), child: Row(children: [
    const CircleAvatar(radius: 30, backgroundColor: Colors.white24, child: Icon(Icons.person_rounded, color: Colors.white, size: 30)),
    const SizedBox(width: 16),
    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(user?.name ?? 'Employee', style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)), Text(user?.companyName ?? 'Tech Corp', style: const TextStyle(color: Colors.white70, fontSize: 13))]),
  ]));
}

class _AttendanceCard extends StatelessWidget {
  const _AttendanceCard({required this.provider});
  final HrProvider provider;
  @override
  Widget build(BuildContext context) {
    final today = provider.attendance.isEmpty ? null : provider.attendance.first;
    final clockedIn = today?.clockIn != null && today?.clockOut == null;
    return Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.black12)), child: Column(children: [
      const Row(children: [Icon(Icons.timer_rounded, color: Colors.orange, size: 20), SizedBox(width: 8), Text('Daily Attendance', style: TextStyle(fontWeight: FontWeight.w700))]),
      const SizedBox(height: 20),
      Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        _TimeBox(label: 'Clock In', time: today?.clockIn ?? '--:--'),
        _TimeBox(label: 'Clock Out', time: today?.clockOut ?? '--:--'),
      ]),
      const SizedBox(height: 24),
      SizedBox(width: double.infinity, height: 50, child: FilledButton(onPressed: clockedIn ? provider.clockOut : provider.clockIn, style: FilledButton.styleFrom(backgroundColor: clockedIn ? Colors.redAccent : const Color(0xFF2C3E50)), child: Text(clockedIn ? 'Clock Out' : 'Clock In'))),
    ]));
  }
}

class _TimeBox extends StatelessWidget {
  const _TimeBox({required this.label, required this.time});
  final String label; final String time;
  @override
  Widget build(BuildContext context) => Column(children: [Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)), const SizedBox(height: 4), Text(time, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF2C3E50)))]);
}

class _LeaveTile extends StatelessWidget {
  const _LeaveTile({required this.leave});
  final dynamic leave;
  @override
  Widget build(BuildContext context) => Card(elevation: 0, margin: const EdgeInsets.only(bottom: 8), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Colors.black12)), child: ListTile(
    title: Text(leave.type.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
    subtitle: Text('${leave.startDate} to ${leave.endDate}', style: const TextStyle(fontSize: 12)),
    trailing: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: leave.status == 'approved' ? Colors.green.withValues(alpha: 0.1) : Colors.orange.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)), child: Text(leave.status, style: TextStyle(color: leave.status == 'approved' ? Colors.green : Colors.orange, fontWeight: FontWeight.w800, fontSize: 11))),
  ));
}

class _LeaveForm extends StatelessWidget {
  const _LeaveForm();
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(32), child: Column(mainAxisSize: MainAxisSize.min, children: [
    const Text('Request New Leave', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
    const SizedBox(height: 20),
    const TextField(decoration: InputDecoration(labelText: 'Leave Type (sick, annual)', filled: true)),
    const SizedBox(height: 10),
    const Row(children: [Expanded(child: TextField(decoration: InputDecoration(labelText: 'Start Date', filled: true))), SizedBox(width: 10), Expanded(child: TextField(decoration: InputDecoration(labelText: 'End Date', filled: true)))]),
    const SizedBox(height: 24),
    SizedBox(width: double.infinity, height: 50, child: FilledButton(onPressed: () => Navigator.pop(context), child: const Text('Submit Request'))),
  ]));
}

class _ErrorBanner extends StatelessWidget { const _ErrorBanner(this.message); final String message; @override Widget build(BuildContext context) => Container(width: double.infinity, color: const Color(0xFFFFE9E9), padding: const EdgeInsets.all(10), margin: const EdgeInsets.only(bottom: 16), child: Text(message, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Color(0xFF9D2828)))); }
