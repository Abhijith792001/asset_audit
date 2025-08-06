class AuditModel {
  List<Message>? message;

  AuditModel({this.message});

  AuditModel.fromJson(Map<String, dynamic> json) {
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
  String? auditNumber;
  String? auditType;
  String? startDate;
  String? dueDate;
Null store;
  String? building;
  String? auditStatus;
  String? buildingName;
  List<String>? assignedTo;

  Message(
      {this.name,
      this.auditNumber,
      this.auditType,
      this.startDate,
      this.dueDate,
      this.store,
      this.building,
      this.auditStatus,
      this.buildingName,
      this.assignedTo});

  Message.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    auditNumber = json['audit_number'];
    auditType = json['audit_type'];
    startDate = json['start_date'];
    dueDate = json['due_date'];
    store = json['store'];
    building = json['building'];
    auditStatus = json['audit_status'];
    buildingName = json['building_name'];
   assignedTo = json['assigned_to'] != null
    ? List<String>.from(json['assigned_to'])
    : [];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['audit_number'] = this.auditNumber;
    data['audit_type'] = this.auditType;
    data['start_date'] = this.startDate;
    data['due_date'] = this.dueDate;
    data['store'] = this.store;
    data['building'] = this.building;
    data['audit_status'] = this.auditStatus;
    data['building_name'] = this.buildingName;
    data['assigned_to'] = this.assignedTo;
    return data;
  }
}
