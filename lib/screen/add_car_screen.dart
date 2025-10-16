import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/car.dart';

class AddCarScreen extends StatefulWidget {
  const AddCarScreen({super.key});

  @override
  State<AddCarScreen> createState() => _AddCarScreenState();
}

class _AddCarScreenState extends State<AddCarScreen> {
  final _form = GlobalKey<FormState>();
  String model = '', city = '';
  double rent = 0;
  File? imageFile;

  Future<String?> _savePicked(XFile x) async {
    final dir = await getApplicationDocumentsDirectory();
    final filename =
        '${DateTime.now().millisecondsSinceEpoch}_${basename(x.path)}';
    final saved = await File(x.path).copy('${dir.path}/$filename');
    return saved.path;
  }

  Future<void> pickImage() async {
    final x = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (x != null) {
      final p = await _savePicked(x);
      setState(() => imageFile = File(p!));
    }
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<AppProvider>(context, listen: false);
    final ownerId = prov.currentUser?.id;
    return Scaffold(
      appBar: AppBar(title: const Text('Add Car')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Form(
              key: _form,
              child: Column(children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Car Model'),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Enter model' : null,
                  onSaved: (v) => model = v!.trim(),
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'City'),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Enter city' : null,
                  onSaved: (v) => city = v!.trim(),
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Rent per day'),
                  keyboardType: TextInputType.number,
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Enter rent' : null,
                  onSaved: (v) => rent = double.tryParse(v!) ?? 0,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                        child: Text(
                            imageFile == null ? 'No image' : 'Image selected')),
                    TextButton(
                        onPressed: pickImage, child: const Text('Pick Image')),
                  ],
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () async {
                    if (!_form.currentState!.validate()) return;
                    if (ownerId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Only owners can add cars.')));
                      return;
                    }
                    _form.currentState!.save();
                    await prov.addCar(CarModel(
                      ownerId: ownerId,
                      model: model,
                      city: city,
                      rentPerDay: rent,
                      available: true,
                      imagePath: imageFile?.path,
                      approvalStatus: 'pending',
                    ));
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Car added (pending approval).')));
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Add Car'),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
