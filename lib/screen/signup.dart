import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/user.dart';

class SignupScreen extends StatefulWidget {
  static const routeName = '/signup';
  const SignupScreen({super.key});
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _form = GlobalKey<FormState>();
  String name = '', email = '', phone = '', password = '';
  String role = 'user';
  File? nicFile;
  File? licenseFile;

  Future<String?> _savePickedFile(XFile file) async {
    final dir = await getApplicationDocumentsDirectory();
    final fileName = '${DateTime.now().millisecondsSinceEpoch}_${basename(file.path)}';
    final saved = await File(file.path).copy('${dir.path}/$fileName');
    return saved.path;
  }

  Future<void> pickNic() async {
    final x = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (x != null) {
      final p = await _savePickedFile(x);
      setState(() => nicFile = File(p!));
    }
  }

  Future<void> pickLicense() async {
    final x = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (x != null) {
      final p = await _savePickedFile(x);
      setState(() => licenseFile = File(p!));
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Form(
                key: _form,
                child: Column(children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Full Name'),
                    validator: (v) => v == null || v.isEmpty ? 'Enter name' : null,
                    onSaved: (v) => name = v!.trim(),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (v) => v == null || v.isEmpty ? 'Enter email' : null,
                    onSaved: (v) => email = v!.trim(),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Phone'),
                    validator: (v) => v == null || v.isEmpty ? 'Enter phone' : null,
                    onSaved: (v) => phone = v!.trim(),
                  ),
                  DropdownButtonFormField<String>(
                    value: role,
                    items: const [
                      DropdownMenuItem(value: 'user', child: Text('User / Renter')),
                      DropdownMenuItem(value: 'owner', child: Text('Car Owner')),
                    ],
                    onChanged: (v) => setState(() => role = v!),
                    decoration: const InputDecoration(labelText: 'Role'),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: (v) => v == null || v.isEmpty ? 'Enter password' : null,
                    onSaved: (v) => password = v!,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(child: Text(nicFile == null ? 'NIC not uploaded' : 'NIC uploaded')),
                      TextButton(onPressed: pickNic, child: const Text('Upload NIC')),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(child: Text(licenseFile == null ? 'License not uploaded' : 'License uploaded')),
                      TextButton(onPressed: pickLicense, child: const Text('Upload License')),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () async {
                      if (!_form.currentState!.validate()) return;
                      _form.currentState!.save();
                      final user = UserModel(
                        name: name,
                        email: email,
                        phone: phone,
                        role: role,
                        nicPath: nicFile?.path,
                        licensePath: licenseFile?.path,
                        password: password,
                      );
                      final res = await provider.signup(user);
                      if (res != null) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res)));
                        }
                      } else {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Signed up. Await admin approval.')));
                          Navigator.of(context).pop();
                        }
                      }
                    },
                    child: const Text('Sign Up (Pending Approval)'),
                  ),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
