import 'package:cloud_firestore/cloud_firestore.dart';

class TicketModel {
  final String? id; // El ID del documento de Firestore
  final String userId; // ¡NUEVO! Para saber quién lo compró
  final int adultCount;
  final int universityCount;
  final int schoolCount;
  final double totalAmount;
  final Timestamp purchaseDate; // Fecha de compra
  final String qrCode; // Datos para el QR
  final bool isUsed; // false al crearse
  final Timestamp? usedAt; // null al crearse

  TicketModel({
    this.id,
    required this.userId,
    required this.adultCount,
    required this.universityCount,
    required this.schoolCount,
    required this.totalAmount,
    required this.purchaseDate,
    required this.qrCode,
    this.isUsed = false, // Valor por defecto
    this.usedAt,
  });

  // Convertir el objeto a un Map para Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id, // Guardamos el id dentro del documento
      'userId': userId,
      'adultCount': adultCount,
      'universityCount': universityCount,
      'schoolCount': schoolCount,
      'totalAmount': totalAmount,
      'purchaseDate': purchaseDate,
      'qrCode': qrCode,
      'isUsed': isUsed,
      'usedAt': usedAt,
    };
  }

  // Crear un objeto desde un Map de Firestore
  factory TicketModel.fromMap(Map<String, dynamic> map, String documentId) {
    return TicketModel(
      id: documentId,
      userId: map['userId'] ?? '',
      adultCount: map['adultCount'] ?? 0,
      universityCount: map['universityCount'] ?? 0,
      schoolCount: map['schoolCount'] ?? 0,
      totalAmount: (map['totalAmount'] ?? 0).toDouble(),
      purchaseDate:
          map['purchaseDate'] ?? Timestamp.now(), // Aseguramos que exista
      qrCode: map['qrCode'] ?? '',
      isUsed: map['isUsed'] ?? false,
      usedAt: map['usedAt'], // Puede ser null
    );
  }
}
