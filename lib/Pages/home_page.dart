import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:http/http.dart';
import 'package:projeto_2/Models/endereco.dart';
import 'package:projeto_2/Services/via_cep_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  TextEditingController controllerCep = TextEditingController();
  TextEditingController controllerLogradouro = TextEditingController();
  TextEditingController controllerComplemento = TextEditingController();
  TextEditingController controllerBairro = TextEditingController();
  TextEditingController controllerCidade = TextEditingController();
  TextEditingController controllerEstado = TextEditingController();
  Endereco? endereco; // Variavel pode receber null "?"

  ViaCepService viaCepService = ViaCepService();

  Future<void>buscarCep(String cep) async {
    Endereco? response = await viaCepService.buscarEndereco(cep);

    if (response?.localidade == null) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            icon: Icon(Icons.warning, color: Color(0x0017FFFF)),
            title: Text("Atenção"),
            content: Text("Cep não encontrado"),
          );
        },
      );
      return;
    }
    setState(() {
      endereco = response;
    });

    setControllerCep(endereco!);
  }

  void setControllerCep(Endereco endereco) {
    controllerCep.text = endereco.cep!;
    controllerLogradouro.text = endereco.logradouro!;
    controllerComplemento.text = endereco.complemento!;
    controllerBairro.text = endereco.bairro!;
    controllerCidade.text = endereco.localidade!;
    controllerEstado.text = endereco.estado!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            spacing: 20,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: controllerCep,
                maxLength: 8,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () {
                      buscarCep(controllerCep.text);
                    },
                    icon: Icon(Icons.search),
                  ),
                  border: OutlineInputBorder(),
                  labelText: "CEP",
                ),
              ),
              TextField(
                controller: controllerLogradouro,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Logradouro",
                ),
              ),
              TextField(
                controller: controllerComplemento,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Complemento",
                ),
              ),
              TextField(
                controller: controllerBairro,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Bairro",
                ),
              ),
              TextField(
                controller: controllerCidade,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Cidade",
                ),
              ),
              TextField(
                controller: controllerEstado,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Estado",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
