import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wimpillay_main/screens/auth/login_screen.dart';
import 'package:wimpillay_main/screens/passenger/passenger_home.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      // Escucha constantemente el estado de autenticación
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Si está cargando, muestra un spinner
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Si el usuario ESTÁ logueado (snapshot tiene datos)
        if (snapshot.hasData) {
          // Lo mandamos al Home de Pasajero
          return const PassengerHome();
        }

        // Si el usuario NO está logueado
        // Lo mandamos a la pantalla de Login
        return const LoginScreen();
      },
    );
  }
}