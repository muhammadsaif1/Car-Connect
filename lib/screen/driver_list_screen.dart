import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import 'add_driver_screen.dart';

class DriverListScreen extends StatelessWidget {
  const DriverListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(builder: (context, prov, _) {
      final drivers = prov.approvedDrivers;
      return Column(children: [
        Expanded(
          child: drivers.isEmpty
              ? const Center(child: Text('No drivers available.'))
              : ListView.builder(
                  itemCount: drivers.length,
                  itemBuilder: (ctx, i) {
                    final d = drivers[i];
                    return ListTile(
                      title: Text(d.name),
                      subtitle: Text(
                          '${d.experienceYears} years • Rs ${d.ratePerHour.toStringAsFixed(0)}/hr'),
                      trailing: const Icon(Icons.person),
                    );
                  },
                ),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: ElevatedButton.icon(
            onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const AddDriverScreen())),
            icon: const Icon(Icons.add),
            label: const Text('Add Driver (Owners)'),
          ),
        ),
      ]);
    });
  }
}
