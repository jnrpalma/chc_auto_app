import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/firebase_options.dart';
import 'core/theme/app_colors.dart';
import 'presentation/pages/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CHC Auto App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.onyx,
        scaffoldBackgroundColor: AppColors.black,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: AppColors.ashGray),
          bodyMedium: TextStyle(color: AppColors.ashGray),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.cadetGray,
            foregroundColor: AppColors.black,
          ),
        ),
      ),
      home: SplashScreen(),
    );
  }
}
