import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:wimpillay_main/models/ticket_model.dart';
import 'package:wimpillay_main/services/ticket_service.dart';
import 'package:wimpillay_main/screens/passenger/ticket_screen.dart';
import 'package:wimpillay_main/utils/styles.dart';

class TicketHistoryScreen extends StatelessWidget {
  const TicketHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final ticketService = TicketService();
    final theme = Theme.of(context);

    if (user == null) return const SizedBox();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        title: const Text("Mis Tickets", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<List<TicketModel>>(
        stream: ticketService.getUserTickets(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.confirmation_num_outlined,
                      size: 80, color: AppColors.secondaryText.withOpacity(0.5)),
                  const SizedBox(height: 16),
                  const Text(
                    "Aún no tienes tickets",
                    style: TextStyle(color: AppColors.secondaryText, fontSize: 18),
                  ),
                ],
              ),
            );
          }

          final tickets = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: tickets.length,
            itemBuilder: (context, index) {
              final ticket = tickets[index];
              return _buildTicketCard(context, ticket);
            },
          );
        },
      ),
    );
  }

  Widget _buildTicketCard(BuildContext context, TicketModel ticket) {
    final theme = Theme.of(context);
    final DateFormat formatter = DateFormat('dd MMM yyyy, hh:mm a');
    final String dateStr = formatter.format(ticket.purchaseDate.toDate());

    // Definir estilos según si está usado o no
    final bool isActive = !ticket.isUsed;
    final Color statusColor = isActive ? AppColors.primaryGreenLight : Colors.grey;
    final String statusText = isActive ? "VÁLIDO" : "USADO";
    final IconData statusIcon = isActive ? Icons.qr_code : Icons.check_circle_outline;

    return Card(
      color: theme.cardColor,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isActive 
            ? const BorderSide(color: AppColors.primaryGreenDark, width: 1) 
            : BorderSide.none,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          // Acción: Si es activo, ver QR. Si es usado, solo ver detalle (o el mismo QR informativo)
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => TicketScreen(ticket: ticket)),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Columna Izquierda: Estado e Icono
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(statusIcon, color: statusColor, size: 30),
              ),
              const SizedBox(width: 16),
              
              // Columna Central: Detalles
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dateStr,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.secondaryText,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "S/. ${ticket.totalAmount.toStringAsFixed(2)}",
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${ticket.adultCount + ticket.universityCount + ticket.schoolCount} Pasajeros",
                      style: const TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),

              // Columna Derecha: Etiqueta de estado
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      statusText,
                      style: const TextStyle(
                        color: Colors.white, // Texto blanco para contraste
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (isActive) ...[
                    const SizedBox(height: 8),
                    const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 14)
                  ]
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}