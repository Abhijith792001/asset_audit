class AssetModel {
  Message? message;

  AssetModel({this.message});

  AssetModel.fromJson(Map<String, dynamic> json) {
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
  List<Name>? name;

  Message({this.name});

  Message.fromJson(Map<String, dynamic> json) {
    if (json['name'] != null) {
      name = <Name>[];
      json['name'].forEach((v) {
        name!.add(new Name.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.name != null) {
      data['name'] = this.name!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Name {
  String? name;
  String? assetNo;
  String? assetStatus;
  String? productCategory;
  String? productModel;

  Name(
      {this.name,
      this.assetNo,
      this.assetStatus,
      this.productCategory,
      this.productModel});

  Name.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    assetNo = json['asset_no'];
    assetStatus = json['asset_status'];
    productCategory = json['product_category'];
    productModel = json['product_model'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['asset_no'] = this.assetNo;
    data['asset_status'] = this.assetStatus;
    data['product_category'] = this.productCategory;
    data['product_model'] = this.productModel;
    return data;
  }
}
