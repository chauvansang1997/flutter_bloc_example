part of 'product_edit_bloc.dart';

class ProductEditData {
  final Product product;
  final List<ProductCategory> productCategories;

//<editor-fold desc="Data Methods">

  const ProductEditData({
    required this.product,
    required this.productCategories,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductEditData &&
          runtimeType == other.runtimeType &&
          product == other.product &&
          productCategories == other.productCategories);

  @override
  int get hashCode => product.hashCode ^ productCategories.hashCode;

  @override
  String toString() {
    return 'ProductEditData{' +
        ' product: $product,' +
        ' productCategories: $productCategories,' +
        '}';
  }

  ProductEditData copyWith({
    Product? product,
    List<ProductCategory>? productCategories,
  }) {
    return ProductEditData(
      product: product ?? this.product,
      productCategories: productCategories ?? this.productCategories,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'product': this.product,
      'productCategories': this.productCategories,
    };
  }

  factory ProductEditData.fromMap(Map<String, dynamic> map) {
    return ProductEditData(
      product: map['product'] as Product,
      productCategories: map['productCategories'] as List<ProductCategory>,
    );
  }

//</editor-fold>
}

@immutable
abstract class ProductEditState {}

class ProductEditLoading extends ProductEditState {}

class ProductEditDataAvailable extends ProductEditState {
  ProductEditDataAvailable(this.data);

  final ProductEditData data;

  @override
  String toString() {
    return 'ProductEditDataAvailable{data: $data}';
  }
}

class ProductEditLoadSuccess extends ProductEditDataAvailable {
  ProductEditLoadSuccess(ProductEditData data) : super(data);

  @override
  String toString() {
    return 'ProductEditLoadSuccess{data: $data}';
  }
}

class ProductEditSaveSuccess extends ProductEditDataAvailable {
  ProductEditSaveSuccess(ProductEditData data) : super(data);

  @override
  String toString() {
    return 'ProductEditSaveSuccess{data: $data}';
  }
}

class ProductEditCategoryChangeSuccess extends ProductEditDataAvailable {
  ProductEditCategoryChangeSuccess(ProductEditData data) : super(data);

  @override
  String toString() {
    return 'ProductEditCategoryChangeSuccess{data: $data}';
  }
}

class ProductEditBusy extends ProductEditDataAvailable {
  ProductEditBusy(ProductEditData data) : super(data);

  @override
  String toString() {
    return 'ProductEditBusy{data: ${data.toString()}';
  }
}

class ProductEditLoadFailure extends ProductEditState {
  ProductEditLoadFailure(this.error);

  final String error;

  @override
  String toString() {
    return 'ProductEditLoadFailure{error: $error}';
  }
}

class ProductEditSaveFailure extends ProductEditDataAvailable {
  ProductEditSaveFailure({required ProductEditData data, required this.error})
      : super(data);
  final String error;

  @override
  String toString() {
    return 'ProductEditSaveFailure: {data: ${data.toString()}, error: $error}';
  }
}
