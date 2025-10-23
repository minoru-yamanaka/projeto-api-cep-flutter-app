// 'class Usuario' define o nosso "molde" ou "planta" para um objeto de usuário.
// Tudo no app que se referir a um usuário usará esta estrutura.
class Usuario {
  // 'final' significa que, uma vez que um objeto Usuario é criado,
  // essas propriedades (id, nome, etc.) não podem ser alteradas.
  // Isso é uma boa prática para evitar bugs.
  final String id;
  final String nome;
  final String email;
  final String telefone;
  final String cpf;
  final String senha; // O modelo pode ter a senha (vinda do cadastro),
  // mas nunca a exibiremos na tela de lista ou detalhes.

  // --- CONSTRUTOR ---
  // Este é o método chamado para "construir" ou "criar" um novo
  // objeto Usuario em seu código.
  // Ex: Usuario(id: "123", nome: "Ana", ...);
  // 'required' significa que é obrigatório fornecer cada um desses
  // valores ao criar um Usuario.
  Usuario({
    required this.id,
    required this.nome,
    required this.email,
    required this.telefone,
    required this.cpf,
    required this.senha,
  });

  // -----------------------------------------------------------------
  // SERIALIZAÇÃO (Codificação)
  // Converte: Objeto Usuario -> Map<String, dynamic>
  // Propósito: Preparar os dados para serem *enviados* ao Firebase.
  // O Firebase não entende "Objeto Usuario", mas entende "Map".
  // -----------------------------------------------------------------
  Map<String, dynamic> toMap() {
    // Retorna um Map (um "dicionário") onde as chaves (ex: "nome")
    // são as que o Firebase usará como nome dos campos no documento.
    return {
      "nome": nome,
      "email": email,
      "telefone": telefone,
      "senha": senha, // Enviamos a senha (provavelmente para o cadastro)
      "cpf": cpf,
      // Nota: Não precisamos enviar o 'id' aqui, porque o 'id'
      // será o *nome* do documento no Firebase, e não um campo *dentro* dele.
    };
  }

  // -----------------------------------------------------------------
  // DESERIALIZAÇÃO (Decodificação)
  // Converte: Map (vindo do Firebase) + ID -> Objeto Usuario
  // Propósito: "Fabricar" um objeto Usuario *a partir* dos dados
  // que lemos do Firebase.
  // -----------------------------------------------------------------

  // 'factory' é um tipo especial de construtor que "fabrica" um
  // objeto. É perfeito para isso.
  // Recebe o 'map' (os dados de dentro do documento) e o 'idUser'
  // (o ID do documento em si).
  factory Usuario.fromMap(Map<String, dynamic> map, String idUser) {
    // Chama o construtor padrão (lá de cima) para criar
    // e retornar o novo objeto Usuario.
    return Usuario(
      // ---- CORREÇÃO AQUI ----
      id: idUser, // Usamos o idUser vindo do documento (parâmetro)
      // --- TRATAMENTO DE SEGURANÇA (Null Check) ---
      // '??' significa "Se o valor da esquerda (map["nome"])
      // for NULO, então use o valor da direita ('Nome não informado')".
      // Isso impede que o app quebre se um documento no Firebase
      // estiver com dados faltando.
      nome: map["nome"] ?? 'Nome não informado',
      email: map["email"] ?? 'Email não informado',
      telefone: map["telefone"] ?? 'Telefone não informado',
      // É uma boa prática não carregar a senha real para a memória
      // do app, a menos que seja para um "login".
      // Usar '******' é um placeholder seguro.
      senha: map["senha"] ?? '******',
      cpf: map["cpf"] ?? 'CPF não informado',
    );
  }
}
