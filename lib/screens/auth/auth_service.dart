import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wimpillay_main/models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // --- Función de Google (la que ya tenías) ---
  Future<UserCredential?> signInWithGoogle() async {
    try {
      debugPrint("Iniciando flujo de Google Sign-In...");
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn(); // [cite: 24]
      if (googleUser == null) {
        debugPrint("Flujo de Google Sign-In cancelado por el usuario.");
        return null;
      }
      debugPrint("Usuario de Google obtenido: ${googleUser.email}");
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      debugPrint("Autenticación de Google obtenida. Creando credencial...");
      final credential = GoogleAuthProvider.credential( // [cite: 25]
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      debugPrint("Iniciando sesión en Firebase...");
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential); // [cite: 26]
      debugPrint("Inicio de sesión en Firebase exitoso: ${userCredential.user?.uid}");
      if (userCredential.user != null) {
        debugPrint("Actualizando datos de usuario en Firestore...");
        await _updateUserData(userCredential.user!, name: userCredential.user!.displayName);
        debugPrint("Datos de usuario actualizados.");
      }
      return userCredential;
    } catch (e) {
      debugPrint('Error detallado en signInWithGoogle: $e'); // [cite: 27]
      return null;
    }
  }

  // --- ¡NUEVA FUNCIÓN DE REGISTRO! ---
  Future<UserCredential?> registerWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      debugPrint("Registrando nuevo usuario...");
      // 1. Crear el usuario en Firebase Auth
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      debugPrint("Usuario creado en Auth: ${userCredential.user?.uid}");

      // 2. Actualizar el perfil de Firebase (añadir el nombre)
      await userCredential.user?.updateDisplayName(name);

      // 3. ¡Guardar datos en Firestore! (La misma función que usa Google)
      if (userCredential.user != null) {
        debugPrint("Creando documento de usuario en Firestore...");
        await _updateUserData(userCredential.user!, name: name);
        debugPrint("Documento de usuario creado.");
      }
      return userCredential;
    } on FirebaseAuthException catch (e) {
      debugPrint("Error de FirebaseAuth en registro: $e");
      // Podrías devolver e.message para mostrarlo en la UI
      return null;
    } catch (e) {
      debugPrint("Error general en registro: $e");
      return null;
    }
  }

  // --- ¡NUEVA FUNCIÓN DE LOGIN! ---
  Future<UserCredential?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      debugPrint("Iniciando sesión con correo...");
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      debugPrint("Inicio de sesión exitoso: ${userCredential.user?.uid}");
      // No necesitamos crear/actualizar datos aquí, solo loguear.
      return userCredential;
    } on FirebaseAuthException catch (e) {
      debugPrint("Error de FirebaseAuth en login: $e");
      return null;
    } catch (e) {
      debugPrint("Error general en login: $e");
      return null;
    }
  }

  // --- Función de Cerrar Sesión (sin cambios) ---
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut(); // [cite: 39]
    debugPrint("Sesión cerrada.");
  }

  // --- Función Interna _updateUserData (MODIFICADA) ---
  // Ahora acepta 'name' porque user.displayName puede ser nulo al registrar
  Future<void> _updateUserData(User user, {String? name}) async {
    final userRef = _db.collection('users').doc(user.uid);
    final userSnapshot = await userRef.get();

    String finalName = name ?? user.displayName ?? 'Sin Nombre';

    if (!userSnapshot.exists) {
      debugPrint("Creando nuevo documento de usuario...");
      final newUser = UserModel( // [cite: 12]
        uid: user.uid,
        email: user.email ?? '',
        name: finalName,
        photoUrl: user.photoURL,
        createdAt: DateTime.now(),
        role: 'passenger', // Rol por defecto
      );
      await userRef.set(newUser.toMap()); // [cite: 13]
    } else {
      debugPrint("Actualizando usuario existente...");
      await userRef.update({
        'name': finalName,
        'photoUrl': user.photoURL,
      });
    }
  }
}