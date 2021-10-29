import 'package:flutter_bloc_example/models/product_category.dart';

abstract class ProductCategoryApi {

  Future<List<ProductCategory>> getList();

}
