// Em: lista_usuarios_page.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// 1. IMPORTANTE: Importe sua classe Usuario!
import 'package:projeto_2/Models/usuario_model.dart';

class ListaUsuariosPage extends StatelessWidget {
  const ListaUsuariosPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _usuariosStream = FirebaseFirestore.instance
        .collection('usuarios')
        .snapshots();

    return Scaffold(
      appBar: AppBar(title: Text("Usuários Cadastrados")),
      body: StreamBuilder<QuerySnapshot>(
        stream: _usuariosStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          // ... (seu código de 'hasError' e 'waiting' continua igual) ...

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(child: Text("Nenhum usuário encontrado."));
          }

          // A MÁGICA ACONTECE AQUI!
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              // Pega o documento do Firebase
              DocumentSnapshot doc = snapshot.data!.docs[index];

              // ---------------------------------------------------
              // MUDANÇA: Use o "tradutor" que criamos!
              // ---------------------------------------------------

              // JEITO ANTIGO (perigoso):
              // Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

              // JEITO NOVO (seguro):
              // Estamos "fabricando" um objeto Usuario
              // usando o 'map' (doc.data()) e o ID (doc.id).
              Usuario usuario = Usuario.fromMap(
                doc.data() as Map<String, dynamic>,
                doc.id,
              );

              // Agora, em vez de usar 'data['nome']',
              // nós usamos 'usuario.nome'.
              return ListTile(
                leading: Icon(Icons.person),
                title: Text(usuario.nome), // <-- MUITO MAIS LIMPO!
                subtitle: Text(usuario.email), // <-- MUITO MAIS SEGURO!
                trailing: Text(usuario.cpf), // <-- FÁCIL!
                onTap: () {
                  print("Clicou em: ${usuario.nome}");
                },
              );
            },
          );
        },
      ),
    );
  }
}
