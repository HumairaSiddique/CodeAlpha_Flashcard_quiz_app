import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'themes/app_theme.dart';
import 'screens/main_navigation.dart';
import 'providers/flashcard_provider.dart';
import 'providers/theme_provider.dart';
import 'services/database_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Registers the Hive adapter + opens the flashcards box BEFORE
  // FlashcardProvider tries to read/write anything.
  await DatabaseService().initializeDatabase();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FlashcardProvider()..loadData()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const FlashLearnApp(),
    ),
  );
}

class FlashLearnApp extends StatelessWidget {
  const FlashLearnApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FlashCard Qize',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      home: const MainNavigation(),
    );
  }
}
