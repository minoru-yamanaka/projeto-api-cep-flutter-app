import 'package:flutter/material.dart';

import 'package:projeto_2/Models/usuario_model.dart'; // Importe seu modelo

class BottomSheetModal extends StatelessWidget {
  final Usuario usuario;

  const BottomSheetModal({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    // Usamos o Wrap para que o BottomSheet
    // se ajuste à altura do conteúdo.
    return Wrap(
      children: [
        Container(
          padding: const EdgeInsets.all(24.0),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // "Puxador" do modal
              Container(
                width: 40,
                height: 5,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              // Avatar
              CircleAvatar(
                radius: 40,
                backgroundColor: Theme.of(
                  context,
                ).primaryColor.withOpacity(0.1),
                child: Text(
                  usuario.nome.isNotEmpty ? usuario.nome[0].toUpperCase() : 'U',
                  style: TextStyle(
                    fontSize: 32,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Nome
              Text(
                usuario.nome,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              // Linhas de Informação
              _buildInfoCard(
                context,
                icon: Icons.email_outlined,
                label: 'E-mail',
                value: usuario.email,
              ),
              _buildInfoCard(
                context,
                icon: Icons.phone_outlined,
                label: 'Telefone',
                value: usuario.telefone,
              ),
              _buildInfoCard(
                context,
                icon: Icons.person_pin_outlined, // Ícone para CPF
                label: 'CPF',
                value: usuario.cpf,
              ),
              _buildInfoCard(
                context,
                icon: Icons.fingerprint, // Ícone para ID
                label: 'ID',
                value: usuario.id,
                isId: true, // Para formatar o ID
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Widget auxiliar para criar os cards de informação
  // (E-mail, Telefone, CPF, ID)
  Widget _buildInfoCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    bool isId = false,
  }) {
    return Card(
      elevation: 0,
      color: Colors.grey[50],
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey[600], size: 20),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                    // Se for ID, podemos quebrar a linha para não estourar a tela
                    fontWeight: isId ? FontWeight.normal : FontWeight.w500,
                  ),
                  overflow: isId ? TextOverflow.ellipsis : TextOverflow.clip,
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
