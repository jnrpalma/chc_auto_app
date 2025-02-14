import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  // Método de login
  Future<String?> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return null; // Login bem-sucedido
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return "Usuário não encontrado.";
      } else if (e.code == 'wrong-password') {
        return "Senha incorreta.";
      }
      return "Erro ao fazer login.";
    } catch (e) {
      return "Erro inesperado. Tente novamente.";
    }
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Método para registrar usuário
  Future<String?> registerUser({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      // Criar usuário no Firebase Authentication
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      // Salvar dados no Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'name': name.trim(),
        'email': email.trim(),
        'phone': phone.trim(),
        'createdAt': Timestamp.now(),
      });

      return null; // Indica sucesso
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return "Este e-mail já está cadastrado.";
      } else if (e.code == 'weak-password') {
        return "A senha deve ter pelo menos 6 caracteres.";
      }
      return "Erro ao criar conta.";
    } catch (e) {
      return "Erro inesperado. Tente novamente.";
    }
  }
}
