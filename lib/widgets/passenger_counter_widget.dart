import 'package:flutter/material.dart';
import '../utils/styles.dart';

class PassengerCounterWidget extends StatelessWidget {
  final String label;
  final int count;
  final double price;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const PassengerCounterWidget({
    super.key,
    required this.label,
    required this.count,
    required this.price,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyles.counterLabel),
              Text('S/. ${price.toStringAsFixed(2)}', 
                   style: TextStyles.counterPrice),
            ],
          ),
          Row(
            children: [
              IconButton(
                onPressed: onDecrement,
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                ),
                icon: Icon(Icons.remove, color: AppColors.primary),
              ),
              const SizedBox(width: 12),
              Text(
                count.toString(),
                style: TextStyles.counterValue,
              ),
              const SizedBox(width: 12),
              IconButton(
                onPressed: onIncrement,
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
                icon: const Icon(Icons.add, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}