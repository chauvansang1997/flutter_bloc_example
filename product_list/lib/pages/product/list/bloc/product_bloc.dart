import 'package:bloc/bloc.dart';
import 'package:product_list/api/product_template_api.dart';
import 'package:product_list/models/product.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';

part 'product_event.dart';

part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc({ProductApi? productApi, int pageSize = 20})
      : super(ProductLoading()) {
    _pageSize = pageSize;
    _productApi = productApi ?? GetIt.I<ProductApi>();

    on<ProductLoaded>(_onLoaded);

    on<ProductLoadMore>(_onLoadMore);

    on<ProductChecked>(_onChecked);

    on<ProductSelectItemsDeleted>(_onDeletedSelectedItems);

    on<ProductDeleted>(_onDeleted);

    on<ProductInserted>(_onInserted);
  }

  late final ProductApi _productApi;
  late final int _pageSize;
  late final Logger _logger = Logger();

  ///Load more data:
  /// State return:
  ///   1.ProductLoadNoMore: When no data return form api
  ///   2.ProductLoadSuccess: When additional data return form api
  ///   3.ProductLoadMoreFailure: When failed get get data from api
  Future<void> _onLoadMore(
    ProductLoadMore event,
    Emitter<ProductState> emit,
  ) async {
    final currentState = state;

    ///avoid to call when getting more data from api
    if (currentState is ProductLoadingMore) {
      return;
    }

    if (currentState is ProductDataAvailable) {
      final data = currentState.data;

      emit(ProductLoadingMore(data));

      final List<Product> products = List<Product>.from(data.products);

      ///Finish load more
      if (products.length >= data.total) {
        emit(ProductLoadNoMore(data));
        return;
      }

      ///Continue load more
      try {
        final productResult = await _productApi.getList(
          count: _pageSize,
          skip: products.length,
        );

        products.addAll(productResult.items);

        emit(
          ProductLoadSuccess(
            data.copyWith(products: products),
          ),
        );
      } catch (exception, stack) {
        _logger.e('ProductLoadMoreFailure', exception.toString(), stack);
        emit(ProductLoadMoreFailure(error: exception.toString(), data: data));
      }
    }
  }

  ///Load data:
  ///  State return:
  ///  1.ProductLoading: When getting data
  ///  2.ProductLoadSuccess: When succeed to get data from api
  ///  3.ProductLoadFailure: When failed to get data from api
  Future<void> _onLoaded(
      ProductLoaded event, Emitter<ProductState> emit) async {
    emit(ProductLoading());

    try {
      final productResult =
          await _productApi.getList(count: _pageSize, skip: 0);

      emit(
        ProductLoadSuccess(
          ProductData(
            products: productResult.items,
            total: productResult.total,
            selectedProducts: [],
          ),
        ),
      );
    } catch (exception, stack) {
      _logger.e('ProductLoadFailure', exception.toString(), stack);
      emit(ProductLoadFailure(exception.toString()));
    }
  }

  ///Select product:
  ///  State return:
  ///  1.ProductDataAvailable: update selectedProducts
  Future<void> _onChecked(
      ProductChecked event, Emitter<ProductState> emit) async {
    final currentState = state;

    if (currentState is ProductDataAvailable) {
      final selectedProducts =
          List<Product>.from(currentState.data.selectedProducts);

      if (selectedProducts.any((element) => event.product == element)) {
        selectedProducts.remove(event.product);
      } else {
        selectedProducts.add(event.product);
      }

      emit(
        ProductDataAvailable(
          currentState.data.copyWith(
            selectedProducts: selectedProducts,
          ),
        ),
      );
    }
  }

  ///Select product:
  ///  State return:
  ///  1.ProductDataAvailable: update products and  remove all selectedProducts
  Future<void> _onDeletedSelectedItems(
      ProductSelectItemsDeleted event, Emitter<ProductState> emit) async {
    final currentState = state;

    if (currentState is ProductDataAvailable) {
      emit(ProductBusy(currentState.data));

      final selectedProducts =
          List<Product>.from(currentState.data.selectedProducts);

      final products = List<Product>.from(currentState.data.products);

      try {
        for (final product in selectedProducts) {
          await _productApi.delete(product);
        }

        products.removeWhere(
            (product) => selectedProducts.any((element) => product == element));

        emit(
          ProductDataAvailable(
            currentState.data.copyWith(
              selectedProducts: [],
              products: products,
            ),
          ),
        );
      } catch (exception, stack) {
        _logger.e('ProductDeleteFailure', exception.toString(), stack);
        emit(
          ProductDeleteFailure(
            error: exception.toString(),
            data: currentState.data,
          ),
        );
      }
    }
  }

  ///Select product:
  ///  State return:
  ///  1.ProductDataAvailable: remove product from products and selectedProducts
  Future<void> _onDeleted(
      ProductDeleted event, Emitter<ProductState> emit) async {
    final currentState = state;

    if (currentState is ProductDataAvailable) {
      emit(ProductBusy(currentState.data));

      try {
        await _productApi.delete(event.product);

        final selectedProducts =
            List<Product>.from(currentState.data.selectedProducts);

        final products = List<Product>.from(currentState.data.products);

        products.removeWhere((product) => product == event.product);

        selectedProducts.removeWhere((product) => product == event.product);

        emit(
          ProductDataAvailable(
            currentState.data.copyWith(
                selectedProducts: selectedProducts, products: products),
          ),
        );
      } catch (exception, stack) {
        _logger.e('ProductDeleteFailure', exception.toString(), stack);

        emit(
          ProductDeleteFailure(
            error: exception.toString(),
            data: currentState.data,
          ),
        );
      }
    }
  }

  ///Insert product:
  ///  State return:
  ///  1.ProductDataAvailable: complete insert product
  Future<void> _onInserted(
      ProductInserted event, Emitter<ProductState> emit) async {
    final currentState = state;

    if (currentState is ProductDataAvailable) {
      emit(ProductBusy(currentState.data));

      final products = List<Product>.from(currentState.data.products);

      products.insert(0, event.product);

      emit(
        ProductDataAvailable(
          currentState.data.copyWith(
            products: products,
            total: currentState.data.total + 1,
          ),
        ),
      );
    }
  }
}
