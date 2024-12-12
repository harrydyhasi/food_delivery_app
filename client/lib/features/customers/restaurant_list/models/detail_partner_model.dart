class User {
  final String id;
  final String name;
  final String phone;

  User({
    required this.id,
    required this.name,
    required this.phone,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'phone': phone,
    };
  }
}

class DetailPartnerModel {
  final String id;
  final User userId; 
  final String avatarUrl;
  final String storeFront;
  final String cccdFrontUrl;
  final String cccdBackUrl;
  final String description;
  final bool status;
  final String provinceId;
  final String districtId;
  final String communeId;
  final String detailAddress;

  DetailPartnerModel({
    required this.id,
    required this.userId,
    required this.avatarUrl,
    required this.storeFront,
    required this.cccdFrontUrl,
    required this.cccdBackUrl,
    required this.description,
    required this.status,
    required this.provinceId,
    required this.districtId,
    required this.communeId,
    required this.detailAddress,
  });

  // Factory method to create a DetailPartnerModel from JSON data
  factory DetailPartnerModel.fromJson(Map<String, dynamic> json) {
    var data = json['data'] ?? {};

    return DetailPartnerModel(
      id: data['_id'] ?? '',
      userId: User.fromJson(data['userId'] ?? {}), // Chuyển thành đối tượng User
      avatarUrl: data['avatarUrl'] ?? '',
      storeFront: data['storeFront'] ?? '',
      cccdFrontUrl: data['CCCDFrontUrl'] ?? '',
      cccdBackUrl: data['CCCDBackUrl'] ?? '',
      description: data['description'] ?? '',
      status: data['status'] ?? false,
      provinceId: data['provinceId'] ?? '',
      districtId: data['districtId'] ?? '',
      communeId: data['communeId'] ?? '',
      detailAddress: data['detailAddress'] ?? '',
    );
  }

  // Method to convert DetailPartnerModel to JSON format
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId.toJson(), // Chuyển đối tượng User thành JSON
      'avatarUrl': avatarUrl,
      'storeFront': storeFront,
      'CCCDFrontUrl': cccdFrontUrl,
      'CCCDBackUrl': cccdBackUrl,
      'description': description,
      'status': status,
      'provinceId': provinceId,
      'districtId': districtId,
      'communeId': communeId,
      'detailAddress': detailAddress,
    };
  }
}
