part of 'product_edit_bloc.dart';

@immutable
abstract class ProductEditEvent {}

class ProductEditLoaded extends ProductEditEvent {
  ProductEditLoaded(this.product);

  final Product? product;

  @override
  String toString() {
    return 'ProductEditLoaded{product: $product}';
  }
}

class ProductEditSaved extends ProductEditEvent {
  ProductEditSaved([this.product]);

  final Product? product;

  @override
  String toString() {
    return 'ProductEditSaved{product: $product}';
  }
}

class ProductEditCategoryChanged extends ProductEditEvent {
  ProductEditCategoryChanged(this.productCategory);

  final ProductCategory productCategory;

  @override
  String toString() {
    return 'ProductEditCategoryChanged{productCategory: $productCategory}';
  }
}
