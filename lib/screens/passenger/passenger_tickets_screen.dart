import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PassengerTicketsScreen extends StatelessWidget {
  const PassengerTicketsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final theme = Theme.of(context);

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Mis Tickets')),
        body: const Center(child: Text('Debes iniciar sesión para ver tus tickets.')),
      );
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Mis Tickets'),
        backgroundColor: theme.appBarTheme.backgroundColor,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('tickets')
            .where('userId', isEqualTo: user.uid)
            .orderBy('purchaseDate', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
             return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.red)));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.confirmation_number_outlined, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    'No tienes tickets aún.',
                    style: theme.textTheme.titleLarge?.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final doc = snapshot.data!.docs[index];
              final data = doc.data() as Map<String, dynamic>;
              
              // Obtenemos el ID del documento para mostrarlo
              final String ticketId = doc.id;

              final Timestamp? timestamp = data['purchaseDate'] as Timestamp?;
              final date = timestamp?.toDate() ?? DateTime.now();
              final total = (data['totalAmount'] as num?)?.toDouble() ?? 0.0;
              final adultCount = data['adultCount'] ?? 0;
              final universityCount = data['universityCount'] ?? 0;
              final schoolCount = data['schoolCount'] ?? 0;
              
              final bool isUsed = data['isUsed'] ?? false;
              final String status = isUsed ? 'usado' : 'pagado';
              final qrString = data['qrCode'] ?? 'ERROR-NO-CODE';

              return Card(
                color: theme.cardColor,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  // Pasamos el ticketId a la función del diálogo
                  onTap: () => _showQRDialog(context, qrString, total, status, date, adultCount, universityCount, schoolCount, ticketId),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              DateFormat('dd/MM/yyyy HH:mm').format(date),
                              style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                // Si está usado, fondo rojo suave; si no, verde suave
                                color: isUsed ? Colors.red.withOpacity(0.1) : Colors.green.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                status.toUpperCase(),
                                style: TextStyle(
                                  // Texto Rojo si está usado, Verde si está pagado
                                  color: isUsed ? Colors.red : Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.qr_code_2, 
                              size: 45, 
                              color: isUsed ? Colors.grey : theme.primaryColor
                            ), 
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Total Pagado: S/. ${total.toStringAsFixed(2)}',
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      // Si está usado, ponemos el precio en gris para "apagarlo" visualmente
                                      color: isUsed ? Colors.grey : theme.textTheme.bodyLarge?.color
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Pasajeros: ${adultCount > 0 ? "$adultCount Adulto(s) " : ""}'
                                    '${universityCount > 0 ? "$universityCount Univ. " : ""}'
                                    '${schoolCount > 0 ? "$schoolCount Escolar " : ""}',
                                    style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey)
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // --- FUNCIÓN ACTUALIZADA CON ID Y COLORES ROJOS ---
  void _showQRDialog(BuildContext context, String qrData, double total, String status, DateTime date, int adultCount, int universityCount, int schoolCount, String ticketId) {
    final theme = Theme.of(context);
    final bool isUsed = status == 'usado';
    
    // Definimos el color principal del estado: Rojo si usado, Verde si válido
    final Color stateColor = isUsed ? Colors.red : Colors.green;

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: theme.cardColor,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // --- ÍCONO Y TÍTULO (ROJO O VERDE) ---
                  Icon(
                    isUsed ? Icons.cancel : Icons.check_circle, // Icono X si está usado
                    color: stateColor, 
                    size: 60
                  ),
                  const SizedBox(height: 16),
                  Text(
                    isUsed ? 'Ticket Usado' : '¡Ticket Válido!',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: stateColor // Título en color del estado
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isUsed 
                      ? 'Este ticket ya no puede ser utilizado.' 
                      : 'Escanea este código para viajar',
                    style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
            
                  // --- QR ---
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(isUsed ? 0.3 : 1.0), // Más transparente si está usado
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: QrImageView(
                      data: qrData,
                      version: QrVersions.auto,
                      size: 200,
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                  
                  // --- ID DEL TICKET (NUEVO) ---
                  const SizedBox(height: 12),
                  Text(
                    'ID: $ticketId',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                      fontFamily: 'Arial', // Fuente tipo código para el ID
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        _buildSummaryRow(theme, 'Fecha', DateFormat('dd/MM/yyyy HH:mm').format(date)),
                        const Divider(height: 24),
                        _buildSummaryRow(theme, 'Pasajeros', 
                          '${adultCount > 0 ? "$adultCount Adulto(s)\n" : ""}'
                          '${universityCount > 0 ? "$universityCount Univ.\n" : ""}'
                          '${schoolCount > 0 ? "$schoolCount Escolar" : ""}'
                        ),
                        const Divider(height: 24),
                        
                        // Estado en ROJO o VERDE
                        _buildSummaryRow(theme, 'Estado', status.toUpperCase(), 
                          valueColor: stateColor),
                          
                        const Divider(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Pagado',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.textTheme.bodyLarge?.color
                              ),
                            ),
                            Text(
                              'S/. ${total.toStringAsFixed(2)}',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                // Si está usado, lo ponemos en rojo o gris, según prefieras. 
                                // Aquí lo dejo en el color del estado para ser consistente.
                                color: stateColor 
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
            
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isUsed ? Colors.grey[800] : theme.primaryColor, // Botón gris si está usado
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Cerrar', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSummaryRow(ThemeData theme, String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
        ),
        Text(
          value,
          textAlign: TextAlign.end,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: valueColor ?? theme.textTheme.bodyLarge?.color
          ),
        ),
      ],
    );
  }
}