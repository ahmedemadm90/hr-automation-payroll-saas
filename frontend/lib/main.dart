import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/hr_provider.dart';
import 'views/employee_portal.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const HrPayrollApp());
}

class HrPayrollApp extends StatelessWidget {
  const HrPayrollApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HrProvider(),
      child: MaterialApp(
        title: 'PeopleFlow HR',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2C3E50)),
          scaffoldBackgroundColor: const Color(0xFFF5F7FB),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
        ),
        home: const EmployeePortal(),
      ),
    );
  }
}
