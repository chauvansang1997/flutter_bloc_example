import 'package:flutter_bloc_example/models/api_list_result.dart';
import 'package:flutter_bloc_example/models/product.dart';


abstract class ProductApi {
  Future<ApiListResult<Product>> getList({int? count, int? skip});

  Future<Product> insert(Product productTemplate);

  Future<void> update(Product productTemplate);


  Future<void> delete(Product productTemplate);
}
