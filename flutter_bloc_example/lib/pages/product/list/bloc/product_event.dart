part of 'product_bloc.dart';

@immutable
abstract class ProductEvent {}

class ProductLoaded extends ProductEvent {}

class ProductLoadMore extends ProductEvent {}

class ProductChecked extends ProductEvent {
  ProductChecked(this.product);

  final Product product;

  @override
  String toString() {
    return 'ProductChecked{product: $product}';
  }
}

class ProductSelectItemsDeleted extends ProductEvent {}

class ProductDeleted extends ProductEvent {
  ProductDeleted(this.product);

  final Product product;

  @override
  String toString() {
    return 'ProductDeleted{product: $product}';
  }
}

class ProductInserted extends ProductEvent {
  ProductInserted(this.product);

  final Product product;

  @override
  String toString() {
    return 'ProductInserted{product: $product}';
  }
}
