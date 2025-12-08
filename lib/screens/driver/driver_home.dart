import 'package:flutter/material.dart';
import 'package:wimpillay_main/screens/auth/auth_service.dart';
import 'package:wimpillay_main/utils/styles.dart';
import 'package:wimpillay_main/screens/driver/qr_scanner.dart'; // Crearemos este archivo después

class DriverHome extends StatelessWidget {
  const DriverHome({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final AuthService _authService = AuthService();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Modo Conductor"),
        backgroundColor: theme.appBarTheme.backgroundColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _authService.signOut(),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icono grande del bus
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: AppColors.primaryGreenDark.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.directions_bus,
                size: 80,
                color: AppColors.primaryGreenLight,
              ),
            ),
            const SizedBox(height: 40),
            
            Text(
              "Listo para recibir pasajeros",
              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "Escanea los tickets QR al subir",
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 60),

            // Botón Gigante de Escanear
            SizedBox(
              width: 250,
              height: 60,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accentOrange, // Naranja para resaltar acción
                  foregroundColor: Colors.white,
                  elevation: 5,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                icon: const Icon(Icons.qr_code_scanner, size: 28),
                label: const Text("ESCANEAR TICKET", style: TextStyle(fontSize: 18)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const QrScannerScreen()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}