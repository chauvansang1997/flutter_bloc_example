import 'package:flutter_bloc_example/api/product_category_api.dart';
import 'package:flutter_bloc_example/api/product_template_api.dart';
import 'package:flutter_bloc_example/mock.dart';
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
