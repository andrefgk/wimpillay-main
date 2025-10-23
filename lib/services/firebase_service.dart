import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wimpillay_main/models/ticket_model.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Guardamos el ticket y actualizamos su ID
  Future<TicketModel> saveTicket(TicketModel ticket) async {
    try {
      // 1. Añade el documento a la colección 'tickets'
      // Usamos el .toMap() sin el ID la primera vez
      DocumentReference docRef =
          await _db.collection('tickets').add(ticket.toMap());

      // 2. Obtenemos el ID generado
      String ticketId = docRef.id;

      // 3. Creamos la data del QR (¡ahora incluye el ID!)
      String qrData = 'TKT:${ticketId}::USER:${ticket.userId}';

      // 4. Actualizamos el documento con su propio ID y el QR
      await docRef.update({
        'id': ticketId,
        'qrCode': qrData,
      });

      // 5. Devolvemos el modelo completo
      return TicketModel(
        id: ticketId,
        userId: ticket.userId,
        adultCount: ticket.adultCount,
        universityCount: ticket.universityCount,
        schoolCount: ticket.schoolCount,
        totalAmount: ticket.totalAmount,
        purchaseDate: ticket.purchaseDate,
        qrCode: qrData, // Devolvemos con el QR final
        isUsed: ticket.isUsed,
        usedAt: ticket.usedAt,
      );
    } catch (e) {
      print('Error en saveTicket: $e');
      rethrow;
    }
  }

  Future<List<TicketModel>> getTickets() async {
    final snapshot = await _db.collection('tickets').get();
    return snapshot.docs
        .map((doc) => TicketModel.fromMap(doc.data(), doc.id))
        .toList();
  }
}
