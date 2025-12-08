import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart'; // El paquete de scanner
import 'package:wimpillay_main/services/ticket_service.dart';
import 'package:wimpillay_main/utils/styles.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  bool _isProcessing = false; // Para evitar lecturas múltiples
  final TicketService _ticketService = TicketService();
  final MobileScannerController _cameraController = MobileScannerController();

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  // Función que procesa el código detectado
  void _handleBarcode(BarcodeCapture capture) async {
    if (_isProcessing) return;
    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final String? code = barcodes.first.rawValue;
    if (code == null) return;

    setState(() => _isProcessing = true);

    // 1. Validar ticket en backend
    final result = await _ticketService.validateTicket(code);

    if (!mounted) return;

    // 2. Mostrar resultado visual
    await _showResultDialog(context, result);

    // 3. Al cerrar el diálogo, permitir leer de nuevo tras un breve delay
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() => _isProcessing = false);
    }
  }

  Future<void> _showResultDialog(BuildContext context, ValidationResult result) async {
    Color statusColor;
    IconData statusIcon;
    String title;

    // Configurar UI según el estado
    switch (result.status) {
      case TicketValidationStatus.valid:
        statusColor = AppColors.success; // Verde
        statusIcon = Icons.check_circle;
        title = "¡Ticket Válido!";
        break;
      case TicketValidationStatus.alreadyUsed:
        statusColor = AppColors.error; // Rojo
        statusIcon = Icons.cancel;
        title = "Ticket Ya Usado";
        break;
      case TicketValidationStatus.notFound:
        statusColor = AppColors.warning; // Amarillo/Naranja
        statusIcon = Icons.warning;
        title = "Ticket No Encontrado";
        break;
      case TicketValidationStatus.error:
        statusColor = Colors.grey;
        statusIcon = Icons.error_outline;
        title = "Error de Lectura";
        break;
    }

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icono grande de estado
            Icon(statusIcon, size: 80, color: statusColor),
            const SizedBox(height: 16),
            
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: statusColor,
              ),
            ),
            const SizedBox(height: 10),
            
            Text(
              result.message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.secondaryText, fontSize: 16),
            ),
            const SizedBox(height: 24),

            // Mostrar detalles si el ticket existe (Válido o Ya Usado)
            if (result.ticket != null) ...[
              const Divider(color: AppColors.secondaryText),
              const SizedBox(height: 10),
              _buildDetailRow("Pasajeros", ""),
              if (result.ticket!.adultCount > 0)
                _buildDetailRow("Adultos", "${result.ticket!.adultCount}"),
              if (result.ticket!.universityCount > 0)
                _buildDetailRow("Universitarios", "${result.ticket!.universityCount}"),
              if (result.ticket!.schoolCount > 0)
                _buildDetailRow("Escolares", "${result.ticket!.schoolCount}"),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primaryBackground,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: _buildDetailRow(
                  "Total Pagado", 
                  "S/. ${result.ticket!.totalAmount.toStringAsFixed(2)}",
                  isBold: true
                ),
              ),
            ],

            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: statusColor,
                  foregroundColor: Colors.white,
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text("CONTINUAR"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.secondaryText, fontSize: 16)),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Escanear QR", style: TextStyle(color: Colors.white)),
      ),
      body: Stack(
        children: [
          // Cámara
          MobileScanner(
            controller: _cameraController,
            onDetect: _handleBarcode,
          ),
          
          // Overlay decorativo (Marco del escáner)
          Center(
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primaryGreenLight, width: 4),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          
          // Texto instruccional
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "Apunta al código QR del pasajero",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}