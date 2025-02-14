import 'package:flutter/material.dart';
import 'register_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToRegister();
  }

  void _navigateToRegister() async {
    await Future.delayed(Duration(seconds: 3)); // Tempo da splash
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => RegisterScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple, // Cor de fundo
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.car_rental,
                size: 80, color: Colors.white), // Ícone do app
            SizedBox(height: 20),
            Text(
              "CHC Auto App",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            SizedBox(height: 10),
            CircularProgressIndicator(
                color: Colors.white), // Indicador de carregamento
          ],
        ),
      ),
    );
  }
}
