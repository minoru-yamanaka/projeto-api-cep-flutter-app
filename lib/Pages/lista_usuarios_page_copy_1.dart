import 'package:flutter/material.dart';
// 1. Você precisa importar o pacote principal do Firestore
import 'package:cloud_firestore/cloud_firestore.dart';

class ListaUsuariosPage extends StatelessWidget {
  const ListaUsuariosPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 2. Crie uma referência para o "stream" (fluxo de dados)
    //    da sua coleção "usuarios".
    //    O .snapshots() notifica o app sobre qualquer mudança (em tempo real).
    final Stream<QuerySnapshot> _usuariosStream = FirebaseFirestore.instance
        .collection('usuarios')
        .snapshots();

    return Scaffold(
      appBar: AppBar(title: Text("Usuários Cadastrados")),
      // 3. Use o StreamBuilder para "ouvir" o stream que você criou
      body: StreamBuilder<QuerySnapshot>(
        stream: _usuariosStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          // 4. Verifique se deu algum erro na conexão
          if (snapshot.hasError) {
            return Center(child: Text('Algo deu errado!'));
          }

          // 5. Enquanto os dados estão sendo carregados, mostre um "loading"
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          // 6. Verifique se não veio nenhum usuário
          if (snapshot.data!.docs.isEmpty) {
            return Center(child: Text("Nenhum usuário encontrado."));
          }

          // 7. SUCESSO! Os dados chegaram. Construa a lista.
          return ListView.builder(
            itemCount: snapshot.data!.docs.length, // O número de usuários
            itemBuilder: (context, index) {
              // Pega o documento (usuário) atual da lista
              DocumentSnapshot doc = snapshot.data!.docs[index];

              // Converte os dados do documento para um Map
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

              // 8. Use um ListTile para exibir os dados de forma organizada
              return ListTile(
                leading: Icon(Icons.person),
                title: Text(data['nome'] ?? 'Nome indisponível'),
                subtitle: Text(data['email'] ?? 'Email indisponível'),
                // Você pode adicionar mais, como:
                // trailing: Text(data['cpf'] ?? ''),
              );
            },
          );
        },
      ),
    );
  }
}
