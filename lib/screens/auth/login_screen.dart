import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// Importamos el nuevo servicio
import 'auth_service.dart'; 
import 'package:wimpillay_main/screens/passenger/payment_screen.dart';
// Asumiendo que passenger_home es a donde deben ir
import '../passenger/passenger_home.dart'; 

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isSigningIn = false;
  // Creamos una instancia del servicio
  final AuthService _authService = AuthService();

  Future<void> _signInWithGoogle() async {
    try {
      setState(() => _isSigningIn = true);

      // Llamamos a nuestro servicio
      final UserCredential? userCredential =
          await _authService.signInWithGoogle();

      if (userCredential == null) {
        // El usuario canceló o hubo un error
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Inicio de sesión cancelado')),
          );
        }
        return;
      }

      // Si todo salió bien, navegamos
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        // Ahora deberías navegar a un Home, no directo al pago
        MaterialPageRoute(builder: (_) => const PassengerHome()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al iniciar sesión: $e')),
      );
    } finally {
      // Aseguramos que el estado se actualice solo si el widget sigue montado
      if (mounted) {
        setState(() => _isSigningIn = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "WIMPILLAY TRANSPORTES",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(height: 40),
              // Aquí deberías tener tu logo de google en assets
              // Image.asset('assets/google_logo.png', height: 100), 
              const Icon(Icons.directions_bus, size: 100, color: Colors.teal),
              const SizedBox(height: 60),
              _isSigningIn
                  ? const CircularProgressIndicator()
                  : ElevatedButton.icon(
                      // Icono de Google (ejemplo)
                      icon: const Icon(Icons.login), 
                      label: const Text(
                        'Iniciar sesión con Google',
                        style: TextStyle(fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black87,
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(color: Colors.grey),
                        ),
                      ),
                      onPressed: _signInWithGoogle,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
