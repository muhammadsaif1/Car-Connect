import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import 'car_list_screen.dart';
import 'driver_list_screen.dart';
import 'add_car_screen.dart';
import 'add_driver_screen.dart';
import 'admin_panel_screen.dart';
import 'login_screen.dart';
import 'booking_screen.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;
  final tabs = ['Cars', 'Drivers', 'My Bookings', 'Add'];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final user = provider.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('CarConnect'),
        actions: [
          if (user != null && user.role == 'admin')
            IconButton(
              onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AdminPanelScreen())),
              icon: const Icon(Icons.admin_panel_settings),
            ),
          IconButton(
            onPressed: () async {
              await provider.logout();
              if (context.mounted)
                Navigator.of(context)
                    .pushReplacementNamed(LoginScreen.routeName);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Builder(builder: (ctx) {
        if (index == 0) return const CarListScreen();
        if (index == 1) return const DriverListScreen();
        if (index == 2) return const BookingScreen();
        return user != null && user.role == 'owner'
            ? const AddCarDriverTab()
            : Center(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const Text('Add Car/Driver is only for Owners.'),
                  ElevatedButton(
                      onPressed: () {
                        // if user isn't owner, maybe show info
                      },
                      child: const Text('Info'))
                ]),
              );
      }),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (i) => setState(() => index = i),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.directions_car), label: 'Cars'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Drivers'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Bookings'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add'),
        ],
      ),
    );
  }
}

class AddCarDriverTab extends StatelessWidget {
  const AddCarDriverTab({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(children: [
        ElevatedButton.icon(
          onPressed: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => const AddCarScreen())),
          icon: const Icon(Icons.add),
          label: const Text('Add Car'),
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => const AddDriverScreen())),
          icon: const Icon(Icons.add),
          label: const Text('Add Driver'),
        ),
      ]),
    );
  }
}
