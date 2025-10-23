import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wimpillay_main/models/ticket_model.dart';
import 'package:wimpillay_main/services/firebase_service.dart';

class TicketService {
  final FirebaseService _firebaseService = FirebaseService();

  Future<TicketModel> createTicket({
    required String userId, // ¡Requerimos el userId!
    required int adultCount,
    required int universityCount,
    required int schoolCount,
    required double totalAmount,
  }) async {
    final ticket = TicketModel(
      userId: userId,
      adultCount: adultCount,
      universityCount: universityCount,
      schoolCount: schoolCount,
      totalAmount: totalAmount,
      purchaseDate: Timestamp.now(),
      qrCode: '', // Se genera y actualiza en FirebaseService
      isUsed: false,
      usedAt: null,
    );

    // saveTicket ahora devuelve el ticket actualizado con ID y QR
    return await _firebaseService.saveTicket(ticket);
  }
}
