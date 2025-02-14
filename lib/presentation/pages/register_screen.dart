import 'package:flutter/material.dart';
import '../../data/repositories/auth_service.dart';
import '../../core/theme/app_colors.dart';
import '../widgets/custom_text_field.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isLoading = false;

  // Método para chamar o serviço de registro
  Future<void> _registerUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    String? errorMessage = await _authService.registerUser(
      name: _nameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      password: _passwordController.text,
    );

    setState(() => _isLoading = false);

    if (errorMessage == null) {
      _showSuccessDialog();
    } else {
      _showErrorSnackBar(errorMessage);
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Conta Criada!", style: TextStyle(color: AppColors.onyx)),
        content: Text(
            "Registro realizado com sucesso! Agora você pode fazer login."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
            child: Text("OK", style: TextStyle(color: AppColors.cadetGray)),
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
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
              // Logo do App
              Icon(Icons.car_rental, size: 80, color: AppColors.ashGray),
              SizedBox(height: 20),

              // Título
              Text(
                "Crie sua Conta",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.ashGray),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),

              // Formulário de Registro
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextField(
                        controller: _nameController,
                        label: "Nome Completo",
                        icon: Icons.person),
                    CustomTextField(
                        controller: _emailController,
                        label: "E-mail",
                        icon: Icons.email),
                    CustomTextField(
                        controller: _phoneController,
                        label: "Telefone",
                        icon: Icons.phone),
                    CustomTextField(
                        controller: _passwordController,
                        label: "Senha",
                        icon: Icons.lock,
                        isPassword: true),
                    CustomTextField(
                        controller: _confirmPasswordController,
                        label: "Confirmar Senha",
                        icon: Icons.lock_outline,
                        isPassword: true),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // Botão de Registro
              _isLoading
                  ? CircularProgressIndicator(color: AppColors.cadetGray)
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _registerUser,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.cadetGray,
                          foregroundColor: AppColors.black,
                          padding: EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text("Registrar",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ),

              SizedBox(height: 20),

              // Link para Login
              TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                },
                child: Text("Já tem uma conta? Fazer Login",
                    style: TextStyle(color: AppColors.ashGray)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
