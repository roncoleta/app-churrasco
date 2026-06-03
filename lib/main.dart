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
      debugShowCheckedModeBanner: false, 
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.redAccent),
        useMaterial3: true,
      ),

      home: const ListaComprasScreen(),
    );
  }
}