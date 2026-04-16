import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';

void main() {
  // Ensure platform channels are ready before any plugin (e.g. shared_prefs).
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    // ProviderScope is Riverpod's root — all providers live here.
    const ProviderScope(
      child: ManulTimeApp(),
    ),
  );
}
