import 'package:product_list/api/product_category_api.dart';
import 'package:product_list/api/product_template_api.dart';
import 'package:product_list/mock.dart';
import 'package:get_it/get_it.dart';

Future<void> setupLocator() async {
  _setupApiService();
}

void _setupApiService() {
  GetIt.instance.registerLazySingleton<ProductApi>(
      () => MockProductApi());

  GetIt.instance
      .registerFactory<ProductCategoryApi>(() => MockProductCategoryApi());
}
