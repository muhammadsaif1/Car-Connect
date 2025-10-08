import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/user.dart';
import '../models/car.dart';
import '../models/driver.dart';
import '../models/booking.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _db;

  Future<Database> get db async {
    return _db ??= await initDB();
  }

  Future<Database> initDB() async {
    if (_db != null) return _db!;
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'carconnect.db');
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
    // seed sample data if empty
    await _seedSampleData();
    return _db!;
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        email TEXT UNIQUE,
        phone TEXT,
        role TEXT,
        nic_path TEXT,
        license_path TEXT,
        status TEXT,
        password TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE cars(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        owner_id INTEGER,
        model TEXT,
        city TEXT,
        rent_per_day REAL,
        available INTEGER,
        image_path TEXT,
        approval_status TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE drivers(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        experience_years INTEGER,
        rate_per_hour REAL,
        approval_status TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE bookings(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        car_id INTEGER,
        driver_id INTEGER,
        date TEXT,
        duration_hours INTEGER,
        status TEXT
      )
    ''');
  }

  // --- USERS ---
  Future<int> insertUser(UserModel user) async {
    final dbClient = await db;
    return await dbClient.insert('users', user.toMap());
  }

  Future<UserModel?> getUserByEmailAndPassword(
      String email, String password) async {
    final dbClient = await db;
    final maps = await dbClient.query('users',
        where: 'email = ? AND password = ?', whereArgs: [email, password]);
    if (maps.isNotEmpty) return UserModel.fromMap(maps.first);
    return null;
  }

  Future<List<UserModel>> getPendingUsers() async {
    final dbClient = await db;
    final maps = await dbClient
        .query('users', where: 'status = ?', whereArgs: ['pending']);
    return maps.map((m) => UserModel.fromMap(m)).toList();
  }

  Future<int> updateUserStatus(int id, String status) async {
    final dbClient = await db;
    return await dbClient.update('users', {'status': status},
        where: 'id = ?', whereArgs: [id]);
  }

  // --- CARS ---
  Future<int> insertCar(CarModel car) async {
    final dbClient = await db;
    return await dbClient.insert('cars', car.toMap());
  }

  Future<List<CarModel>> getApprovedCars() async {
    final dbClient = await db;
    final maps = await dbClient
        .query('cars', where: 'approval_status = ?', whereArgs: ['approved']);
    return maps.map((m) => CarModel.fromMap(m)).toList();
  }

  Future<List<CarModel>> getPendingCars() async {
    final dbClient = await db;
    final maps = await dbClient
        .query('cars', where: 'approval_status = ?', whereArgs: ['pending']);
    return maps.map((m) => CarModel.fromMap(m)).toList();
  }

  Future<int> updateCarApproval(int id, String status) async {
    final dbClient = await db;
    return await dbClient.update('cars', {'approval_status': status},
        where: 'id = ?', whereArgs: [id]);
  }

  // --- DRIVERS ---
  Future<int> insertDriver(DriverModel d) async {
    final dbClient = await db;
    return await dbClient.insert('drivers', d.toMap());
  }

  Future<List<DriverModel>> getApprovedDrivers() async {
    final dbClient = await db;
    final maps = await dbClient.query('drivers',
        where: 'approval_status = ?', whereArgs: ['approved']);
    return maps.map((m) => DriverModel.fromMap(m)).toList();
  }

  Future<List<DriverModel>> getPendingDrivers() async {
    final dbClient = await db;
    final maps = await dbClient
        .query('drivers', where: 'approval_status = ?', whereArgs: ['pending']);
    return maps.map((m) => DriverModel.fromMap(m)).toList();
  }

  Future<int> updateDriverApproval(int id, String status) async {
    final dbClient = await db;
    return await dbClient.update('drivers', {'approval_status': status},
        where: 'id = ?', whereArgs: [id]);
  }

  // --- BOOKINGS ---
  Future<int> insertBooking(BookingModel b) async {
    final dbClient = await db;
    return await dbClient.insert('bookings', b.toMap());
  }

  Future<List<BookingModel>> getBookingsForUser(int userId) async {
    final dbClient = await db;
    final maps = await dbClient.query('bookings',
        where: 'user_id = ?', whereArgs: [userId], orderBy: 'id DESC');
    return maps.map((m) => BookingModel.fromMap(m)).toList();
  }

  Future<List<BookingModel>> getAllBookings() async {
    final dbClient = await db;
    final maps = await dbClient.query('bookings', orderBy: 'id DESC');
    return maps.map((m) => BookingModel.fromMap(m)).toList();
  }

  Future<int> updateBookingStatus(int id, String status) async {
    final dbClient = await db;
    return await dbClient.update('bookings', {'status': status},
        where: 'id = ?', whereArgs: [id]);
  }

  // Seed sample admin and sample data if not exists
  Future<void> _seedSampleData() async {
    final dbClient = await db;
    final users = await dbClient.query('users', limit: 1);
    if (users.isEmpty) {
      // create admin user (approved)
      await insertUser(UserModel(
        name: 'Admin',
        email: 'admin@admin.com',
        phone: '0000000000',
        role: 'admin',
        password: 'admin123',
        nicPath: null,
        licensePath: null,
        status: 'approved',
      ));
      // create sample owner (approved)
      int ownerId = await insertUser(UserModel(
        name: 'Owner One',
        email: 'owner1@demo.com',
        phone: '03110000001',
        role: 'owner',
        password: 'owner123',
        nicPath: null,
        licensePath: null,
        status: 'approved',
      ));

      // sample car (approved)
      await insertCar(CarModel(
        ownerId: ownerId,
        model: 'Toyota Corolla 2018',
        city: 'Hyderabad',
        rentPerDay: 5000,
        available: true,
        imagePath: null,
        approvalStatus: 'approved',
      ));

      // sample driver (approved)
      await insertDriver(DriverModel(
        name: 'Ahmed Khan',
        experienceYears: 5,
        ratePerHour: 300,
        approvalStatus: 'approved',
      ));
    }
  }
}
