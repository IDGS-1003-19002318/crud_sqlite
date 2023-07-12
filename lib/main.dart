import 'package:flutter/material.dart';
import 'package:crud_sqlite/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRUD con SQLite',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      themeMode: ThemeMode.light,
      home: const MyHomePage(),
    );
  }
}
