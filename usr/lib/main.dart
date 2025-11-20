import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/idea_generator_screen.dart';
import 'screens/trivia_screen.dart';

void main() {
  runApp(const CouldAIApp());
}

class CouldAIApp extends StatelessWidget {
  const CouldAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CouldAI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C63FF), // AI-like Purple
          brightness: Brightness.dark,
          surface: const Color(0xFF121212),
          background: const Color(0xFF0A0A0A),
        ),
        fontFamily: 'Roboto', // Default, but explicit is good
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        cardTheme: CardTheme(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          color: const Color(0xFF1E1E1E),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/idea-generator': (context) => const IdeaGeneratorScreen(),
        '/trivia': (context) => const TriviaScreen(),
      },
    );
  }
}
