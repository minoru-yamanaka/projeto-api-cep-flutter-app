class Endereco {
  String? cep;
  String? logradouro;
  String? bairro;
  String? localidade;
  String? uf;
  String? estado;
  String? complemento;
  
  Endereco({
    this.cep,
    this.logradouro,
    this.bairro,
    this.localidade,
    this.uf,
    this.estado,
    this.complemento,
  });

  factory Endereco.fromJson(Map<String, dynamic> json) {
    return Endereco(
      cep: json["cep"],
      logradouro: json["logradouro"],
      bairro: json["bairro"],
      localidade: json["localidade"],
      uf: json["uf"],
      estado: json["estado"],
      complemento: json["complemento"],
    );
  }
}
