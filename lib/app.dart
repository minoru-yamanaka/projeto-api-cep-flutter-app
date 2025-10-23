import 'package:flutter/material.dart';
import 'package:projeto_2/Pages/form_cadastro_usuario.dart';
import 'package:projeto_2/Pages/home_page.dart';
import 'package:projeto_2/main.dart';

class VIACEPAPI extends StatelessWidget {
  const VIACEPAPI({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const FormCadastroUsuarioPage(),
    );
  }
}
