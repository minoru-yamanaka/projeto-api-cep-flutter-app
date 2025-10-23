import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// 1. IMPORTANTE: Importe sua classe Usuario!
import 'package:projeto_2/Models/usuario_model.dart';
// 2. IMPORTANTE: Importe o modal que criamos!
import 'package:projeto_2/Pages/bottom_sheet_modal.dart';

// Convertemos para StatefulWidget para gerenciar o texto da busca
class ListaUsuariosPage extends StatefulWidget {
  const ListaUsuariosPage({super.key});

  @override
  State<ListaUsuariosPage> createState() => _ListaUsuariosPageState();
}

class _ListaUsuariosPageState extends State<ListaUsuariosPage> {
  // Variável para guardar o que o usuário está digitando
  String _searchQuery = "";

  // Stream principal que busca todos os usuários
  final Stream<QuerySnapshot> _usuariosStream = FirebaseFirestore.instance
      .collection('usuarios')
      .snapshots(); // .snapshots(): "Me avise sempre que algo mudar".

  // --- NOVA FUNÇÃO ---
  // Função para mostrar o BottomSheet que criamos
  void _mostrarDetalhesUsuario(BuildContext context, Usuario usuario) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Permite o modal ser mais alto que 50% da tela
      backgroundColor: Colors
          .transparent, // Fundo transparente para o borderRadius funcionar
      builder: (BuildContext ctx) {
        // Retorna o widget que criamos, passando o usuário selecionado
        return BottomSheetModal(usuario: usuario);
      },
    );
  }
  // --- FIM DA NOVA FUNÇÃO ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Fundo mais suave
      appBar: AppBar(
        // Configurações do AppBar conforme a imagem
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Theme.of(context).primaryColor,
              child: const Icon(Icons.group, size: 20, color: Colors.white),
            ),
            const SizedBox(width: 12),
            // O StreamBuilder aqui é só para o TÍTULO (contagem de usuários)
            StreamBuilder<QuerySnapshot>(
              stream: _usuariosStream,
              builder: (context, snapshot) {
                // Pega a contagem de usuários
                int count = snapshot.data?.docs.length ?? 0;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Usuários",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "$count cadastrados",
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Ação de recarregar (opcional)
              // Como estamos usando Stream, ele atualiza sozinho!
              // Mas podemos manter o botão.
              setState(() {});
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // --- BARRA DE BUSCA ---
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 10.0,
            ),
            child: TextField(
              onChanged: (value) {
                // Atualiza o estado com o texto digitado
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                hintText: "Buscar usuário...",
                prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none, // Sem borda
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 2,
                  ),
                ),
              ),
            ),
          ),
          // --- FIM DA BARRA DE BUSCA ---

          // --- LISTA DE USUÁRIOS ---
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _usuariosStream,
              builder:
                  (
                    BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot,
                  ) {
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text("Erro ao carregar usuários."),
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text("Nenhum usuário encontrado."),
                      );
                    }

                    // --- LÓGICA DE FILTRO DA BUSCA ---
                    final List<DocumentSnapshot>
                    usuariosFiltrados = snapshot.data!.docs.where((doc) {
                      // Converte o documento para o nosso modelo Usuario
                      // Usamos um 'try-catch' para o caso de dados mal formatados
                      try {
                        final usuario = Usuario.fromMap(
                          doc.data() as Map<String, dynamic>,
                          doc.id,
                        );

                        // Se a busca estiver vazia, mostra tudo
                        if (_searchQuery.isEmpty) {
                          return true;
                        }

                        // Verifica se o nome, email ou cpf contêm o texto da busca
                        return usuario.nome.toLowerCase().contains(
                              _searchQuery,
                            ) ||
                            usuario.email.toLowerCase().contains(
                              _searchQuery,
                            ) ||
                            usuario.cpf.toLowerCase().contains(_searchQuery);
                      } catch (e) {
                        print("Erro ao converter usuário: $e");
                        return false; // Não exibe se houver erro de conversão
                      }
                    }).toList();
                    // --- FIM DO FILTRO ---

                    if (usuariosFiltrados.isEmpty) {
                      return const Center(
                        child: Text("Nenhum usuário corresponde à busca."),
                      );
                    }

                    // Usamos a 'usuariosFiltrados' para construir a lista
                    return ListView.builder(
                      padding: const EdgeInsets.all(8.0),
                      itemCount: usuariosFiltrados.length,
                      itemBuilder: (context, index) {
                        // Pega o documento filtrado
                        DocumentSnapshot doc = usuariosFiltrados[index];

                        // JEITO NOVO (seguro):
                        // Converte o 'map' (doc.data()) e o ID (doc.id)
                        // para o nosso objeto Usuario.
                        final Usuario usuario = Usuario.fromMap(
                          doc.data() as Map<String, dynamic>,
                          doc.id,
                        );

                        // --- NOVO CARD DE USUÁRIO ---
                        return Card(
                          elevation: 1.0,
                          shadowColor: Colors.grey.withOpacity(0.2),
                          margin: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 6,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: ListTile(
                            // Define o padding interno do ListTile
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 16,
                            ),
                            // Ação de clique
                            onTap: () {
                              // Chama nossa nova função!
                              _mostrarDetalhesUsuario(context, usuario);
                            },
                            // Avatar
                            leading: CircleAvatar(
                              radius: 25,
                              backgroundColor: Theme.of(
                                context,
                              ).primaryColor.withOpacity(0.1),
                              child: Text(
                                // Pega a primeira letra do nome
                                usuario.nome.isNotEmpty
                                    ? usuario.nome[0].toUpperCase()
                                    : 'U',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            // Nome (Título)
                            title: Text(
                              usuario.nome,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            // Subtítulo (Email e Telefone)
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                // Linha do Email
                                Row(
                                  children: [
                                    Icon(
                                      Icons.email_outlined,
                                      size: 14,
                                      color: Colors.grey[600],
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        usuario.email,
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: 13,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                // Linha do Telefone
                                Row(
                                  children: [
                                    Icon(
                                      Icons.phone_outlined,
                                      size: 14,
                                      color: Colors.grey[600],
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      usuario
                                          .telefone, // <-- Usando o novo campo
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            // Ícone "Mais"
                            trailing: IconButton(
                              icon: Icon(
                                Icons.more_vert,
                                color: Colors.grey[500],
                              ),
                              onPressed: () {
                                // Ação para o "mais" (ex: editar, excluir)
                                print("Menu para: ${usuario.nome}");
                              },
                            ),
                            isThreeLine:
                                true, // Garante altura correta para as 3 linhas
                          ),
                        );
                        // --- FIM DO NOVO CARD ---
                      },
                    );
                  },
            ),
          ),
        ],
      ),
    );
  }
}
