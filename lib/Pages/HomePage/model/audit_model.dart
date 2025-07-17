class AuditModel {
  final String name;
  final String auditNumber;
  final String auditType;
  final String startDate;
  final String dueDate;
  final String? store;
  final String? building;
  final String? building_name;
  final String auditStatus;

  AuditModel({
    required this.name,
    required this.auditNumber,
    required this.auditType,
    required this.startDate,
    required this.dueDate,
    this.store,
    this.building,
    this.building_name,
    required this.auditStatus,
  });

  factory AuditModel.fromJson(Map<String, dynamic> json) {
    return AuditModel(
      name: json['name'],
      auditNumber: json['audit_number'],
      auditType: json['audit_type'],
      startDate: json['start_date'],
      dueDate: json['due_date'],
      store: json['store'],
      building: json['building'],
      building_name: json['building_name'],
      auditStatus: json['audit_status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'audit_number': auditNumber,
      'audit_type': auditType,
      'start_date': startDate,
      'due_date': dueDate,
      'store': store,
      'building': building,
      'building_name': building_name,
      'audit_status': auditStatus,
    };
  }
}
