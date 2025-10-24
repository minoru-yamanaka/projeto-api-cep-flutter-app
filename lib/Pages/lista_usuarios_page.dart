import 'package:flutter/material.dart'; // Widgets do Material Design (Scaffold, AppBar, etc).
import 'package:cloud_firestore/cloud_firestore.dart'; // Ferramentas do Firebase Firestore (StreamBuilder, QuerySnapshot).

// 1. IMPORTANTE: Importe sua classe Usuario!
import 'package:projeto_2/Models/usuario_model.dart'; // Nosso "molde" de dados de usuário.

// 2. IMPORTANTE: Importe o modal que criamos!
import 'package:projeto_2/Pages/bottom_sheet_modal.dart'; // O widget que exibe os detalhes.

// Convertemos para StatefulWidget (Widget com Estado)
// O motivo: Precisamos "lembrar" o que o usuário está digitando na barra de busca.
// Um StatelessWidget não "lembra" de nada.
class ListaUsuariosPage extends StatefulWidget {
  const ListaUsuariosPage({super.key});

  // O Flutter chama este método para criar a classe de "Estado".
  @override
  State<ListaUsuariosPage> createState() => _ListaUsuariosPageState();
}

// Esta é a classe que guarda o "Estado" (as variáveis que mudam, como o texto da busca).
class _ListaUsuariosPageState extends State<ListaUsuariosPage> {
  // Variável de estado para guardar o que o usuário está digitando.
  // O '_' no início a torna "privada" (só pode ser usada nesta classe).
  String _searchQuery = "";

  // Declaração do "cano" (Stream) de dados.
  // 'final' significa que o *cano* em si não muda (sempre aponta para a mesma coleção).
  final Stream<QuerySnapshot> _usuariosStream = FirebaseFirestore.instance
      .collection('usuarios') // Aponta para a coleção "usuarios" no Firebase.
      .snapshots(); // .snapshots() é o comando que "abre a torneira" e fica
  // ouvindo em tempo real. Qualquer mudança no Firebase
  // será enviada por este "cano" automaticamente.

  // --- NOVA FUNÇÃO ---
  // Função para mostrar o BottomSheet (o modal que sobe).
  // Ela recebe o 'context' (a "árvore" de widgets) e o 'usuario' específico
  // que foi clicado na lista.
  void _mostrarDetalhesUsuario(BuildContext context, Usuario usuario) {
    // Comando do Flutter para "subir" um modal.
    // que o prof pediu 
    showModalBottomSheet(
      context: context, // Onde ele deve aparecer (na tela atual).
      isScrollControlled:
          true, // Permite que o modal ocupe mais de 50% da tela (útil se o teclado abrir).
      backgroundColor: Colors
          .transparent, // Deixa o "fundo" do showModalBottomSheet transparente.
      // Isso é necessário para que o 'borderRadius'
      // que definimos no *nosso* widget (BottomSheetModal)
      // apareça corretamente.
      builder: (BuildContext ctx) {
        // 'builder' constrói o widget que vai *dentro* do modal.
        // Retorna o widget que criamos, passando o usuário selecionado.
        return BottomSheetModal(usuario: usuario);
      },
    );
  }
  // --- FIM DA NOVA FUNÇÃO ---

  // O método 'build' é o que constrói a interface visual da tela.
  @override
  Widget build(BuildContext context) {
    // 'Scaffold' é a estrutura básica da tela (com appBar, body, etc).
    return Scaffold(
      backgroundColor: Colors.grey[100], // Fundo da tela (cinza claro).
      appBar: AppBar(
        // Configurações do AppBar (barra do topo) conforme a imagem.
        elevation: 0, // Remove a sombra (elevação) da AppBar.
        backgroundColor: Colors.white, // Fundo branco.
        foregroundColor: Colors.black87, // Cor dos ícones e textos (preto).
        // 'leading' é o widget à esquerda na AppBar.
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // Ícone de voltar.
          onPressed: () =>
              Navigator.of(context).pop(), // Ação de voltar para tela anterior.
        ),
        // 'title' é o widget principal da AppBar.
        title: Row(
          // Usamos uma 'Row' (Linha) para colocar o ícone e os textos lado a lado.
          children: [
            // O ícone azul com o grupo.
            CircleAvatar(
              radius: 18,
              backgroundColor: Theme.of(context).primaryColor,
              child: const Icon(Icons.group, size: 20, color: Colors.white),
            ),
            const SizedBox(width: 12), // Espaço entre o ícone e os textos.
            // --- TÍTULO DINÂMICO COM STREAMBUILDER ---
            // Usamos um StreamBuilder *aqui também* para mostrar a contagem de usuários.
            // Ele "ouve" o mesmo 'stream' da lista.
            StreamBuilder<QuerySnapshot>(
              stream: _usuariosStream,
              builder: (context, snapshot) {
                // Pega o número de documentos (usuários).
                // 'snapshot.data?.docs.length' -> O '?' protege contra nulo.
                // '?? 0' -> Se o resultado for nulo, usa '0'.
                int count = snapshot.data?.docs.length ?? 0;
                // Retorna uma 'Column' (Coluna) para os dois textos.
                return Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Alinha textos à esquerda.
                  children: [
                    const Text(
                      "Usuários",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "$count cadastrados", // Texto dinâmico com a contagem.
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
        // 'actions' são os widgets à direita na AppBar.
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Como estamos usando Stream, a atualização é automática.
              // Chamar 'setState' vazio é um "truque" para forçar
              // a reconstrução da tela, se necessário.
              setState(() {});
            },
          ),
        ],
      ),
      // 'body' é o conteúdo principal da tela.
      body: Column(
        // O corpo é uma Coluna: Barra de Busca (em cima) e Lista (embaixo).
        children: [
          // --- 1. BARRA DE BUSCA ---
          Container(
            color: Colors.white, // Fundo branco para a área da busca.
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 10.0,
            ),
            // 'TextField' é o campo de entrada de texto.
            child: TextField(
              // 'onChanged' é a função chamada *toda vez* que o usuário digita.
              onChanged: (value) {
                // 'setState' é o comando que "avisa" o Flutter que o estado mudou
                // e que a tela precisa ser redesenhada.
                setState(() {
                  // Atualiza nossa variável de estado com o texto digitado,
                  // já convertido para minúsculas para facilitar a busca.
                  _searchQuery = value.toLowerCase();
                });
              },
              // 'decoration' estiliza o campo de texto.
              decoration: InputDecoration(
                hintText: "Buscar usuário...", // Texto de fundo.
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey[600],
                ), // Ícone (lupa).
                filled: true, // O campo terá cor de fundo.
                fillColor: Colors.grey[100], // Fundo cinza claro.
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                ), // Padding.
                // Borda padrão (quando não está focado).
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0), // Cantos redondos.
                  borderSide: BorderSide.none, // Sem linha de borda.
                ),
                // Borda quando o usuário está digitando (focado).
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor, // Borda azul.
                    width: 2,
                  ),
                ),
              ),
            ),
          ),
          // --- FIM DA BARRA DE BUSCA ---

          // --- 2. LISTA DE USUÁRIOS ---
          // 'Expanded' é ESSENCIAL. Ele diz: "Use todo o espaço vertical
          // que sobrou na tela para este widget".
          // Sem ele, a 'ListView' (que pode ser infinita) daria erro
          // de "overflow" (estourar a tela).
          Expanded(
            // O filho é o 'StreamBuilder' principal que constrói a lista.
            child: StreamBuilder<QuerySnapshot>(
              stream: _usuariosStream, // O "cano" que ele deve "ouvir".
              // 'builder' é a função que constrói a lista com base
              // nos dados que chegam do 'stream'.
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                // --- Tratamento de Estados da Conexão ---
                // 1. Se deu erro:
                if (snapshot.hasError) {
                  return const Center(
                    child: Text("Erro ao carregar usuários."),
                  );
                }
                // 2. Se está esperando (carregando):
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                // 3. Se conectou, mas não veio nada:
                if (snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text("Nenhum usuário encontrado."),
                  );
                }
                // --- Fim do Tratamento de Estados ---

                // --- LÓGICA DE FILTRO DA BUSCA ---
                // Se chegamos aqui, temos dados!
                // Criamos uma nova lista 'usuariosFiltrados'.
                final List<DocumentSnapshot> usuariosFiltrados = snapshot
                    .data!
                    .docs // Pega a lista completa de documentos
                    .where((doc) {
                      // '.where()' é um filtro. Ele passa por cada 'doc'
                      // e decide se o mantém na lista.
                      // Usamos 'try-catch' por segurança: se um usuário
                      // no Firebase estiver com dados mal formatados,
                      // o 'Usuario.fromMap' pode falhar.
                      try {
                        // Converte o 'Map' do Firebase para nosso objeto 'Usuario'.
                        final usuario = Usuario.fromMap(
                          doc.data() as Map<String, dynamic>,
                          doc.id,
                        );

                        // Se a busca estiver vazia, 'return true' (mostra o usuário).
                        if (_searchQuery.isEmpty) {
                          return true;
                        }

                        // A lógica do filtro:
                        // Retorna 'true' (mostra) se o NOME OU o EMAIL OU o CPF
                        // (em minúsculas) contiver o texto da busca.
                        return usuario.nome.toLowerCase().contains(
                              _searchQuery,
                            ) ||
                            usuario.email.toLowerCase().contains(
                              _searchQuery,
                            ) ||
                            usuario.cpf.toLowerCase().contains(_searchQuery);
                      } catch (e) {
                        // Se deu erro ao converter, loga no console e não mostra.
                        print("Erro ao converter usuário: $e");
                        return false;
                      }
                    })
                    .toList(); // Converte o resultado do filtro de volta para uma Lista.
                // --- FIM DO FILTRO ---

                // Se, *depois de filtrar*, a lista ficar vazia...
                if (usuariosFiltrados.isEmpty) {
                  return const Center(
                    child: Text("Nenhum usuário corresponde à busca."),
                  );
                }

                // Finalmente, constrói a 'ListView'.
                // 'ListView.builder' é otimizado: só constrói os itens
                // que estão visíveis na tela.
                return ListView.builder(
                  padding: const EdgeInsets.all(8.0), // Espaço nas bordas.
                  // O número de itens é o da lista *filtrada*.
                  itemCount: usuariosFiltrados.length,
                  // 'itemBuilder' é a função que constrói CADA item da lista.
                  itemBuilder: (context, index) {
                    // Pega o documento filtrado na posição 'index'.
                    DocumentSnapshot doc = usuariosFiltrados[index];

                    // Converte o 'doc' (dados brutos) para o nosso objeto 'Usuario'.
                    final Usuario usuario = Usuario.fromMap(
                      doc.data() as Map<String, dynamic>,
                      doc.id,
                    );

                    // --- NOVO CARD DE USUÁRIO ---
                    // Retorna o 'Card' (cartão) para este usuário.
                    return Card(
                      elevation: 1.0, // Sombra sutil.
                      shadowColor: Colors.grey.withOpacity(0.2),
                      margin: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ), // Margens.
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          12.0,
                        ), // Cantos redondos.
                      ),
                      // 'ListTile' é um widget pronto, perfeito para listas.
                      child: ListTile(
                        // Define o padding interno.
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 16,
                        ),
                        // Ação de clique no item!
                        onTap: () {
                          // Chama a função que criamos, passando o 'usuario'
                          // deste item específico.
                          _mostrarDetalhesUsuario(context, usuario);
                        },
                        // 'leading': O widget à esquerda.
                        leading: CircleAvatar(
                          radius: 25,
                          backgroundColor: Theme.of(
                            context,
                          ).primaryColor.withOpacity(0.1),
                          child: Text(
                            // Pega a primeira letra do nome.
                            usuario.nome.isNotEmpty
                                ? usuario.nome[0].toUpperCase()
                                : 'U',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // 'title': O texto principal.
                        title: Text(
                          usuario.nome,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        // 'subtitle': O texto abaixo do título.
                        // Usamos uma 'Column' para empilhar Email e Telefone.
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            // Linha do Email (Ícone + Texto).
                            Row(
                              children: [
                                Icon(
                                  Icons.email_outlined,
                                  size: 14,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(width: 6),
                                // 'Expanded' impede o email de "estourar" a tela.
                                Expanded(
                                  child: Text(
                                    usuario.email,
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 13,
                                    ),
                                    overflow: TextOverflow
                                        .ellipsis, // Coloca "..." se for longo.
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            // Linha do Telefone (Ícone + Texto).
                            Row(
                              children: [
                                Icon(
                                  Icons.phone_outlined,
                                  size: 14,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  usuario.telefone, // Usa o campo 'telefone'.
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        // 'trailing': O widget à direita.
                        trailing: IconButton(
                          icon: Icon(Icons.more_vert, color: Colors.grey[500]),
                          onPressed: () {
                            // Ação para o menu "mais" (ex: editar, excluir).
                            print("Menu para: ${usuario.nome}");
                          },
                        ),
                        // 'isThreeLine: true' informa ao ListTile que o
                        // subtítulo tem 2 linhas, ajustando a altura
                        // total do card para ficar mais espaçado.
                        isThreeLine: true,
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
