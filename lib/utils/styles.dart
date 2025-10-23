import 'package:flutter/material.dart';

class AppColors {
  // Colores de la marca Wimpillay (basados en el bus)
  static const Color primaryGreen = Color(0xFF008F39); // Verde principal
  static const Color accentOrange = Color(0xFFF37A20); // Naranja acento

  // Tema oscuro (basado en tu ejemplo)
  static const Color darkBackground = Color(0xFF1A1A2E); // Un azul/negro oscuro
  static const Color lightCard = Color(0xFF2D2D44);
  static const Color lightText = Color(0xFFF5F7FA);
  static const Color secondaryText = Color(0xFFB8B8D1);

  // --- Colores anteriores (los mantenemos si los usas en otro lado) ---
  static const Color primary = Color(0xFF2563EB); //
  static const Color secondary = Color(0xFF64748B); //
  static const Color background = Color(0xFFF8FAFC); //
  static const Color success = Color(0xFF10B981); //
  static const Color warning = Color(0xFFF59E0B); //
}

// ... (Tu clase TextStyles existente) ...
class TextStyles {
  static const TextStyle appBarTitle = TextStyle( //
    color: Colors.white,
    fontSize: 24,
    fontWeight: FontWeight.bold,
    fontFamily: 'Poppins',
  );
  static const TextStyle appBarSubtitle = TextStyle( //
    color: Colors.white,
    fontSize: 14,
    fontWeight: FontWeight.normal,
    fontFamily: 'Poppins',
  );
  static const TextStyle sectionTitle = TextStyle( //
    color: AppColors.secondary,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    fontFamily: 'Poppins',
  );
  static const TextStyle counterLabel = TextStyle( //
    color: Colors.black,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    fontFamily: 'Poppins',
  );
  static const TextStyle counterPrice = TextStyle( //
    color: AppColors.secondary,
    fontSize: 14,
    fontWeight: FontWeight.normal,
    fontFamily: 'Poppins',
  );
  static const TextStyle counterValue = TextStyle( //
    color: Colors.black,
    fontSize: 18,
    fontWeight: FontWeight.bold,
    fontFamily: 'Poppins',
  );
  static const TextStyle totalLabel = TextStyle( //
    color: AppColors.secondary,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    fontFamily: 'Poppins',
  );
  static const TextStyle totalAmount = TextStyle( //
    color: AppColors.primary,
    fontSize: 24,
    fontWeight: FontWeight.bold,
    fontFamily: 'Poppins',
  );
  static const TextStyle buttonText = TextStyle( //
    color: Colors.white,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    fontFamily: 'Poppins',
  );
}