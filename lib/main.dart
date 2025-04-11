import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:notes_app/screens/add_note_screen.dart';
import 'package:notes_app/screens/auth_gate.dart';
import 'package:notes_app/screens/homescreen.dart';
import 'package:notes_app/screens/loginscreen.dart';
import 'package:notes_app/screens/registerscreen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: const Color(0xFFF3F4F6),
      ),
      home: const AuthGate(), // 🔑 Always check here first
      routes: {
        '/login': (context) => const Loginscreen(),
        '/register': (context) => const Registerscreen(),
        '/home': (context) => const HomeScreen(),
        '/add': (context) => const AddNoteScreen(),
      },
    );
  }
}
