class RoomModel {
  Message? message;

  RoomModel({this.message});

  RoomModel.fromJson(Map<String, dynamic> json) {
    message =
        json['message'] != null ? Message.fromJson(json['message']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (message != null) {
      data['message'] = message!.toJson();
    }
    return data;
  }
}

class Message {
  List<CustomRoom>? customRoom;

  Message({this.customRoom});

  Message.fromJson(Map<String, dynamic> json) {
    if (json['custom_room'] != null) {
      customRoom = <CustomRoom>[];
      json['custom_room'].forEach((v) {
        customRoom!.add(CustomRoom.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (customRoom != null) {
      data['custom_room'] = customRoom!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CustomRoom {
  String? customRoom;
  String? name;
  String? customFloor;
  String? customBuilding;

  CustomRoom(
      {this.customRoom, this.name, this.customFloor, this.customBuilding});

  CustomRoom.fromJson(Map<String, dynamic> json) {
    customRoom = json['custom_room'];
    name = json['name'];
    customFloor = json['custom_floor'];
    customBuilding = json['custom_building'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['custom_room'] = customRoom;
    data['name'] = name;
    data['custom_floor'] = customFloor;
    data['custom_building'] = customBuilding;
    return data;
  }
}
