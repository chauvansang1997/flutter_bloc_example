import 'package:product_list/models/product_category.dart';

abstract class ProductCategoryApi {

  Future<List<ProductCategory>> getList();

}
