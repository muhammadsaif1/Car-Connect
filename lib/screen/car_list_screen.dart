import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../widgets/car_card.dart';
import 'car_detail_screen.dart';

class CarListScreen extends StatelessWidget {
  const CarListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(builder: (context, prov, _) {
      final cars = prov.approvedCars;
      if (cars.isEmpty) return const Center(child: Text('No cars available.'));
      return ListView.builder(
        itemCount: cars.length,
        itemBuilder: (ctx, i) {
          final c = cars[i];
          return GestureDetector(
            onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => CarDetailScreen(car: c))),
            child: CarCard(car: c),
          );
        },
      );
    });
  }
}
