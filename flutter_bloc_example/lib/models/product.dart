import 'package:flutter_bloc_example/models/product_category.dart';

class Product {
  final int? id;
  final double? price;
  final String? name;
  final String? defaultCode;
  final double? weight;
  final double? listPrice;
  final int? variantFistId;
  final double? availableQuantity;
  final double? virtualQuantity;
  final DateTime? dateCreated;
  final ProductCategory? category;

//<editor-fold desc="Data Methods">

  const Product({
    this.id,
    this.price,
    this.name,
    this.defaultCode,
    this.weight,
    this.listPrice,
    this.variantFistId,
    this.availableQuantity,
    this.virtualQuantity,
    this.dateCreated,
    this.category,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Product &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          price == other.price &&
          name == other.name &&
          defaultCode == other.defaultCode &&
          weight == other.weight &&
          listPrice == other.listPrice &&
          variantFistId == other.variantFistId &&
          availableQuantity == other.availableQuantity &&
          virtualQuantity == other.virtualQuantity &&
          dateCreated == other.dateCreated &&
          category == other.category);

  @override
  int get hashCode =>
      id.hashCode ^
      price.hashCode ^
      name.hashCode ^
      defaultCode.hashCode ^
      weight.hashCode ^
      listPrice.hashCode ^
      variantFistId.hashCode ^
      availableQuantity.hashCode ^
      virtualQuantity.hashCode ^
      dateCreated.hashCode ^
      category.hashCode;

  @override
  String toString() {
    return 'Product{' +
        ' id: $id,' +
        ' price: $price,' +
        ' name: $name,' +
        ' defaultCode: $defaultCode,' +
        ' weight: $weight,' +
        ' listPrice: $listPrice,' +
        ' variantFistId: $variantFistId,' +
        ' availableQuantity: $availableQuantity,' +
        ' virtualQuantity: $virtualQuantity,' +
        ' dateCreated: $dateCreated,' +
        ' category: $category,' +
        '}';
  }

  Product copyWith({
    int? id,
    double? price,
    String? name,
    String? defaultCode,
    double? weight,
    double? listPrice,
    int? variantFistId,
    double? availableQuantity,
    double? virtualQuantity,
    DateTime? dateCreated,
    ProductCategory? category,
  }) {
    return Product(
      id: id ?? this.id,
      price: price ?? this.price,
      name: name ?? this.name,
      defaultCode: defaultCode ?? this.defaultCode,
      weight: weight ?? this.weight,
      listPrice: listPrice ?? this.listPrice,
      variantFistId: variantFistId ?? this.variantFistId,
      availableQuantity: availableQuantity ?? this.availableQuantity,
      virtualQuantity: virtualQuantity ?? this.virtualQuantity,
      dateCreated: dateCreated ?? this.dateCreated,
      category: category ?? this.category,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'price': this.price,
      'name': this.name,
      'defaultCode': this.defaultCode,
      'weight': this.weight,
      'listPrice': this.listPrice,
      'variantFistId': this.variantFistId,
      'availableQuantity': this.availableQuantity,
      'virtualQuantity': this.virtualQuantity,
      'dateCreated': this.dateCreated,
      'category': this.category,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as int,
      price: map['price'] as double,
      name: map['name'] as String,
      defaultCode: map['defaultCode'] as String,
      weight: map['weight'] as double,
      listPrice: map['listPrice'] as double,
      variantFistId: map['variantFistId'] as int,
      availableQuantity: map['availableQuantity'] as double,
      virtualQuantity: map['virtualQuantity'] as double,
      dateCreated: map['dateCreated'] as DateTime,
      category: map['category'] as ProductCategory,
    );
  }

//</editor-fold>
}
