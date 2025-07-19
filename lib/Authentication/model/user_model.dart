class UserModel {
  String? name;
  String? email;
  String? mPin;

  UserModel({
    this.name,
    this.email,
    this.mPin,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'] as String?,
      email: json['email'] as String?,
      mPin: json['mPin'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'mPin': mPin,
    };
  }
}
