import 'package:product_list/models/api_list_result.dart';
import 'package:product_list/models/product.dart';


abstract class ProductApi {
  Future<ApiListResult<Product>> getList({int? count, int? skip});

  Future<Product> insert(Product productTemplate);

  Future<void> update(Product productTemplate);


  Future<void> delete(Product productTemplate);
}
