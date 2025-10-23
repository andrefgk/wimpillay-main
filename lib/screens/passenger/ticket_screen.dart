import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart'; // ¡Importamos el paquete de QR!
import 'package:wimpillay_main/models/ticket_model.dart';
import 'package:intl/intl.dart'; // Para formatear la fecha

class TicketScreen extends StatelessWidget {
  final TicketModel ticket;

  const TicketScreen({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    // Formateador de fecha
    final DateFormat formatter = DateFormat('dd MMM yyyy, hh:mm a');
    final String purchaseDate =
        formatter.format(ticket.purchaseDate.toDate());

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text(
          'Ticket Generado',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 2,
        // Quitar la flecha de "atrás" para forzar usar el botón "Volver"
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '¡Pago exitoso!',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Muestra este QR al abordar',
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(height: 20),

                // --- ¡AQUÍ VA EL QR! ---
                if (ticket.qrCode.isNotEmpty)
                  QrImageView(
                    data: ticket.qrCode, // Los datos generados
                    version: QrVersions.auto,
                    size: 250.0,
                    gapless: false,
                    // Opcional: poner un logo en el medio
                    // embeddedImage: AssetImage('assets/logo_bus.png'),
                    // embeddedImageStyle: QrEmbeddedImageStyle(
                    //   size: Size(40, 40),
                    // ),
                  )
                else
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 150,
                  ),
                // --- FIN DEL QR ---

                const SizedBox(height: 20),
                Text(
                  'ID: ${ticket.id ?? "..."}',
                  style: const TextStyle(
                      color: Colors.grey, fontSize: 12, letterSpacing: 0.5),
                ),
                const SizedBox(height: 12),
                const Divider(thickness: 1.2),
                const SizedBox(height: 12),
                _buildRow('Adultos', '${ticket.adultCount}'),
                _buildRow('Universitarios', '${ticket.universityCount}'),
                _buildRow('Escolares', '${ticket.schoolCount}'),
                const SizedBox(height: 10),
                const Divider(thickness: 1.2),
                _buildRow('Total', 'S/. ${ticket.totalAmount.toStringAsFixed(2)}',
                    isBold: true),
                _buildRow('Comprado', purchaseDate),
                const SizedBox(height: 25),
                ElevatedButton.icon(
                  onPressed: () {
                    // Cierra esta pantalla y vuelve al Home
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.done),
                  label: const Text('Volver al inicio'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 20),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 16, color: Colors.black87, height: 1.2)),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: isBold ? Colors.teal : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
