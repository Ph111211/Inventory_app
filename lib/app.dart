/// app.dart
import 'package:flutter/material.dart';
import 'tasks/presentation/screens/home_screen.dart';
import 'auth/presentation/pages/login_page.dart';
import 'auth_wrapper.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Manager App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: AuthWrapper(),
      routes: {
        '/login': (_) => const LoginPage(),
        '/home': (BuildContext context) => const HomeScreen(),
      },
    );
  }
}
