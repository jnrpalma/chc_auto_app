import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  final String userId; // Cada usuário deve ter um ID único

  const HomeScreen({required this.userId, Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? backgroundImageBase64;
  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadBackgroundImage();
  }

  // 🔹 Buscar a imagem do Firestore do usuário logado
  Future<void> _loadBackgroundImage() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.userId) // Usa o ID do usuário logado
          .get();

      if (userDoc.exists && userDoc.data() != null) {
        final userData = userDoc.data() as Map<String, dynamic>;
        if (userData.containsKey("backgroundImage")) {
          setState(() {
            backgroundImageBase64 = userData["backgroundImage"];
          });
        }
      }
    } catch (e) {
      print("Erro ao carregar imagem de fundo: $e");
    }
  }

  // 🔹 Converter a Base64 para Uint8List para exibir no `BoxDecoration`
  DecorationImage? _buildBackgroundImage() {
    if (backgroundImageBase64 != null) {
      Uint8List bytes = base64Decode(backgroundImageBase64!);
      return DecorationImage(
        image: MemoryImage(bytes),
        fit: BoxFit.cover,
      );
    }
    return null;
  }

  // 🔹 Permitir que o usuário escolha uma nova imagem de fundo
  Future<void> _changeBackgroundImage() async {
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    // Converter para Base64
    List<int> imageBytes = await pickedFile.readAsBytes();
    String base64String = base64Encode(imageBytes);

    // Atualizar no Firestore apenas para o usuário logado
    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.userId) // Atualiza apenas o usuário certo
        .update({"backgroundImage": base64String});

    setState(() {
      backgroundImageBase64 = base64String;
    });

    print("Imagem de fundo atualizada!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF000000),
      body: Column(
        children: [
          // 🔹 Seção de Perfil com a Imagem de Fundo Personalizada
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Container(
                height: 240,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  image:
                      _buildBackgroundImage(), // 🔹 Exibir imagem do usuário logado
                  color: backgroundImageBase64 == null
                      ? Color(0xFF363946) // Fundo cinza padrão
                      : null,
                ),
              ),
              Positioned(
                top: 40,
                left: 16,
                child: Icon(Icons.menu, color: Colors.white, size: 30),
              ),
              Positioned(
                top: 40,
                right: 16,
                child: Icon(Icons.receipt_long, color: Colors.white, size: 30),
              ),
              Positioned(
                bottom: -50,
                child: CircleAvatar(
                  radius: 55,
                  backgroundColor: Colors.white,
                  backgroundImage:
                      AssetImage("assets/images/default_profile.png"),
                ),
              ),
              // 🔹 Botão para alterar a imagem de fundo
              Positioned(
                bottom: 10,
                right: 20,
                child: IconButton(
                  icon: Icon(Icons.camera_alt, color: Colors.white),
                  onPressed: _changeBackgroundImage,
                ),
              ),
            ],
          ),

          SizedBox(height: 60),

          // 🔹 Seção de "Serviços Agendados"
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Serviços Agendados",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFB1B6A6),
                ),
              ),
            ),
          ),

          // 🔹 Lista Horizontal de Serviços Agendados
          Container(
            height: 130,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  SizedBox(width: 16),
                  ScheduledServiceCard(
                    title: "Polimento",
                    car: "Toyota Corolla",
                    date: "28/02/2025",
                  ),
                  ScheduledServiceCard(
                    title: "Lavagem Completa",
                    car: "Ford Focus",
                    date: "02/03/2025",
                  ),
                  ScheduledServiceCard(
                    title: "Vitrificação",
                    car: "Chevrolet Onix",
                    date: "05/03/2025",
                  ),
                  SizedBox(width: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 🔹 Card de "Serviços Agendados"
class ScheduledServiceCard extends StatelessWidget {
  final String title;
  final String car;
  final String date;

  const ScheduledServiceCard({
    required this.title,
    required this.car,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Color(0xFF819595),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            SizedBox(height: 4),
            Text(car, style: TextStyle(color: Colors.white70, fontSize: 14)),
            SizedBox(height: 6),
            Text(date, style: TextStyle(color: Colors.white70, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}
