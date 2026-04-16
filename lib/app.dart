import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'presentation/screens/home_screen.dart';

/// Root application widget.
/// Kept thin on purpose — routing, localization, etc. can be added here.
class ManulTimeApp extends StatelessWidget {
  const ManulTimeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ManulTime',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const HomeScreen(),
    );
  }
}
