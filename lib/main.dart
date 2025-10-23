import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // [cite: 4]
// Importamos el nuevo AuthGate
import 'package:wimpillay_main/screens/auth/auth_gate.dart';
import 'firebase_options.dart'; // [cite: 4]
import 'package:wimpillay_main/utils/styles.dart'; // Importamos los nuevos estilos

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp( // [cite: 5]
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // [cite: 6]

  @override
  Widget build(BuildContext context) { // [cite: 6]
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wimpillay Transportes',
      
      // --- Definimos el tema oscuro ---
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: AppColors.primaryGreen,
        scaffoldBackgroundColor: AppColors.darkBackground,
        cardColor: AppColors.lightCard,
        
        // Estilo de botones
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryGreen, // Botones verdes
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),

        // Estilo de campos de texto
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.lightCard,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          hintStyle: const TextStyle(color: AppColors.secondaryText),
        ),
        
        // Estilo del AppBar
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.darkBackground,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: AppColors.lightText,
            fontSize: 20,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
      // --- Fin del tema ---
      
      home: const AuthGate(), // ¡Este es el cambio principal!
    );
  }
}