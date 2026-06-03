import 'package:flutter/material.dart';
import 'screens/lista_compras_screen.dart';

void main() {
  runApp(const MeuChurrascoApp());
}

class MeuChurrascoApp extends StatelessWidget {
  const MeuChurrascoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Churrasco',
      debugShowCheckedModeBanner: false, // Tira a faixa de "Debug"
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.redAccent),
        useMaterial3: true,
      ),
      // A primeira tela que o aplicativo vai abrir!
      home: const ListaComprasScreen(),
    );
  }
}