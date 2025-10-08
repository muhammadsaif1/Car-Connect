class BookingModel {
  final int? id;
  final int userId;
  final int? carId;
  final int? driverId;
  final String date; // ISO string
  final int durationHours;
  final String status; // 'pending' | 'confirmed' | 'cancelled'

  BookingModel({
    this.id,
    required this.userId,
    this.carId,
    this.driverId,
    required this.date,
    required this.durationHours,
    this.status = 'pending',
  });

  factory BookingModel.fromMap(Map<String, dynamic> m) => BookingModel(
        id: m['id'] as int?,
        userId: m['user_id'],
        carId: m['car_id'],
        driverId: m['driver_id'],
        date: m['date'],
        durationHours: m['duration_hours'],
        status: m['status'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'user_id': userId,
        'car_id': carId,
        'driver_id': driverId,
        'date': date,
        'duration_hours': durationHours,
        'status': status,
      };
}
