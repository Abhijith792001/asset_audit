class AssetsByRoomModel {
  List<Message>? message;

  AssetsByRoomModel({this.message});

  AssetsByRoomModel.fromJson(Map<String, dynamic> json) {
    if (json['message'] != null) {
      message = <Message>[];
      json['message'].forEach((v) {
        message!.add(new Message.fromJson(v));
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

class Message {
  String? name;
  String? assetStatus;
  String? customBuilding;
  String? customFloor;
  String? customRoom;

  Message(
      {this.name,
      this.assetStatus,
      this.customBuilding,
      this.customFloor,
      this.customRoom});

  Message.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    assetStatus = json['asset_status'];
    customBuilding = json['custom_building'];
    customFloor = json['custom_floor'];
    customRoom = json['custom_room'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['asset_status'] = this.assetStatus;
    data['custom_building'] = this.customBuilding;
    data['custom_floor'] = this.customFloor;
    data['custom_room'] = this.customRoom;
    return data;
  }
}
