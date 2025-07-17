class AssetModel {
  final String? name;
  final String? owner;
  final String? creation;
  final String? modified;
  final String? modifiedBy;
  final int? docstatus;
  final int? idx;
  final String? serialNo;
  final String? purchaseOrderNo;
  final String? indentId;
  final String? productCategory;
  final String? productModel;
  final String? vendersName;
  final String? productImage;
  final String? assetStatus;
  final String? assetNo;
  final String? assetCode;
  final double? price;
  final String? purchaseSource;
  final String? purchaseAssetDate;
  final String? invoiceNumber;
  final String? warrantyType;
  final String? warrantyExpiry;
  final String? warrantyStatus;
  final String? customBuilding;
  final String? store;
  final String? ownerUser;
  final String? customFloor;
  final String? storeDescription;
  final String? ownerName;
  final String? customRoom;
  final String? department;
  final String? remarks;
  final String? amendedFrom;
  final String? flag;
  final String? doctype;
  final List<dynamic> cpuDetails;

  AssetModel({
    required this.name,
    required this.owner,
    required this.creation,
    required this.modified,
    required this.modifiedBy,
    required this.docstatus,
    required this.idx,
    required this.serialNo,
    required this.purchaseOrderNo,
    required this.indentId,
    required this.productCategory,
    required this.productModel,
    required this.vendersName,
    this.productImage,
    required this.assetStatus,
    required this.assetNo,
    required this.assetCode,
    required this.price,
    required this.purchaseSource,
    required this.purchaseAssetDate,
    required this.invoiceNumber,
    required this.warrantyType,
    this.warrantyExpiry,
    this.warrantyStatus,
    this.customBuilding,
    required this.store,
    this.ownerUser,
    this.customFloor,
    required this.storeDescription,
    this.ownerName,
    this.customRoom,
    this.department,
    required this.remarks,
    this.amendedFrom,
    required this.flag,
    required this.doctype,
    required this.cpuDetails,
  });

  factory AssetModel.fromJson(Map<String, dynamic> json) {
    return AssetModel(
      name: json['name'],
      owner: json['owner'],
      creation: json['creation'],
      modified: json['modified'],
      modifiedBy: json['modified_by'],
      docstatus: json['docstatus'],
      idx: json['idx'],
      serialNo: json['serial_no'],
      purchaseOrderNo: json['purchase_order_no'],
      indentId: json['indent_id'],
      productCategory: json['product_category'],
      productModel: json['product_model'],
      vendersName: json['venders_name'],
      productImage: json['product_image'],
      assetStatus: json['asset_status'],
      assetNo: json['asset_no'],
      assetCode: json['asset_code'],
      price: (json['price'] as num).toDouble(),
      purchaseSource: json['purchase_source'],
      purchaseAssetDate: json['purchaseasset_date'],
      invoiceNumber: json['invoice_number'],
      warrantyType: json['warranty_type'],
      warrantyExpiry: json['warranty_expiry'],
      warrantyStatus: json['warranty_status'],
      customBuilding: json['custom_building'],
      store: json['store'],
      ownerUser: json['owner_user'],
      customFloor: json['custom_floor'],
      storeDescription: json['store_description'],
      ownerName: json['owner_name'],
      customRoom: json['custom_room'],
      department: json['department'],
      remarks: json['remarks'],
      amendedFrom: json['amended_from'],
      flag: json['flag'],
      doctype: json['doctype'],
      cpuDetails: json['cpu_details'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'owner': owner,
      'creation': creation,
      'modified': modified,
      'modified_by': modifiedBy,
      'docstatus': docstatus,
      'idx': idx,
      'serial_no': serialNo,
      'purchase_order_no': purchaseOrderNo,
      'indent_id': indentId,
      'product_category': productCategory,
      'product_model': productModel,
      'venders_name': vendersName,
      'product_image': productImage,
      'asset_status': assetStatus,
      'asset_no': assetNo,
      'asset_code': assetCode,
      'price': price,
      'purchase_source': purchaseSource,
      'purchaseasset_date': purchaseAssetDate,
      'invoice_number': invoiceNumber,
      'warranty_type': warrantyType,
      'warranty_expiry': warrantyExpiry,
      'warranty_status': warrantyStatus,
      'custom_building': customBuilding,
      'store': store,
      'owner_user': ownerUser,
      'custom_floor': customFloor,
      'store_description': storeDescription,
      'owner_name': ownerName,
      'custom_room': customRoom,
      'department': department,
      'remarks': remarks,
      'amended_from': amendedFrom,
      'flag': flag,
      'doctype': doctype,
      'cpu_details': cpuDetails,
    };
  }
}
