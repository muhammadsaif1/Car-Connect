import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/user.dart';
import '../models/car.dart';
import '../models/driver.dart';
import '../models/booking.dart';

class AppProvider extends ChangeNotifier {
  final DatabaseHelper _db = DatabaseHelper.instance;

  UserModel? currentUser;

  List<CarModel> approvedCars = [];
  List<DriverModel> approvedDrivers = [];
  List<BookingModel> myBookings = [];

  List<UserModel> pendingUsers = [];
  List<CarModel> pendingCars = [];
  List<DriverModel> pendingDrivers = [];

  // load app data
  Future<void> loadInitialData() async {
    approvedCars = await _db.getApprovedCars();
    approvedDrivers = await _db.getApprovedDrivers();
    pendingUsers = await _db.getPendingUsers();
    pendingCars = await _db.getPendingCars();
    pendingDrivers = await _db.getPendingDrivers();
    notifyListeners();
  }

  // AUTH
  Future<String?> login(String email, String password) async {
    final user = await _db.getUserByEmailAndPassword(email, password);
    if (user == null) return 'Invalid credentials';
    if (user.status != 'approved') return 'Your profile is not approved yet';
    currentUser = user;
    await loadMyBookings();
    notifyListeners();
    return null;
  }

  Future<String?> signup(UserModel user) async {
    try {
      await _db.insertUser(user);
      await loadInitialData();
      return null;
    } catch (e) {
      return 'Signup failed: ${e.toString()}';
    }
  }

  // CAR
  Future<void> addCar(CarModel car) async {
    await _db.insertCar(car);
    await loadInitialData();
  }

  // DRIVER
  Future<void> addDriver(DriverModel d) async {
    await _db.insertDriver(d);
    await loadInitialData();
  }

  // BOOKING
  Future<void> addBooking(BookingModel b) async {
    await _db.insertBooking(b);
    await loadMyBookings();
    await loadInitialData();
  }

  Future<void> loadMyBookings() async {
    if (currentUser == null) return;
    myBookings = await _db.getBookingsForUser(currentUser!.id!);
    notifyListeners();
  }

  // ADMIN ACTIONS
  Future<void> approveUser(int id) async {
    await _db.updateUserStatus(id, 'approved');
    await loadInitialData();
  }

  Future<void> rejectUser(int id) async {
    await _db.updateUserStatus(id, 'rejected');
    await loadInitialData();
  }

  Future<void> approveCar(int id) async {
    await _db.updateCarApproval(id, 'approved');
    await loadInitialData();
  }

  Future<void> rejectCar(int id) async {
    await _db.updateCarApproval(id, 'rejected');
    await loadInitialData();
  }

  Future<void> approveDriver(int id) async {
    await _db.updateDriverApproval(id, 'approved');
    await loadInitialData();
  }

  Future<void> rejectDriver(int id) async {
    await _db.updateDriverApproval(id, 'rejected');
    await loadInitialData();
  }

  Future<void> logout() async {
    currentUser = null;
    myBookings = [];
    notifyListeners();
  }
}
