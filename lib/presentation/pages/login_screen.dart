import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../data/repositories/auth_service.dart';
import '../../core/theme/app_colors.dart';
import '../widgets/custom_text_field.dart';
import 'home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _loginUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      String userId = userCredential.user!.uid; // 🔹 Obtendo o ID do usuário

      setState(() => _isLoading = false);

      _showSuccessDialog(userId); // 🔹 Agora passa o userId corretamente
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorSnackBar("Erro ao fazer login: ${e.toString()}");
    }
  }

  // Após login bem-sucedido
  void _showSuccessDialog(String userId) {
    // 🔹 Agora recebe userId
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Bem-vindo!"),
        content: Text("Login realizado com sucesso!"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(
                      userId: userId), // 🔹 Passando userId para HomeScreen
                ),
              );
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.car_rental, size: 80, color: AppColors.ashGray),
              SizedBox(height: 20),
              Text(
                "Bem-vindo ao CHC Auto App",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.ashGray),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextField(
                        controller: _emailController,
                        label: "E-mail",
                        icon: Icons.email),
                    CustomTextField(
                        controller: _passwordController,
                        label: "Senha",
                        icon: Icons.lock,
                        isPassword: true),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: Text("Esqueceu a senha?",
                      style: TextStyle(color: AppColors.ashGray)),
                ),
              ),
              SizedBox(height: 20),
              _isLoading
                  ? CircularProgressIndicator(color: AppColors.cadetGray)
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _loginUser,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.cadetGray,
                          foregroundColor: AppColors.black,
                          padding: EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text("Entrar",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RegisterScreen()));
                },
                child: Text("Ainda não tem conta? Registre-se",
                    style: TextStyle(color: AppColors.ashGray)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
