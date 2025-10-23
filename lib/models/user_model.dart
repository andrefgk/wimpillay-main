import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String name;
  final String? photoUrl;
  final DateTime createdAt;
  final String role; // <-- CAMPO AÑADIDO

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    this.photoUrl,
    required this.createdAt,
    required this.role, // <-- AÑADIDO
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'photoUrl': photoUrl,
      // Usamos Timestamp para Firestore, es mejor que Milliseconds
      'createdAt': Timestamp.fromDate(createdAt), 
      'role': role, // <-- AÑADIDO
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      name: map['name'],
      photoUrl: map['photoUrl'],
      // Convertimos el Timestamp de Firestore a DateTime
      createdAt: (map['createdAt'] as Timestamp).toDate(), 
      role: map['role'] ?? 'passenger', // <-- AÑADIDO (con un valor por defecto)
    );
  }
}
