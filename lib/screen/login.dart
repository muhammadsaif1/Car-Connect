import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import 'home.dart';
import 'signup.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  bool loading = false;
  String? error;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: const Text('CarConnect - Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Email'),
                    onSaved: (v) => email = v?.trim() ?? '',
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Enter email' : null,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    onSaved: (v) => password = v ?? '',
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Enter password' : null,
                  ),
                  const SizedBox(height: 12),
                  if (error != null)
                    Text(error!, style: const TextStyle(color: Colors.red)),
                  ElevatedButton(
                    onPressed: () async {
                      final form = _formKey.currentState!;
                      if (!form.validate()) return;
                      form.save();
                      setState(() {
                        loading = true;
                        error = null;
                      });
                      final res = await provider.login(email, password);
                      setState(() => loading = false);
                      if (res != null) {
                        setState(() => error = res);
                      } else {
                        Navigator.of(context)
                            .pushReplacementNamed(HomeScreen.routeName);
                      }
                    },
                    child: loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Login'),
                  ),
                  TextButton(
                    onPressed: () =>
                        Navigator.of(context).pushNamed(SignupScreen.routeName),
                    child: const Text('Create account'),
                  ),
                  const SizedBox(height: 8),
                  const Text('Admin credentials: admin@admin.com / admin123',
                      style: TextStyle(fontSize: 12)),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
