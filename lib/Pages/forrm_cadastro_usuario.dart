import 'package:flutter/material.dart';
import 'package:projeto_2/Models/usuario_model.dart';
import 'package:projeto_2/Services/firebase_service.dart';

class FormCadastroUsuarioPage extends StatefulWidget {
  const FormCadastroUsuarioPage({super.key});

  @override
  State<FormCadastroUsuarioPage> createState() =>
      _FormCadastroUsuarioPageState();
}

class _FormCadastroUsuarioPageState extends State<FormCadastroUsuarioPage> {
  TextEditingController nomeController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController telefoneController = TextEditingController();
  TextEditingController cpfController = TextEditingController();
  TextEditingController senhaController = TextEditingController();
  TextEditingController confirmacaoController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final FirebaseService _firebaseService = FirebaseService(
    collectionName: "usuarios",
  );

  Future<void> salvarUsuario() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    Usuario usuario = Usuario(
      id: "",
      nome: nomeController.text,
      email: emailController.text,
      telefone: telefoneController.text,
      cpf: cpfController.text,
      senha: senhaController.text,
    );

    try {
      String idUser = await _firebaseService.create(usuario.toMap());

      if (idUser.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Column(
              children: [
                Text(
                  "Sucesso",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Usuário cadastrado com sucesso!",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        );
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          child: Column(
            children: [
              Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 15,
                  children: [
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "O campo nome é obrigatório";
                        }
                        return null;
                      },
                      controller: nomeController,
                      decoration: InputDecoration(
                        labelText: "Nome",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    TextFormField(
                      validator: (value) {
                        final RegExp emailRegex = RegExp(
                          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                        );
                        if (!emailRegex.hasMatch(value!)) {
                          return "Email inválido";
                        }

                        return null;
                      },
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "O campo telefone é obrigatório";
                        }
                        return null;
                      },
                      controller: telefoneController,
                      decoration: InputDecoration(
                        labelText: "Telefone",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "O campo cpf é obrigatório";
                        }
                        return null;
                      },
                      controller: cpfController,
                      decoration: InputDecoration(
                        labelText: "CPF",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "O campo senha é obrigatório";
                        }
                        return null;
                      },
                      controller: senhaController,
                      decoration: InputDecoration(
                        labelText: "Senha",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "A confirmação da senha deve ser digitada";
                        }
                        if (value != senhaController.text) {
                          return "A confirmação da senha está incorreta";
                        }
                        return null;
                      },
                      controller: confirmacaoController,
                      decoration: InputDecoration(
                        labelText: "Confirme a senha",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: salvarUsuario,
                      child: Text("Cadastrar"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
