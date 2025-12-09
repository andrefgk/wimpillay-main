import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wimpillay_main/models/ticket_model.dart';
import 'package:wimpillay_main/services/ticket_service.dart';
import 'package:wimpillay_main/screens/passenger/ticket_screen.dart';
import 'package:wimpillay_main/screens/auth/auth_service.dart';

class PassengerHome extends StatefulWidget {
  const PassengerHome({super.key});

  @override
  State<PassengerHome> createState() => _PassengerHomeState();
}

class _PassengerHomeState extends State<PassengerHome> {
  int adult = 0;
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
  final AuthService _authService = AuthService();

  Future<void> _confirmAndCreateTicket() async {
    if (total <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debe seleccionar al menos un pasajero')),
      );
      return;
    }
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: No se encontró usuario')),
      );
      return;
    }

    setState(() => _isProcessing = true);
    try {
      final ticket = await _ticketService.createTicket(
        userId: user!.uid,
        adultCount: adult,
        universityCount: university,
        schoolCount: school,
        totalAmount: total,
      );

      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => TicketScreen(ticket: ticket),
        ),
      );
      setState(() {
        adult = 0; // Reiniciar a 1 adulto por defecto (opcional)
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

  void _signOut() async {
    await _authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Comprar Ticket'),
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        centerTitle: true,
        actions: [
          // --- NUEVO BOTÓN: MIS TICKETS ---
          IconButton(
            icon: const Icon(Icons.confirmation_number), // Ícono de ticket
            tooltip: 'Mis Tickets',
            onPressed: () {
              // Navegamos a la ruta que crearemos en el siguiente paso
              Navigator.pushNamed(context, '/passenger-tickets');
            },
          ),
          // --- FIN NUEVO BOTÓN ---
          
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
              style: theme.textTheme.headlineSmall
                  ?.copyWith(color: theme.textTheme.bodyLarge?.color),
            ),
            const SizedBox(height: 12),
            Text(
              'Selecciona la cantidad de pasajeros:',
              style: theme.textTheme.titleMedium
                  ?.copyWith(color: theme.textTheme.bodySmall?.color),
            ),
            const SizedBox(height: 12),
            _buildCounterDark(
              label: 'Adultos',
              price: adultPrice,
              value: adult,
              onAdd: () => setState(() => adult++),
              onRemove: () {
                if (adult > 0 || (university + school) > 0) {
                  if (adult > 0) setState(() => adult--);
                }
              },
            ),
            _buildCounterDark(
              label: 'Universitarios',
              price: universityPrice,
              value: university,
              onAdd: () => setState(() => university++),
              onRemove: () {
                if (university > 0) setState(() => university--);
              },
            ),
            _buildCounterDark(
              label: 'Escolares',
              price: schoolPrice,
              value: school,
              onAdd: () => setState(() => school++),
              onRemove: () {
                if (school > 0) setState(() => school--);
              },
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total a pagar:',
                    style: theme.textTheme.titleLarge
                        ?.copyWith(color: theme.textTheme.bodyLarge?.color),
                  ),
                  Text(
                    'S/. ${total.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: theme.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            _isProcessing
                ? const Center(child: CircularProgressIndicator())
                : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.check_circle_outline, size: 26),
                      onPressed: _confirmAndCreateTicket,
                      style: theme.elevatedButtonTheme.style,
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

  Widget _buildCounterDark({
    required String label,
    required double price,
    required int value,
    required VoidCallback onAdd,
    required VoidCallback onRemove,
  }) {
    final theme = Theme.of(context);
    return Card(
      color: theme.cardColor,
      elevation: 0,
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
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: theme.textTheme.bodyLarge?.color)),
                Text('S/. ${price.toStringAsFixed(2)}',
                    style: TextStyle(
                        color: theme.textTheme.bodySmall?.color, fontSize: 14)),
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
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: theme.textTheme.bodyLarge?.color),
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
}