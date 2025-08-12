import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/splash_screen.dart';
import 'package:untitled/status_screen.dart';
import 'home_screen.dart';
import 'state/app_state.dart';
import 'services/api_service.dart';


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(ApiService())..fetchStatuses(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Seeal File Manager',
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (_) => const SplashScreen(),
        '/root': (_) => const RootScaffold(),
      },
    );
  }
}

class RootScaffold extends StatefulWidget {
  const RootScaffold({super.key});

  @override
  State<RootScaffold> createState() => _RootScaffoldState();
}

class _RootScaffoldState extends State<RootScaffold> {
  int _index = 0;
  final _pages = [const HomeScreen(), const StatusScreen()];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "Status"),
        ],
      ),
    );
  }
}
