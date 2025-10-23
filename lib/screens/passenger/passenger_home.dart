import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// Importamos los servicios y modelos necesarios
import 'package:wimpillay_main/models/ticket_model.dart';
import 'package:wimpillay_main/services/ticket_service.dart';
import 'package:wimpillay_main/screens/passenger/ticket_screen.dart';
import 'package:wimpillay_main/screens/auth/login_screen.dart'; // Para el logout

// Convertimos a StatefulWidget para manejar los contadores
class PassengerHome extends StatefulWidget {
  const PassengerHome({super.key});

  @override
  State<PassengerHome> createState() => _PassengerHomeState();
}

class _PassengerHomeState extends State<PassengerHome> {
  // --- Lógica movida desde payment_screen.dart ---
  int adult = 1;
  int university = 0;
  int school = 0;

  final double adultPrice = 1.0;
  final double universityPrice = 0.5;
  final double schoolPrice = 0.5;

  bool _isProcessing = false;

  double get total =>
      adult * adultPrice + university * universityPrice + school * schoolPrice;

  final TicketService _ticketService = TicketService();
  final user = FirebaseAuth.instance.currentUser;

  Future<void> _confirmAndCreateTicket() async {
    // Evitar crear tickets de S/ 0.00
    if (total <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debe seleccionar al menos un pasajero')),
      );
      return;
    }

    // Asegurarnos que el usuario esté logueado
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: No se encontró usuario')),
      );
      return;
    }

    setState(() => _isProcessing = true);
    try {
      final ticket = await _ticketService.createTicket(
        userId: user!.uid, // ¡Enlazamos el ticket al usuario!
        adultCount: adult,
        universityCount: university,
        schoolCount: school,
        totalAmount: total,
      );

      if (!mounted) return;

      // Navegamos a la pantalla del ticket (que ahora mostrará el QR)
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => TicketScreen(ticket: ticket),
        ),
      );
      // Reseteamos contadores después de comprar
      setState(() {
        adult = 1;
        university = 0;
        school = 0;
      });

    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error creando ticket: $e')));
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  // --- Widget del contador (movido desde payment_screen.dart) ---
  Widget _buildCounter({
    required String label,
    required double price,
    required int value,
    required VoidCallback onAdd,
    required VoidCallback onRemove,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.bold)),
                Text('S/. ${price.toStringAsFixed(2)}',
                    style: const TextStyle(color: Colors.grey, fontSize: 14)),
              ],
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline,
                      color: Colors.red, size: 28),
                  onPressed: onRemove,
                ),
                Text(
                  '$value',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline,
                      color: Colors.green, size: 28),
                  onPressed: onAdd,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  // --- Fin de la lógica movida ---

  void _signOut() async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F6F9),
      appBar: AppBar(
        title: const Text('Comprar Ticket'),
        backgroundColor: Colors.teal,
        elevation: 2,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: _signOut,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bienvenido, ${user?.displayName ?? 'Pasajero'}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text('Selecciona la cantidad de pasajeros:'),
            const SizedBox(height: 12),
            
            // --- Widgets de contador insertados ---
            _buildCounter(
              label: 'Adultos',
              price: adultPrice,
              value: adult,
              onAdd: () => setState(() => adult++),
              onRemove: () {
                // Aseguramos que el total no sea 0 por defecto
                if (adult > 0 || (university + school) > 0) {
                  if (adult > 0) setState(() => adult--);
                }
              },
            ),
            _buildCounter(
              label: 'Universitarios',
              price: universityPrice,
              value: university,
              onAdd: () => setState(() => university++),
              onRemove: () {
                if (university > 0) setState(() => university--);
              },
            ),
            _buildCounter(
              label: 'Escolares',
              price: schoolPrice,
              value: school,
              onAdd: () => setState(() => school++),
              onRemove: () {
                if (school > 0) setState(() => school--);
              },
            ),
            // --- Fin de widgets insertados ---

            const SizedBox(height: 20),
            
            // --- Total (movido de payment_screen.dart) ---
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.teal.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total a pagar:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'S/. ${total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            
            // --- Botón de pago (movido de payment_screen.dart) ---
            _isProcessing
                ? const Center(child: CircularProgressIndicator())
                : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.check_circle_outline, size: 26),
                      // Ahora llama a la función que está en este mismo archivo
                      onPressed: _confirmAndCreateTicket, 
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 4,
                      ),
                      label: const Text(
                        'CONFIRMAR PAGO',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
