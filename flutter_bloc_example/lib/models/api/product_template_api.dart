import 'package:flutter_bloc_example/models/api_list_result.dart';
import 'package:flutter_bloc_example/models/product.dart';

abstract class ProductApi {
  Future<ApiListResult<Product>> getList({int? count, int? skip});
}
