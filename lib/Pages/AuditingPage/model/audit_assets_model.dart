class AuditedAssetsModel {
  List<Message>? message;

  AuditedAssetsModel({this.message});

  AuditedAssetsModel.fromJson(Map<String, dynamic> json) {
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
  int? name;
  String? auditNumber;
  String? asset;
  String? auditType;
  String? activityBy;
  String? auditStatus;
  String? currentStatus;
  String? assetOwner;
  String? assetOwnerName;
  String? ownerDepartment;
  String? building;
  String? floor;
  String? room;

  Message(
      {this.name,
      this.auditNumber,
      this.asset,
      this.auditType,
      this.activityBy,
      this.auditStatus,
      this.currentStatus,
      this.assetOwner,
      this.assetOwnerName,
      this.ownerDepartment,
      this.building,
      this.floor,
      this.room});

  Message.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    auditNumber = json['audit_number'];
    asset = json['asset'];
    auditType = json['audit_type'];
    activityBy = json['activity_by'];
    auditStatus = json['audit_status'];
    currentStatus = json['current_status'];
    assetOwner = json['asset_owner'];
    assetOwnerName = json['asset_owner_name'];
    ownerDepartment = json['owner_department'];
    building = json['building'];
    floor = json['floor'];
    room = json['room'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['audit_number'] = this.auditNumber;
    data['asset'] = this.asset;
    data['audit_type'] = this.auditType;
    data['activity_by'] = this.activityBy;
    data['audit_status'] = this.auditStatus;
    data['current_status'] = this.currentStatus;
    data['asset_owner'] = this.assetOwner;
    data['asset_owner_name'] = this.assetOwnerName;
    data['owner_department'] = this.ownerDepartment;
    data['building'] = this.building;
    data['floor'] = this.floor;
    data['room'] = this.room;
    return data;
  }
}
