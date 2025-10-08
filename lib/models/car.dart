class CarModel {
  final int? id;
  final int ownerId;
  final String model;
  final String city;
  final double rentPerDay;
  final bool available;
  final String? imagePath;
  final String approvalStatus; // 'pending' | 'approved' | 'rejected'

  CarModel({
    this.id,
    required this.ownerId,
    required this.model,
    required this.city,
    required this.rentPerDay,
    this.available = true,
    this.imagePath,
    this.approvalStatus = 'pending',
  });

  factory CarModel.fromMap(Map<String, dynamic> m) => CarModel(
        id: m['id'] as int?,
        ownerId: m['owner_id'],
        model: m['model'],
        city: m['city'],
        rentPerDay: (m['rent_per_day'] as num).toDouble(),
        available: m['available'] == 1,
        imagePath: m['image_path'],
        approvalStatus: m['approval_status'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'owner_id': ownerId,
        'model': model,
        'city': city,
        'rent_per_day': rentPerDay,
        'available': available ? 1 : 0,
        'image_path': imagePath,
        'approval_status': approvalStatus,
      };
}
