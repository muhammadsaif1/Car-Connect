import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/car.dart';
import '../providers/app_provider.dart';
import '../models/booking.dart';
import 'package:intl/intl.dart';

class CarDetailScreen extends StatefulWidget {
  final CarModel car;
  const CarDetailScreen({required this.car, super.key});

  @override
  State<CarDetailScreen> createState() => _CarDetailScreenState();
}

class _CarDetailScreenState extends State<CarDetailScreen> {
  DateTime? selectedDate;
  final _durationCtrl = TextEditingController(text: '1');
  bool withDriver = false;
  bool loading = false;

  Future<void> _book(BuildContext context) async {
    final prov = Provider.of<AppProvider>(context, listen: false);
    if (prov.currentUser == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Please login to book.')));
      return;
    }
    if (selectedDate == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Choose a date.')));
      return;
    }
    final dur = int.tryParse(_durationCtrl.text) ?? 1;
    setState(() => loading = true);
    await prov.addBooking(BookingModel(
      userId: prov.currentUser!.id!,
      carId: widget.car.id,
      driverId:
          withDriver ? -1 : null, // -1 stands for "need driver" placeholder
      date: DateFormat('yyyy-MM-dd').format(selectedDate!),
      durationHours: dur,
    ));
    setState(() => loading = false);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Booking created (pending).')));
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.car;
    return Scaffold(
      appBar: AppBar(title: Text(c.model)),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(children: [
          if (c.imagePath != null)
            Image.file(File(c.imagePath!), height: 180, fit: BoxFit.cover),
          const SizedBox(height: 8),
          Text(c.model,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text('${c.city} • Rs ${c.rentPerDay.toStringAsFixed(0)}/day'),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(
              child: Text(selectedDate == null
                  ? 'Select date'
                  : DateFormat('yyyy-MM-dd').format(selectedDate!)),
            ),
            ElevatedButton(
              onPressed: () async {
                final d = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100));
                if (d != null) setState(() => selectedDate = d);
              },
              child: const Text('Pick Date'),
            ),
          ]),
          const SizedBox(height: 8),
          Row(children: [
            const Text('Duration (hours):'),
            const SizedBox(width: 8),
            Expanded(
                child: TextField(
                    controller: _durationCtrl,
                    keyboardType: TextInputType.number)),
          ]),
          const SizedBox(height: 8),
          SwitchListTile(
            title: const Text('Include Driver?'),
            value: withDriver,
            onChanged: (v) => setState(() => withDriver = v),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: loading ? null : () => _book(context),
            child: loading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text('Book Now'),
          ),
        ]),
      ),
    );
  }
}
