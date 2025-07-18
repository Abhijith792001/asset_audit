class UsersModel {
  List<CustomUsers>? message;

  UsersModel({this.message});

  UsersModel.fromJson(Map<String, dynamic> json) {
    if (json['message'] != null) {
      message = <CustomUsers>[];
      json['message'].forEach((v) {
        message!.add(new CustomUsers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.message != null) {
      data['message'] = this.message!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CustomUsers {
  String? name;
  String? email;

  CustomUsers({this.name, this.email});

  CustomUsers.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    return data;
  }
}
