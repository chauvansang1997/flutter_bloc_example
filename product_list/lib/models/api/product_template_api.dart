import 'package:product_list/models/api_list_result.dart';
import 'package:product_list/models/product.dart';

abstract class ProductApi {
  Future<ApiListResult<Product>> getList({int? count, int? skip});
}
