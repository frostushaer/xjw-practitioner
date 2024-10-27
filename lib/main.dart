import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/dashboard_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Practitioner App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignUpScreen(),
        '/dashboard': (context) {
          final String? practitionerId =
              ModalRoute.of(context)?.settings.arguments as String?;
          if (practitionerId == null) {
            // Handle the case where the practitionerId is null, maybe redirect to login
            // Optionally, you can show an error message or redirect to login
            return LoginScreen(); // Redirecting to LoginScreen for safety
          }
          return DashboardScreen(practitionerId: practitionerId);
        },
      },
    );
  }
}
