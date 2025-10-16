import 'dart:io';

import 'package:flutter/material.dart';
import '../models/car.dart';

class CarCard extends StatelessWidget {
  final CarModel car;
  const CarCard({required this.car, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: ListTile(
        leading: car.imagePath != null
            ? Image.file(
                File(car.imagePath!),
                width: 56,
                height: 56,
                fit: BoxFit.cover,
              )
            : Container(
                width: 56,
                height: 56,
                color: Colors.grey[200],
                child: const Icon(Icons.directions_car)),
        title: Text(car.model),
        subtitle:
            Text('${car.city} • Rs ${car.rentPerDay.toStringAsFixed(0)} / day'),
        trailing: car.available
            ? const Text('Available')
            : const Text('Not available'),
      ),
    );
  }
}
