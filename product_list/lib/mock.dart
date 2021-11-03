import 'package:product_list/api/product_template_api.dart';
import 'package:product_list/models/api_list_result.dart';
import 'package:product_list/models/product.dart';
import 'package:product_list/models/product_category.dart';

import 'api/product_category_api.dart';

class MockProductApi implements ProductApi {
  List<Product> productTemplates = List<Product>.generate(
      40,
      (index) => Product(
            id: index,
            name: 'Quần jean $index}',
            availableQuantity: 10,
            dateCreated: DateTime.now(),
            price: 1000000,
          ));

  @override
  Future<ApiListResult<Product>> getList({int? count, int? skip}) async {

    await Future.delayed(const Duration(milliseconds: 2000), () {});

    int productTemplateSkip = skip ?? 0;

    if (productTemplateSkip > productTemplates.length) {
      productTemplateSkip = productTemplates.length;
    }

    int productTemplateCount = (count ?? 20 )+ productTemplateSkip;

    if (productTemplateCount > productTemplates.length) {
      productTemplateCount = productTemplates.length;
    }



    return ApiListResult<Product>(
      count: productTemplateCount,
      items:
          productTemplates.sublist(productTemplateSkip, productTemplateCount),
      total: productTemplates.length,
    );

  }

  @override
  Future<Product> insert(Product productTemplate) async {

    await Future.delayed(const Duration(milliseconds: 2000), () {});

    final addProduct = productTemplate.copyWith(
        id: productTemplates.isNotEmpty
            ? (productTemplates.first.id ?? 0) - 1
            : 0);

    productTemplates.insert(0, addProduct);

    return addProduct;
  }

  @override
  Future<void> update(Product productTemplate) async {

    await Future.delayed(const Duration(milliseconds: 2000), () {});

    final findIndex = productTemplates
        .indexWhere((element) => productTemplate.id == element.id);

    if (findIndex >= 0) {
      productTemplates[findIndex] = productTemplate;
    }
  }

  @override
  Future<void> delete(Product productTemplate) async {

    await Future.delayed(const Duration(milliseconds: 2000), () {});

    productTemplates.removeWhere((element) => productTemplate.id == element.id);
  }
}

class MockProductCategoryApi implements ProductCategoryApi {

  List<ProductCategory> productCategories = List<ProductCategory>.generate(
    10,
    (index) => ProductCategory(
      name: 'Nhóm sản phẩm $index}',
      id: index.toString(),
    ),
  );

  @override
  Future<List<ProductCategory>> getList() async {
    await Future.delayed(const Duration(milliseconds: 2000), () {});
    return productCategories;
  }
}
