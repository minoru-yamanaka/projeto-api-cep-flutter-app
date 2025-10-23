class Usuario {
  final String id;
  final String nome;
  final String email;
  final String telefone;
  final String cpf;
  final String senha;

  Usuario({
    required this.id,
    required this.nome,
    required this.email,
    required this.telefone,
    required this.cpf,
    required this.senha,
  });

  // -----------------------------------------------------------------
  // SERIALIZAÇÃO (O que você já tem)
  // Converte: Objeto Usuario -> Map (para enviar ao Firebase)
  // -----------------------------------------------------------------
  Map<String, dynamic> toMap() {
    return {
      "nome": nome,
      "email": email,
      "telefone": telefone,
      "senha": senha,
      "cpf": cpf,
    };
  }

  // -----------------------------------------------------------------
  // DESERIALIZAÇÃO (O que você precisa)
  // Converte: Map (vindo do Firebase) -> Objeto Usuario
  // -----------------------------------------------------------------
  factory Usuario.fromMap(Map<String, dynamic> map, String idUser) {
    return Usuario(
      id: "",
      nome: map["nome"],
      email: map["email"],
      telefone: map["telefone"],
      senha: map["senha"],
      cpf: map["cpf"],
    );
  }
}
