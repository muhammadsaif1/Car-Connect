import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(builder: (ctx, prov, _) {
      if (prov.currentUser == null)
        return const Center(child: Text('Please login to view bookings.'));
      final bookings = prov.myBookings;
      if (bookings.isEmpty)
        return const Center(child: Text('No bookings yet.'));
      return ListView.builder(
        itemCount: bookings.length,
        itemBuilder: (ctx, i) {
          final b = bookings[i];
          return ListTile(
            title: Text('Booking ${b.id} • ${b.date}'),
            subtitle:
                Text('Duration: ${b.durationHours} hrs • Status: ${b.status}'),
          );
        },
      );
    });
  }
}
