import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/app_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/monastery_provider.dart';
import 'providers/event_provider.dart';
import 'providers/chat_provider.dart';
import 'screens/main_navigation_screen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'config/firebase_options.dart';

import 'screens/auth/auth_onboarding_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    if (DefaultFirebaseOptions.useLiveFirebase) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  } catch (e) {
    debugPrint('Firebase initialization notice: $e');
  }
  runApp(const Monastery360App());
}

class Monastery360App extends StatelessWidget {
  const Monastery360App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => MonasteryProvider()),
        ChangeNotifierProvider(create: (_) => EventProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
      ],
      child: MaterialApp(
        title: 'Monastery 360',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,
        home: Consumer<AuthProvider>(
          builder: (context, auth, _) {
            if (auth.isAuthenticated) {
              return const MainNavigationScreen();
            } else {
              return const AuthOnboardingScreen();
            }
          },
        ),
      ),
    );
  }
}
