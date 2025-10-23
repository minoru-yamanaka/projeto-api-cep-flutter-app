import 'package:flutter/material.dart'; // Importa os widgets básicos do Flutter (Material Design).
import 'package:projeto_2/Models/usuario_model.dart'; // Importa sua classe 'Usuario' para saber quais dados esperar.

// Define um novo widget sem estado (StatelessWidget),
// o que significa que ele apenas exibe informações e não muda por conta própria.
class BottomSheetModal extends StatelessWidget {
  // Declara uma variável final 'usuario'. Este widget PRECISA
  // receber um objeto 'Usuario' para funcionar.
  final Usuario usuario;

  // Este é o construtor do widget.
  // 'super.key' é padrão do Flutter.
  // 'required this.usuario' torna obrigatório passar um 'usuario'
  // ao criar este widget (ex: BottomSheetModal(usuario: meuUsuario)).
  const BottomSheetModal({super.key, required this.usuario});

  // O método 'build' é onde a interface do widget é construída.
  @override
  Widget build(BuildContext context) {
    // 'Wrap' é usado para que o BottomSheet se ajuste automaticamente
    // à altura do seu conteúdo interno (a Column).
    return Wrap(
      children: [
        // 'Container' é a "caixa" principal que define o fundo e a forma do modal.
        Container(
          // 'padding' dá um espaço interno de 24 pixels em todos os lados.
          padding: const EdgeInsets.all(24.0),
          // 'decoration' é usado para estilizar a caixa.
          decoration: const BoxDecoration(
            color: Colors.white, // Define a cor de fundo como branca.
            // 'borderRadius' arredonda apenas os cantos superiores (esquerdo e direito).
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), // Canto superior esquerdo.
              topRight: Radius.circular(20.0), // Canto superior direito.
            ),
          ),
          // 'Column' organiza os widgets filhos verticalmente, um abaixo do outro.
          child: Column(
            // 'crossAxisAlignment: CrossAxisAlignment.center' alinha
            // todos os filhos no centro horizontal da coluna.
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // --- 1. O "Puxador" cinza no topo ---
              Container(
                width: 40, // Largura de 40 pixels.
                height: 5, // Altura de 5 pixels.
                margin: const EdgeInsets.only(
                  bottom: 16,
                ), // Espaço de 16 pixels abaixo dele.
                decoration: BoxDecoration(
                  color: Colors.grey[300], // Cor cinza clara.
                  borderRadius: BorderRadius.circular(
                    10,
                  ), // Totalmente arredondado.
                ),
              ),

              // --- 2. O Avatar com a inicial ---
              CircleAvatar(
                radius: 40, // Define o raio (tamanho) do círculo.
                // Define a cor de fundo. Pega a cor primária do seu app
                // (definida no ThemeData) e a torna 10% opaca (muito clara).
                backgroundColor: Theme.of(
                  context,
                ).primaryColor.withOpacity(0.1),
                // O filho do avatar é um texto.
                child: Text(
                  // Lógica ternária:
                  // SE 'usuario.nome' NÃO estiver vazio...
                  // ...ENTÃO usa 'usuario.nome[0].toUpperCase()' (a primeira letra em maiúsculo).
                  // ...SENÃO (se estiver vazio) usa 'U' como padrão.
                  usuario.nome.isNotEmpty ? usuario.nome[0].toUpperCase() : 'U',
                  // Estilo do texto (a letra).
                  style: TextStyle(
                    fontSize: 32, // Tamanho grande.
                    // Cor do texto igual à cor primária do app.
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold, // Em negrito.
                  ),
                ),
              ),
              // 'SizedBox' é uma caixa invisível usada apenas para criar espaço.
              const SizedBox(height: 16), // 16 pixels de espaço vertical.
              // --- 3. O Nome do Usuário ---
              Text(
                usuario.nome, // Exibe o nome completo do usuário.
                style: const TextStyle(
                  fontSize: 22, // Tamanho grande.
                  fontWeight: FontWeight.bold, // Em negrito.
                ),
              ),
              const SizedBox(height: 24), // Mais espaço antes dos detalhes.
              // --- 4. As Linhas de Informação (Cards) ---
              // Aqui chamamos uma função auxiliar (_buildInfoCard) para
              // evitar repetir o mesmo código 4 vezes.
              _buildInfoCard(
                context, // Passa o contexto atual.
                icon: Icons.email_outlined, // Ícone de e-mail.
                label: 'E-mail', // Texto do rótulo.
                value: usuario.email, // O dado vindo do objeto 'usuario'.
              ),
              _buildInfoCard(
                context,
                icon: Icons.phone_outlined, // Ícone de telefone.
                label: 'Telefone',
                value: usuario.telefone, // O dado vindo do objeto 'usuario'.
              ),
              _buildInfoCard(
                context,
                icon: Icons.person_pin_outlined, // Ícone para CPF.
                label: 'CPF',
                value: usuario.cpf, // O dado vindo do objeto 'usuario'.
              ),
              _buildInfoCard(
                context,
                icon: Icons.fingerprint, // Ícone para ID.
                label: 'ID',
                value: usuario.id, // O dado vindo do objeto 'usuario'.
                isId:
                    true, // Passa 'true' para um tratamento especial (quebra de linha).
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- FUNÇÃO AUXILIAR ---
  // Esta função constrói um widget de card de informação.
  // Ela é privada (começa com '_') e só pode ser usada dentro deste arquivo.
  // Ela recebe os parâmetros necessários para montar o card.
  Widget _buildInfoCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    bool isId = false, // Parâmetro opcional, o padrão é 'false'.
  }) {
    // 'Card' é um widget que cria uma caixa com sombra (elevação).
    return Card(
      elevation: 0, // Sem sombra, para um visual mais limpo (flat).
      color: Colors.grey[50], // Um fundo cinza muito sutil.
      margin: const EdgeInsets.only(
        bottom: 12,
      ), // Espaço apenas na parte de baixo do card.
      // 'shape' define a forma do card, aqui com cantos arredondados de 12 pixels.
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      // 'Padding' dá o espaço interno do card.
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        // 'Row' alinha os widgets filhos horizontalmente (lado a lado).
        child: Row(
          children: [
            // 1. O Ícone
            Icon(icon, color: Colors.grey[600], size: 20),
            const SizedBox(width: 16), // Espaço entre o ícone e os textos.
            // 2. A Coluna de Textos (Label e Value)
            Column(
              // Alinha os textos à esquerda.
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 2a. O Rótulo (Label)
                Text(
                  label,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                SizedBox(height: 2), // Pequeno espaço entre os textos.
                // 2b. O Valor (Value)
                Text(
                  value,
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                    // Lógica ternária: SE 'isId' for 'true', usa peso normal,
                    // SENÃO, usa peso 'w500' (semi-negrito).
                    fontWeight: isId ? FontWeight.normal : FontWeight.w500,
                  ),
                  // 'overflow' controla o que acontece se o texto for muito longo.
                  // SE 'isId' for 'true', usa 'ellipsis' (...).
                  // SENÃO, usa 'clip' (corta).
                  overflow: isId ? TextOverflow.ellipsis : TextOverflow.clip,
                  // 'maxLines' define o número máximo de linhas.
                  // SE 'isId' for 'true', permite até 2 linhas.
                  // SENÃO, permite apenas 1 linha.
                  maxLines: isId ? 2 : 1,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
