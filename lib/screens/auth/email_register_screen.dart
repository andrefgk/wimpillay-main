import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'package:wimpillay_main/utils/styles.dart';
// ¡Importamos la pantalla de Login para la navegación!
import 'package:wimpillay_main/screens/auth/email_login_screen.dart';

class EmailRegisterScreen extends StatefulWidget {
  const EmailRegisterScreen({super.key});

  @override
  State<EmailRegisterScreen> createState() => _EmailRegisterScreenState();
}

class _EmailRegisterScreenState extends State<EmailRegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();
  bool _isLoading = false;

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);
    
    final userCredential = await _authService.registerWithEmail(
      name: _nameController.text,
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (!mounted) return;

    // --- ¡AQUÍ ESTÁ LA NUEVA LÓGICA! ---
    if (userCredential != null) {
      // 1. ¡Éxito! Inmediatamente cerramos la sesión que se creó
      await _authService.signOut();

      // 2. Detenemos el indicador de carga ANTES de mostrar el diálogo
      setState(() => _isLoading = false);
      
      // 3. Mostramos el diálogo de éxito
      showDialog(
        context: context,
        barrierDismissible: false, // No se puede cerrar tocando fuera
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            backgroundColor: AppColors.lightCard,
            title: const Text(
              "¡Cuenta Creada!",
              style: TextStyle(color: AppColors.lightText),
            ),
            content: const Text(
              "Tu cuenta se ha registrado exitosamente.",
              style: TextStyle(color: AppColors.secondaryText),
            ),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primaryGreen,
                ),
                child: const Text("Iniciar Sesión"),
                onPressed: () {
                  // 1. Cierra el diálogo
                  Navigator.of(dialogContext).pop(); 
                  // 2. Reemplaza esta pantalla (Registro) por la de Login
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => const EmailLoginScreen(),
                    ),
                  );
                },
              ),
            ],
          );
        },
      );
      // Ya no necesitamos la navegación anterior

    } else {
      // Si falló, mostramos el error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al registrar. El correo ya podría estar en uso.'),
          backgroundColor: Colors.red,
        ),
      );
      // Y detenemos la carga
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
    // --- FIN DE LA NUEVA LÓGICA ---
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Cuenta'),
        backgroundColor: AppColors.darkBackground,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Crea tu cuenta',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.lightText,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Completa tus datos para empezar',
                  style: TextStyle(color: AppColors.secondaryText),
                ),
                const SizedBox(height: 40),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre Completo',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  keyboardType: TextInputType.name,
                  validator: (value) =>
                      value!.isEmpty ? 'Ingresa tu nombre' : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Correo Electrónico',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty) return 'Ingresa un correo';
                    if (!value.contains('@')) return 'Correo no válido';
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Contraseña',
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) return 'Ingresa una contraseña';
                    if (value.length < 6) return 'Debe tener al menos 6 caracteres';
                    return null;
                  },
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: _register,
                          child: const Text('REGISTRARME'),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}