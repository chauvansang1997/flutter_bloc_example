part of 'product_bloc.dart';

class ProductData {
  final List<Product> products;
  final List<Product> selectedProducts;
  final int total;

  const ProductData({
    required this.products,
    required this.selectedProducts,
    required this.total,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductData &&
          runtimeType == other.runtimeType &&
          products == other.products &&
          selectedProducts == other.selectedProducts &&
          total == other.total);

  @override
  int get hashCode =>
      products.hashCode ^ selectedProducts.hashCode ^ total.hashCode;

  @override
  String toString() {
    return 'ProductData{' +
        ' products: $products,' +
        ' selectedProducts: $selectedProducts,' +
        ' total: $total,' +
        '}';
  }

  ProductData copyWith({
    List<Product>? products,
    List<Product>? selectedProducts,
    int? total,
  }) {
    return ProductData(
      products: products ?? this.products,
      selectedProducts: selectedProducts ?? this.selectedProducts,
      total: total ?? this.total,
    );
  }
}

@immutable
abstract class ProductState {}

class ProductLoading extends ProductState {}

class ProductBusy extends ProductDataAvailable {
  ProductBusy(ProductData data) : super(data);

  @override
  String toString() {
    return 'ProductBusy: {data: ${data.toString()}}';
  }
}

class ProductDataAvailable extends ProductState {
  ProductDataAvailable(this.data);

  final ProductData data;

  @override
  String toString() {
    return 'ProductDataAvailable: {data: ${data.toString()}}';
  }
}

class ProductLoadSuccess extends ProductDataAvailable {
  ProductLoadSuccess(ProductData data) : super(data);

  @override
  String toString() {
    return 'ProductLoadSuccess: {data: ${data.toString()}}';
  }
}

class ProductLoadNoMore extends ProductDataAvailable {
  ProductLoadNoMore(ProductData data) : super(data);

  @override
  String toString() {
    return 'ProductLoadNoMore: {data: ${data.toString()}}';
  }
}

class ProductLoadingMore extends ProductDataAvailable {
  ProductLoadingMore(ProductData data) : super(data);

  @override
  String toString() {
    return 'ProductLoadingMore: {data: ${data.toString()}}';
  }
}

class ProductFilterFailure extends ProductDataAvailable {
  ProductFilterFailure({required ProductData data, required this.error})
      : super(data);

  final String error;

  @override
  String toString() {
    return 'ProductFilterFailure: {data: ${data.toString()}, error: $error}';
  }
}

class ProductLoadMoreFailure extends ProductDataAvailable {
  ProductLoadMoreFailure({required ProductData data, required this.error})
      : super(data);

  final String error;

  @override
  String toString() {
    return 'ProductLoadMoreFailure: {data: ${data.toString()}, error: $error}';
  }
}

class ProductDeleteFailure extends ProductDataAvailable {
  ProductDeleteFailure({required ProductData data, required this.error})
      : super(data);

  final String error;

  @override
  String toString() {
    return 'ProductDeleteFailure: {data: ${data.toString()}, error: $error}';
  }
}

class ProductLoadFailure extends ProductState {
  ProductLoadFailure(this.error);

  final String error;

  @override
  String toString() {
    return 'ProductLoadFailure: {error: $error}';
  }
}
