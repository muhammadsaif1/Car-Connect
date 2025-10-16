import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/driver.dart';

class AddDriverScreen extends StatefulWidget {
  const AddDriverScreen({super.key});

  @override
  State<AddDriverScreen> createState() => _AddDriverScreenState();
}

class _AddDriverScreenState extends State<AddDriverScreen> {
  final _form = GlobalKey<FormState>();
  String name = '';
  int exp = 0;
  double rate = 0;

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<AppProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: const Text('Add Driver')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Form(
              key: _form,
              child: Column(children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Driver Name'),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Enter name' : null,
                  onSaved: (v) => name = v!.trim(),
                ),
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Experience Years'),
                  keyboardType: TextInputType.number,
                  validator: (v) => v == null || v.isEmpty ? 'Enter exp' : null,
                  onSaved: (v) => exp = int.tryParse(v!) ?? 0,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Rate per hour'),
                  keyboardType: TextInputType.number,
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Enter rate' : null,
                  onSaved: (v) => rate = double.tryParse(v!) ?? 0,
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () async {
                    if (!_form.currentState!.validate()) return;
                    _form.currentState!.save();
                    await prov.addDriver(DriverModel(
                        name: name,
                        experienceYears: exp,
                        ratePerHour: rate,
                        approvalStatus: 'pending'));
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Driver added (pending approval).')));
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Add Driver'),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
