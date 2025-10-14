class AssetModel {
  final String name;
  final String assetNo;
  final String assetStatus;
  final String productCategory;
  final String productModel;

  AssetModel({
    required this.name,
    required this.assetNo,
    required this.assetStatus,
    required this.productCategory,
    required this.productModel,
  });

  factory AssetModel.fromJson(Map<String, dynamic> json) {
    return AssetModel(
      name: json['name'] ?? '',
      assetNo: json['asset_no'] ?? '',
      assetStatus: json['asset_status'] ?? '',
      productCategory: json['product_category'] ?? '',
      productModel: json['product_model'] ?? '',
    );
  }
}
