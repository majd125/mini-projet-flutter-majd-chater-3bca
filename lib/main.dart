/*
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'services/auth_service.dart';
import 'services/catalog_service.dart';
import 'services/borrowing_service.dart'; // Make sure this import exists
import 'views/auth/login_screen.dart';
import 'views/main_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        Provider(create: (_) => CatalogService()),
        Provider(create: (_) => BorrowingService()), // This should work now
      ],
      child: MaterialApp(
        title: 'MediAcite',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Color(0xFF8B0000),
            primary: Color(0xFF8B0000),
            secondary: Color(0xFFFFD700),
          ),
          useMaterial3: true,
        ),
        home: AuthWrapper(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    if (authService.isLoading) {
      return Scaffold(
        backgroundColor: Color(0xFF8B0000),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Colors.white),
              SizedBox(height: 20),
              Text(
                'Chargement...',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    return authService.user != null ? MainApp() : LoginScreen();
  }
}
*/
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

import 'services/auth_service.dart';
import 'services/catalog_service.dart';
import 'services/borrowing_service.dart';
import 'services/favorite_service.dart'; // <<--- ADD THIS

import 'views/auth/login_screen.dart';
import 'views/main_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        Provider(create: (_) => CatalogService()),
        Provider(create: (_) => BorrowingService()),
        Provider(create: (_) => FavoriteService()), // <<--- ADD THIS LINE
      ],
      child: MaterialApp(
        title: 'MediAcite',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Color(0xFF8B0000),
            primary: Color(0xFF8B0000),
            secondary: Color(0xFFFFD700),
          ),
          useMaterial3: true,
        ),
        home: AuthWrapper(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    if (authService.isLoading) {
      return Scaffold(
        backgroundColor: Color(0xFF8B0000),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Colors.white),
              SizedBox(height: 20),
              Text(
                'Chargement...',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    return authService.user != null ? MainApp() : LoginScreen();
  }
}
