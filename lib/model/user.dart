class UserModel {
  final String uid;
  final String name;
  final String email;
  final String? phone;
  final String? image;
  final String? address;
  final String role;
  final bool vendorRequest;
  final String vendorStatus;
  final String? businessName;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.phone,
    this.image,
    this.address,
    this.role = 'customer',
    this.vendorRequest = false,
    this.vendorStatus = "none",
    this.businessName,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    return UserModel(
      uid: uid,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'],
      image: map['image'],
      address: map['address'],
      role: map['role'] ?? 'customer',
      vendorRequest: map['vendorRequest'] ?? false,
      vendorStatus: map['vendorStatus'] ?? 'none',
      businessName: map['businessName'],
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt']) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'image': image,
      'userId': uid,
      'phone': phone,
      'address': address,
      'role': role,
      'vendorRequest': vendorRequest,
      'vendorStatus': vendorStatus,
      'businessName': businessName,
      'createdAt': createdAt.toIso8601String(),
    };
  }
  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? phone,
    String? image,
    String? address,
    String? role,
    bool? vendorRequest,
    String? vendorStatus,
    String? businessName,
    DateTime? createdAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      image: image ?? this.image,
      address: address ?? this.address,
      role: role ?? this.role,
      vendorRequest: vendorRequest ?? this.vendorRequest,
      vendorStatus: vendorStatus ?? this.vendorStatus,
      businessName: businessName ?? this.businessName,
      createdAt: createdAt ?? this.createdAt,
    );
  }

}
