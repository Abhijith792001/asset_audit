class PendingRoomsByFloorModel {
  Message? message;

  PendingRoomsByFloorModel({this.message});

  PendingRoomsByFloorModel.fromJson(Map<String, dynamic> json) {
    message =
        json['message'] != null ? new Message.fromJson(json['message']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.message != null) {
      data['message'] = this.message!.toJson();
    }
    return data;
  }
}

class Message {
  String? building;
  List<PendingRoomsByFloor>? pendingRoomsByFloor;

  Message({this.building, this.pendingRoomsByFloor});

  Message.fromJson(Map<String, dynamic> json) {
    building = json['building'];
    if (json['pending_rooms_by_floor'] != null) {
      pendingRoomsByFloor = <PendingRoomsByFloor>[];
      json['pending_rooms_by_floor'].forEach((v) {
        pendingRoomsByFloor!.add(new PendingRoomsByFloor.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['building'] = this.building;
    if (this.pendingRoomsByFloor != null) {
      data['pending_rooms_by_floor'] =
          this.pendingRoomsByFloor!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PendingRoomsByFloor {
  String? floorId;
  String? floorName;
  List<Rooms>? rooms;

  PendingRoomsByFloor({this.floorId, this.floorName, this.rooms});

  PendingRoomsByFloor.fromJson(Map<String, dynamic> json) {
    floorId = json['floor_id'];
    floorName = json['floor_name'];
    if (json['rooms'] != null) {
      rooms = <Rooms>[];
      json['rooms'].forEach((v) {
        rooms!.add(new Rooms.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['floor_id'] = this.floorId;
    data['floor_name'] = this.floorName;
    if (this.rooms != null) {
      data['rooms'] = this.rooms!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Rooms {
  String? roomId;
  String? roomName;

  Rooms({this.roomId, this.roomName});

  Rooms.fromJson(Map<String, dynamic> json) {
    roomId = json['room_id'];
    roomName = json['room_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['room_id'] = this.roomId;
    data['room_name'] = this.roomName;
    return data;
  }
}
