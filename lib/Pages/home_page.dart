// 1. IMPORTAÇÕES
// ===============================================
import 'package:flutter/material.dart'; // Pacote principal do Flutter para construir a interface (Widgets, Cores, etc.).
import 'package:flutter/services.dart'; // Usado aqui para o `FilteringTextInputFormatter`, que permite filtrar o que o usuário pode digitar.
import 'package:projeto_2/Models/endereco.dart'; // Importa o modelo `Endereco`, que define a estrutura dos dados de um endereço.
import 'package:projeto_2/Services/via_cep_service.dart'; // Importa a classe que faz a comunicação com a API do ViaCEP.

// 2. ESTRUTURA DO WIDGET
// ===============================================
// `HomePage` é um `StatefulWidget`, o que significa que ele pode ter um estado interno
// que muda e faz a tela ser redesenhada (ex: mostrar um ícone de loading).
class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title; // Título que será exibido na AppBar.

  @override
  // Cria o estado do widget, que é onde toda a lógica e as variáveis ficam.
  State<HomePage> createState() => _MyHomePageState();
}

// 3. CLASSE DE ESTADO (_MyHomePageState)
// ===============================================
// É aqui que a "mágica" acontece. Esta classe gerencia os dados e a lógica da tela.
class _MyHomePageState extends State<HomePage> {
  // --- VARIÁVEIS DE ESTADO ---

  // Controladores para cada campo de texto. Eles permitem ler, escrever e limpar o texto dos `TextFields`.
  TextEditingController controllerCep = TextEditingController();
  TextEditingController controllerLogradouro = TextEditingController();
  TextEditingController controllerComplemento = TextEditingController();
  TextEditingController controllerBairro = TextEditingController();
  TextEditingController controllerCidade = TextEditingController();
  TextEditingController controllerEstado = TextEditingController();

  // Uma variável para guardar os dados do endereço que virão da API.
  // O `?` indica que ela pode ser nula (ou seja, no início, não temos nenhum endereço).
  Endereco? endereco;

  // Uma "bandeira" (flag) para controlar a exibição do ícone de carregamento.
  // `false` = não está carregando, `true` = carregando.
  bool isLoading = false;

  // Uma instância da nossa classe de serviço, que será usada para chamar a API.
  ViaCepService viaCepService = ViaCepService();

  // --- FUNÇÕES DE LÓGICA ---

  // Função principal que busca o CEP. Ela é `async` porque precisa esperar (`await`) a resposta da internet.
  Future<void> buscarCep(String cep) async {
    clearControllers(); // Limpa os campos de endereço antigos antes de uma nova busca.

    // `setState` avisa o Flutter para redesenhar a tela. Aqui, mudamos `isLoading` para `true` para mostrar o loading.
    setState(() {
      isLoading = true;
    });

    // Bloco `try/catch/finally` para tratar possíveis erros de forma segura.
    try {
      // `await` pausa a execução aqui até que `viaCepService.buscarEndereco` termine e retorne uma resposta.
      Endereco? response = await viaCepService.buscarEndereco(cep);

      // A API do ViaCEP retorna um objeto com erro ou campos nulos se o CEP não for encontrado.
      // Verificamos se `localidade` (cidade) é nula como uma forma de saber se o CEP é inválido.
      if (response?.localidade == null) {
        // Mostra um diálogo de alerta na tela informando que o CEP não foi encontrado.
        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              icon: Icon(
                Icons.warning,
                color: Colors.red,
              ), // Ícone de aviso (cor corrigida).
              title: Text("Atenção"),
              content: Text("CEP não encontrado"),
            );
          },
        );
        controllerCep.clear(); // Limpa o campo do CEP inválido.
        return; // Encerra a função aqui.
      }

      // Se o CEP foi encontrado, atualizamos o estado com os dados recebidos.
      setState(() {
        endereco = response;
      });

      // Chama a função para preencher os `TextFields` com os dados do endereço.
      // O `!` é uma garantia de que `endereco` não é nulo neste ponto.
      setControllerCep(endereco!);
    } catch (erro) {
      // Se ocorrer um erro na chamada (ex: sem internet), ele é capturado aqui.
      // Em um app real, mostraríamos um `SnackBar` ou `Dialog` de erro.
      throw ("Erro ao Buscar CEP: $erro");
    } finally {
      // O bloco `finally` SEMPRE executa, tanto em caso de sucesso quanto de erro.
      // É o lugar perfeito para garantir que o ícone de loading seja desativado.
      setState(() {
        isLoading = false;
      });
    }
  }

  // Função auxiliar para preencher os controladores com os dados do objeto `Endereco`.
  void setControllerCep(Endereco endereco) {
    // O `!` garante ao Dart que esses campos não serão nulos, pois já validamos a resposta da API.
    controllerCep.text = endereco.cep!;
    controllerLogradouro.text = endereco.logradouro!;
    controllerComplemento.text = endereco.complemento!;
    controllerBairro.text = endereco.bairro!;
    controllerCidade.text = endereco.localidade!;
    // `estado` não existe no modelo `Endereco` padrão da ViaCEP, mas `uf` sim. Corrigindo para `uf`.
    controllerEstado.text = endereco.uf!;
  }

  // Função auxiliar para limpar todos os campos de endereço.
  void clearControllers() {
    controllerLogradouro.clear();
    controllerComplemento.clear();
    controllerBairro.clear();
    controllerCidade.clear();
    controllerEstado.clear();
  }

  // 4. CONSTRUÇÃO DA INTERFACE (UI)
  // ===============================================
  @override
  Widget build(BuildContext context) {
    // `Scaffold` é a estrutura básica de uma tela no Material Design (com `AppBar`, `body`, etc.).
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("ViaCEP Api"), // Título da tela.
      ),
      body: Center(
        // Centraliza o conteúdo na tela.
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
          ), // Adiciona espaçamento nas laterais.
          // `Column` organiza seus filhos verticalmente.
          child: Column(
            // `spacing` não é uma propriedade válida de Column, use `SizedBox` ou `Wrap` se precisar de espaçamento.
            mainAxisAlignment:
                MainAxisAlignment.center, // Centraliza a coluna verticalmente.
            children: [
              // --- CAMPO DE TEXTO DO CEP ---
              TextField(
                // Função chamada toda vez que o texto muda.
                onChanged: (valor) {
                  if (valor.isEmpty) {
                    // Se o campo for apagado, limpa os dados do endereço para esconder os outros campos.
                    setState(() {
                      endereco = null;
                    });
                    clearControllers();
                  }
                },
                controller: controllerCep,
                maxLength: 8, // Limita a 8 caracteres.
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ], // Permite apenas a digitação de números.
                keyboardType:
                    TextInputType.number, // Mostra o teclado numérico.
                decoration: InputDecoration(
                  // Ícone que aparece no final do campo de texto.
                  suffixIcon: isLoading
                      // Se `isLoading` for `true`, mostra um indicador de progresso circular.
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: Padding(
                            padding: EdgeInsets.all(15),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      // Se `isLoading` for `false`, mostra um botão com ícone de busca.
                      : IconButton(
                          onPressed: () {
                            buscarCep(
                              controllerCep.text,
                            ); // Chama a função de busca ao ser pressionado.
                          },
                          icon: const Icon(Icons.search),
                        ),
                  border: const OutlineInputBorder(),
                  labelText: "CEP",
                ),
              ),

              // Adiciona um espaço vertical entre os campos
              const SizedBox(height: 20),

              // --- EXIBIÇÃO CONDICIONAL DOS CAMPOS DE ENDEREÇO ---
              // Este `if` é a chave da UI dinâmica: os campos de endereço só são criados e exibidos
              // se a variável `endereco` não for nula (ou seja, após uma busca bem-sucedida).
              if (endereco?.bairro != null)
                Column(
                  children: [
                    // Cada `TextField` abaixo é um campo para uma parte do endereço,
                    // controlado por seu respectivo `TextEditingController`.
                    // A propriedade `spacing` não é válida aqui, então usei `SizedBox` entre eles.
                    TextField(
                      controller: controllerLogradouro,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Logradouro",
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: controllerComplemento,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Complemento",
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: controllerBairro,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Bairro",
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: controllerCidade,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Cidade",
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: controllerEstado,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Estado",
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
