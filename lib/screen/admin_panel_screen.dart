import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class AdminPanelScreen extends StatelessWidget {
  const AdminPanelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<AppProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Panel')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Pending Users',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...prov.pendingUsers.map((u) => Card(
                  child: ListTile(
                    title: Text(u.name),
                    subtitle: Text('${u.email} • ${u.role}'),
                    trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                      IconButton(
                          icon: const Icon(Icons.check, color: Colors.green),
                          onPressed: () => prov.approveUser(u.id!)),
                      IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: () => prov.rejectUser(u.id!)),
                    ]),
                  ),
                )),
            const SizedBox(height: 12),
            const Text('Pending Cars',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...prov.pendingCars.map((c) => Card(
                  child: ListTile(
                    title: Text(c.model),
                    subtitle: Text(
                        '${c.city} • Rs ${c.rentPerDay.toStringAsFixed(0)}'),
                    trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                      IconButton(
                          icon: const Icon(Icons.check, color: Colors.green),
                          onPressed: () => prov.approveCar(c.id!)),
                      IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: () => prov.rejectCar(c.id!)),
                    ]),
                  ),
                )),
            const SizedBox(height: 12),
            const Text('Pending Drivers',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...prov.pendingDrivers.map((d) => Card(
                  child: ListTile(
                    title: Text(d.name),
                    subtitle: Text(
                        '${d.experienceYears} yrs • Rs ${d.ratePerHour.toStringAsFixed(0)}/hr'),
                    trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                      IconButton(
                          icon: const Icon(Icons.check, color: Colors.green),
                          onPressed: () => prov.approveDriver(d.id!)),
                      IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: () => prov.rejectDriver(d.id!)),
                    ]),
                  ),
                )),
          ]),
        ),
      ),
    );
  }
}
