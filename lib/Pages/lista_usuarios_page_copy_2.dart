// Em: lista_usuarios_page.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// 1. NÃO ESQUEÇA DE IMPORTAR SEU MODELO!
import 'package:projeto_2/Models/usuario_model.dart';

class ListaUsuariosPage extends StatelessWidget {
  const ListaUsuariosPage({super.key});

  @override
  Widget build(BuildContext context) {
    // A referência ao Stream continua a mesma
    final Stream<QuerySnapshot> _usuariosStream = FirebaseFirestore.instance
        .collection('usuarios')
        .snapshots();

    return Scaffold(
      appBar: AppBar(title: Text("Usuários Cadastrados")),
      body: StreamBuilder<QuerySnapshot>(
        stream: _usuariosStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          // As verificações de erro e loading continuam as mesmas
          if (snapshot.hasError) {
            return Center(child: Text('Algo deu errado!'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!.docs.isEmpty) {
            return Center(child: Text("Nenhum usuário encontrado."));
          }

          // SUCESSO! Vamos construir a lista...
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              // 2. Pegue o documento (como antes)
              DocumentSnapshot doc = snapshot.data!.docs[index];

              // 3. FAÇA A MÁGICA DA DESERIALIZAÇÃO AQUI!
              // Transforme o 'doc' (que tem o Map) em um objeto 'Usuario'
              Usuario usuario = Usuario.fromMap(
                doc.data() as Map<String, dynamic>, // Os dados
                doc.id, // O ID do documento
              );

              // 4. AGORA CONSTRUA O WIDGET USANDO O OBJETO
              // Fica muito mais limpo e seguro!
              return ListTile(
                leading: Icon(Icons.person),
                // Agora você acessa 'usuario.nome' em vez de 'data['nome']'
                title: Text(usuario.nome),
                subtitle: Text(usuario.email),
                trailing: Text(usuario.cpf), // Ex: mostrando o CPF
                onTap: () {
                  // Ex: Você pode navegar para uma página de detalhes
                  // e passar o objeto 'usuario' inteiro.
                  print("Clicou em: ${usuario.nome} (ID: ${usuario.id})");
                },
              );
            },
          );
        },
      ),
    );
  }
}
