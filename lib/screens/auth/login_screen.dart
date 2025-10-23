import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'package:wimpillay_main/utils/styles.dart';
import 'package:wimpillay_main/screens/auth/email_login_screen.dart';
import 'package:wimpillay_main/screens/auth/email_register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key}); // [cite: 22]

  @override
  State<LoginScreen> createState() => _LoginScreenState(); // [cite: 22]
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isSigningIn = false;
  final AuthService _authService = AuthService();

  Future<void> _signInWithGoogle() async {
    setState(() => _isSigningIn = true); // [cite: 23, 28]
    try {
      await _authService.signInWithGoogle();
      // El AuthGate se encargará de la navegación,
      // así que no necesitamos Navigator.push aquí. [cite: 26]
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar( // [cite: 27]
          SnackBar(content: Text('Error al iniciar sesión: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSigningIn = false); // [cite: 28]
      }
    }
  }

  @override
  Widget build(BuildContext context) { // [cite: 29]
    return Scaffold(
      body: Stack(
        children: [
          // --- Fondo con formas geométricas (como tu ejemplo) ---
          _buildGeometricShape(
            color: AppColors.primaryGreen.withOpacity(0.3),
            top: -80,
            left: -100,
            size: 250,
          ),
          _buildGeometricShape(
            color: AppColors.accentOrange.withOpacity(0.4),
            bottom: -120,
            right: -150,
            size: 400,
          ),
          _buildGeometricShape(
            color: AppColors.accentOrange.withOpacity(0.5),
            top: 150,
            right: -50,
            size: 150,
          ),
          // --- Fin del fondo ---

          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  const Icon(
                    Icons.directions_bus_filled,
                    size: 100,
                    color: AppColors.primaryGreen,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "WIMPILLAY",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.lightText,
                      letterSpacing: 2,
                    ),
                  ),
                  const Text(
                    "TRANSPORTES", // [cite: 30]
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.secondaryText,
                    ),
                  ),
                  const SizedBox(height: 60),

                  // --- Botón de Iniciar Sesión con Correo ---
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const EmailLoginScreen(),
                          ),
                        );
                      },
                      // Estilo del tema (verde)
                      child: const Text('Iniciar Sesión con Correo'),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // --- Botón de Google ---
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.g_mobiledata, size: 28), // [cite: 33]
                      label: const Text('Iniciar sesión con Google'), // [cite: 33]
                      style: ElevatedButton.styleFrom( // [cite: 34, 35]
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black87,
                      ),
                      onPressed: _isSigningIn ? null : _signInWithGoogle, // [cite: 37]
                    ),
                  ),
                  const SizedBox(height: 40),

                  // --- Botón de Registrarse ---
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const EmailRegisterScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      '¿No tienes una cuenta? Regístrate',
                      style: TextStyle(color: AppColors.secondaryText),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isSigningIn)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(child: CircularProgressIndicator()), // [cite: 32]
            ),
        ],
      ),
    );
  }

  // Helper para las formas del fondo
  Widget _buildGeometricShape({
    required Color color,
    double? top,
    double? bottom,
    double? left,
    double? right,
    required double size,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}