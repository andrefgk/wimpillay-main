import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/user_model.dart'; // Importamos tu modelo

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Método principal de inicio de sesión
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // 1. Iniciar el flujo de Google Sign In
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // El usuario canceló el flujo
        return null;
      }

      // 2. Obtener los detalles de autenticación de la solicitud
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // 3. Crear una credencial de Firebase
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 4. Iniciar sesión en Firebase
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      // 5. ¡IMPORTANTE! Actualizar/Crear datos del usuario en Firestore
      if (userCredential.user != null) {
        await _updateUserData(userCredential.user!);
      }

      return userCredential;
    } catch (e) {
      debugPrint('Error en signInWithGoogle: $e');
      return null;
    }
  }

  // Método privado para guardar datos del usuario en la colección 'users'
  Future<void> _updateUserData(User user) async {
    final userRef = _db.collection('users').doc(user.uid);
    final userSnapshot = await userRef.get();

    if (!userSnapshot.exists) {
      // Es un usuario nuevo, creamos el documento
      final newUser = UserModel(
        uid: user.uid,
        email: user.email ?? '',
        name: user.displayName ?? 'Sin Nombre',
        photoUrl: user.photoURL,
        createdAt: DateTime.now(),
        role: 'passenger', // Asignamos el rol por defecto
      );
      await userRef.set(newUser.toMap());
    } else {
      // Usuario que regresa, solo actualizamos datos que pueden cambiar
      await userRef.update({
        'name': user.displayName ?? 'Sin Nombre',
        'photoUrl': user.photoURL,
        // No actualizamos 'role' ni 'createdAt' en un login normal
      });
    }
  }

  // Método para cerrar sesión (opcional pero recomendado)
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
