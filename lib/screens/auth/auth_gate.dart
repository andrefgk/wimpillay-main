import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wimpillay_main/screens/auth/login_screen.dart';
import 'package:wimpillay_main/screens/driver/driver_home.dart'; // Importa el home del conductor
import 'package:wimpillay_main/screens/passenger/passenger_home.dart';
import 'package:wimpillay_main/utils/styles.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      // 1. Escuchamos si hay usuario de Firebase Auth
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Estado de carga inicial de Auth
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Si hay usuario logueado...
        if (snapshot.hasData) {
          final User user = snapshot.data!;

          // 2. Escuchamos los cambios en el documento del usuario en Firestore (Roles)
          return StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .snapshots(),
            builder: (context, userSnapshot) {
              
              // Mientras carga los datos de Firestore
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryGreenLight,
                    ),
                  ),
                );
              }

              // Si tenemos datos del usuario
              if (userSnapshot.hasData && userSnapshot.data!.exists) {
                final userData = userSnapshot.data!.data() as Map<String, dynamic>;
                final String role = userData['role'] ?? 'passenger';

                // 3. DECISIÓN DE RUTAS
                if (role == 'driver') {
                  return const DriverHome();
                } else {
                  return const PassengerHome();
                }
              }

              // Si hay error o no hay datos, por defecto al pasajero (o pantalla de error)
              return const PassengerHome();
            },
          );
        }

        // Si NO hay usuario logueado -> Login
        return const LoginScreen();
      },
    );
  }
}