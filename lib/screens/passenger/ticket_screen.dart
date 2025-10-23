import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:wimpillay_main/models/ticket_model.dart';
import 'package:intl/intl.dart';
import 'package:wimpillay_main/utils/styles.dart'; // Asegúrate de importar esto

class TicketScreen extends StatelessWidget {
  final TicketModel ticket;

  const TicketScreen({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('dd MMM yyyy, hh:mm a');
    final String purchaseDate = formatter.format(ticket.purchaseDate.toDate());
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreenDark, // Un verde más oscuro para el AppBar del ticket
        title: const Text(
          'Ticket Generado',
          style: TextStyle(color: AppColors.lightText),
        ),
        centerTitle: true,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: theme.cardColor, // Usar el color de tarjeta del tema (gris oscuro)
              borderRadius: BorderRadius.circular(20), // Bordes más redondeados
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3), // Sombra más pronunciada
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '¡Pago exitoso!',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: AppColors.primaryGreenLight, // Verde claro para el mensaje
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Muestra este QR al abordar',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.secondaryText,
                  ),
                ),
                const SizedBox(height: 30),

                // --- ¡El QR central y elegante! ---
                if (ticket.qrCode.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.lightText, // Fondo blanco para el QR
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: QrImageView(
                      data: ticket.qrCode,
                      version: QrVersions.auto,
                      size: 220.0,
                      gapless: false,
                      // Puedes añadir un logo aquí si quieres:
                      // embeddedImage: const AssetImage('assets/logo_wimpillay.png'),
                      // embeddedImageStyle: const QrEmbeddedImageStyle(
                      //   size: Size(60, 60),
                      // ),
                      dataModuleStyle: const QrDataModuleStyle(
                          dataModuleShape: QrDataModuleShape.square,
                          color: AppColors.primaryBackground), // Puntos del QR del color de fondo
                      eyeStyle: const QrEyeStyle(
                          eyeShape: QrEyeShape.square,
                          color: AppColors.primaryGreenDark), // Ojos del QR verde oscuro
                    ),
                  )
                else
                  const Icon(
                    Icons.error_outline,
                    color: AppColors.error,
                    size: 150,
                  ),
                // --- Fin del QR ---

                const SizedBox(height: 25),
                Text(
                  'ID: ${ticket.id ?? "..."}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 13,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 20),
                Divider(thickness: 1, color: theme.scaffoldBackgroundColor.withOpacity(0.5)),
                const SizedBox(height: 20),
                _buildInfoRow(context, 'Adultos', '${ticket.adultCount}'),
                _buildInfoRow(context, 'Universitarios', '${ticket.universityCount}'),
                _buildInfoRow(context, 'Escolares', '${ticket.schoolCount}'),
                const SizedBox(height: 15),
                Divider(thickness: 1, color: theme.scaffoldBackgroundColor.withOpacity(0.5)),
                _buildInfoRow(context, 'Total', 'S/. ${ticket.totalAmount.toStringAsFixed(2)}',
                    isBold: true, valueColor: AppColors.accentOrange), // Total en naranja
                _buildInfoRow(context, 'Comprado el', purchaseDate),
                const SizedBox(height: 35),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.home_outlined, color: AppColors.lightText), // Icono de Home
                    label: Text('Volver al Inicio', style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold)),
                    style: theme.elevatedButtonTheme.style?.copyWith(
                      backgroundColor: MaterialStateProperty.all(AppColors.primaryGreenDark), // Botón de regreso verde oscuro
                      padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 14)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper para las filas de información del ticket
  Widget _buildInfoRow(BuildContext context, String label, String value,
      {bool isBold = false, Color? valueColor}) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 16, color: AppColors.secondaryText, height: 1.2)),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: valueColor ?? theme.textTheme.bodyLarge?.color,
            ),
          ),
        ],
      ),
    );
  }
}

