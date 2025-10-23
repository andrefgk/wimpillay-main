import 'package:flutter/material.dart';

class AppColors {
  // --- Colores principales basados 100% en tu imagen del bus ---
  // Verde oscuro (el #559C3C de tu paleta)
  static const Color primaryGreenDark = Color(0xFF559C3C); 
  // Verde claro (el #8AD938 o #7CBF39 de tu paleta, usaremos uno como primario)
  static const Color primaryGreenLight = Color(0xFF7CBF39); 
  // Naranja acento (el #F2561D de tu paleta)
  static const Color accentOrange = Color(0xFFF2561D); 

  // --- Colores para el tema de la app (ahora más elegantes) ---
  // Fondo principal (un gris oscuro moderno, menos "negro")
  static const Color primaryBackground = Color(0xFF2E353B); 
  // Fondo de tarjetas/elementos (un gris un poco más claro)
  static const Color cardBackground = Color(0xFF3B444C); 
  // Texto principal
  static const Color lightText = Colors.white; 
  // Texto secundario/hints
  static const Color secondaryText = Color(0xFFB0B0B0); 

  // --- Otros colores útiles ---
  static const Color success = Color(0xFF10B981); // Mantener para mensajes de éxito
  static const Color error = Color(0xFFEF4444);   // Rojo para errores
  static const Color warning = Color(0xFFF59E0B);  // Amarillo para advertencias

  static const Color primaryGreen = Color(0xFF008F39); // Verde principal
   // Naranja acento

  // Tema oscuro (basado en tu ejemplo)
  static const Color darkBackground = Color(0xFF1A1A2E); // Un azul/negro oscuro
  static const Color lightCard = Color(0xFF2D2D44);
  

  // --- Colores anteriores (los mantenemos si los usas en otro lado) ---
  static const Color primary = Color(0xFF2563EB); // [cite: 123]
  static const Color secondary = Color(0xFF64748B); // [cite: 123]
  static const Color background = Color(0xFFF8FAFC); // [cite: 124]
  
}

// ... (Tu clase TextStyles, podemos mantenerla igual por ahora o adaptarla si quieres) ...
// Por ahora, mantendré los TextStyles que ya tenías, pero el ThemeData en main.dart los sobrescribirá o complementará.
class TextStyles {
  static const TextStyle appBarTitle = TextStyle(
    color: Colors.white,
    fontSize: 24,
    fontWeight: FontWeight.bold,
    fontFamily: 'Poppins',
  );
  static const TextStyle appBarSubtitle = TextStyle(
    color: Colors.white,
    fontSize: 14,
    fontWeight: FontWeight.normal,
    fontFamily: 'Poppins',
  );
  static const TextStyle sectionTitle = TextStyle(
    color: AppColors.secondaryText,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    fontFamily: 'Poppins',
  );
  static const TextStyle counterLabel = TextStyle(
    color: Colors.black, // Se ajustará con el tema
    fontSize: 16,
    fontWeight: FontWeight.w600,
    fontFamily: 'Poppins',
  );
  static const TextStyle counterPrice = TextStyle(
    color: AppColors.secondaryText, // Se ajustará con el tema
    fontSize: 14,
    fontWeight: FontWeight.normal,
    fontFamily: 'Poppins',
  );
  static const TextStyle counterValue = TextStyle(
    color: Colors.black, // Se ajustará con el tema
    fontSize: 18,
    fontWeight: FontWeight.bold,
    fontFamily: 'Poppins',
  );
  static const TextStyle totalLabel = TextStyle(
    color: AppColors.secondaryText, // Se ajustará con el tema
    fontSize: 18,
    fontWeight: FontWeight.w600,
    fontFamily: 'Poppins',
  );
  static const TextStyle totalAmount = TextStyle(
    color: AppColors.primaryGreenLight, // Se ajustará con el tema
    fontSize: 24,
    fontWeight: FontWeight.bold,
    fontFamily: 'Poppins',
  );
  static const TextStyle buttonText = TextStyle(
    color: Colors.white,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    fontFamily: 'Poppins',
  );


}
