class DriverModel {
  final int? id;
  final String name;
  final int experienceYears;
  final double ratePerHour;
  final String approvalStatus; // 'pending' | 'approved' | 'rejected'

  DriverModel({
    this.id,
    required this.name,
    required this.experienceYears,
    required this.ratePerHour,
    this.approvalStatus = 'pending',
  });

  factory DriverModel.fromMap(Map<String, dynamic> m) => DriverModel(
        id: m['id'] as int?,
        name: m['name'],
        experienceYears: m['experience_years'],
        ratePerHour: (m['rate_per_hour'] as num).toDouble(),
        approvalStatus: m['approval_status'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'experience_years': experienceYears,
        'rate_per_hour': ratePerHour,
        'approval_status': approvalStatus,
      };
}
