class UserModel {
  final int? id;
  final String name;
  final String email;
  final String phone;
  final String role; // 'user' | 'owner' | 'admin'
  final String? nicPath;
  final String? licensePath;
  final String status; // 'pending' | 'approved' | 'rejected'
  final String password;

  UserModel({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    this.nicPath,
    this.licensePath,
    this.status = 'pending',
    required this.password,
  });

  factory UserModel.fromMap(Map<String, dynamic> m) => UserModel(
        id: m['id'] as int?,
        name: m['name'],
        email: m['email'],
        phone: m['phone'],
        role: m['role'],
        nicPath: m['nic_path'],
        licensePath: m['license_path'],
        status: m['status'],
        password: m['password'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'role': role,
        'nic_path': nicPath,
        'license_path': licensePath,
        'status': status,
        'password': password,
      };
}
