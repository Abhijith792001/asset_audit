class FloorModel {
  final Message? message;

  FloorModel({this.message});

  factory FloorModel.fromJson(Map<String, dynamic> json) {
    return FloorModel(
      message: json['message'] != null ? Message.fromJson(json['message']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        if (message != null) 'message': message!.toJson(),
      };
}

class Message {
  final List<CustomFloor>? customFloor;

  Message({this.customFloor});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      customFloor: json['custom_floor'] != null
          ? List<CustomFloor>.from(
              json['custom_floor'].map((x) => CustomFloor.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
        if (customFloor != null)
          'custom_floor': customFloor!.map((x) => x.toJson()).toList(),
      };
}

class CustomFloor {
  final String? customFloor;
  final String? name;

  CustomFloor({this.customFloor, this.name});

  factory CustomFloor.fromJson(Map<String, dynamic> json) {
    return CustomFloor(
      customFloor: json['custom_floor'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() => {
        'custom_floor': customFloor,
        'name': name,
      };
}
