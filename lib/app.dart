import 'package:flutter/material.dart';
import 'package:projeto_2/Pages/home_page.dart';
import 'package:projeto_2/main.dart';

class VIACEPAPI extends StatelessWidget {
  const VIACEPAPI({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: const HomePage(title: 'Via CEP API'),
    );
  }
}
