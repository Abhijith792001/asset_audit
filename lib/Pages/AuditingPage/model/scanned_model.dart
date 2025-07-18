

class ScannedModel {
  final String? assetNo;
  final String? owner;
  final String? modifiedBy;
  final String? assetStatus;
  final String? date;

  ScannedModel({
    required this.assetNo,
    required this.owner,
    required this.modifiedBy,
    required this.assetStatus,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
    'assetNo': assetNo,
    'owner': owner,
    'modifiedBy': modifiedBy,
    'assetStatus': assetStatus,
    'date': date,
  };

  factory ScannedModel.fromJson(Map<String, dynamic> json) {
    return ScannedModel(
      assetNo: json['assetNo'],
      owner: json['owner'],
      modifiedBy: json['modifiedBy'],
      assetStatus: json['assetStatus'],
      date: json['date'],
    );
  }
}
