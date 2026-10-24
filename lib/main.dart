import 'package:flutter/material.dart';
import 'screens/main_navigation_screen.dart';

/// Entry point of the Donation Item Manager application.
void main() {
  runApp(const DonationManagerApp());
}

/// DonationManagerApp
///
/// Root widget configuring the Material Design theme, color palette,
/// and landing page.
class DonationManagerApp extends StatelessWidget {
  const DonationManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Donation Item Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        // Primary deep green theme
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1B5E20),
          primary: const Color(0xFF1B5E20),
          secondary: const Color(0xFFFFF8E7),
          surface: Colors.white,
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F9F6),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1B5E20),
          foregroundColor: Colors.white,
          centerTitle: false,
          elevation: 0,
        ),
        cardColor: Colors.white,
      ),
      home: const MainNavigationScreen(),
    );
  }
}
