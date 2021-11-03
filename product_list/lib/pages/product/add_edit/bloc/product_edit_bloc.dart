import 'package:bloc/bloc.dart';
import 'package:product_list/api/product_category_api.dart';
import 'package:product_list/api/product_template_api.dart';
import 'package:product_list/models/product.dart';
import 'package:product_list/models/product_category.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';

part 'product_edit_event.dart';

part 'product_edit_state.dart';

class ProductEditBloc extends Bloc<ProductEditEvent, ProductEditState> {
  ProductEditBloc({
    ProductCategoryApi? productCategoryApi,
    ProductApi? productApi,
  }) : super(ProductEditLoading()) {
    _productCategoryApi = productCategoryApi ?? GetIt.I<ProductCategoryApi>();
    _productApi = productApi ?? GetIt.I<ProductApi>();

    on<ProductEditLoaded>(_onLoaded);

    on<ProductEditSaved>(_onSaved);

    on<ProductEditCategoryChanged>(_onCategoryChanged);
  }

  late final Logger _logger = Logger();
  late final ProductApi _productApi;
  late final ProductCategoryApi _productCategoryApi;

  ///Load data:
  /// State return:
  ///   1.ProductEditLoading: When geting data from api
  ///   2.ProductEditLoadSuccess: When succeed to get data from api
  ///   3.ProductEditLoadFailure: When failed get get data from api
  Future<void> _onLoaded(
      ProductEditLoaded event, Emitter<ProductEditState> emit) async {
    final product = event.product;

    emit(ProductEditLoading());

    try {
      final productCategories = await _productCategoryApi.getList();

      if (product != null) {
        emit(ProductEditLoadSuccess(ProductEditData(
            product: product, productCategories: productCategories)));
        return;
      }

      emit(
        ProductEditLoadSuccess(
          ProductEditData(
            product: Product(),
            productCategories: productCategories,
          ),
        ),
      );
    } catch (exception, stack) {
      _logger.e('ProductEditLoadFailure', exception.toString(), stack);

      emit(
        ProductEditLoadFailure(exception.toString()),
      );
    }
  }

  ///Change product category:
  /// State return:
  ///   1.ProductEditLoadSuccess: When complete change product category
  Future<void> _onCategoryChanged(
      ProductEditCategoryChanged event, Emitter<ProductEditState> emit) async {
    final currentState = state;
    if (currentState is ProductEditDataAvailable) {
      emit(
        ProductEditCategoryChangeSuccess(
          currentState.data.copyWith(
            product: currentState.data.product.copyWith(
              category: event.productCategory,
            ),
          ),
        ),
      );
    }
  }

  ///Save product template:
  /// State return:
  ///   1.ProductEditBusy: When wait for save product template
  ///   2.ProductEditSaveSuccess:
  ///     + When update product template successfully
  ///     + When edit product template successfully
  ///   3.ProductEditSaveFailure: When failed to save or edit product template
  Future<void> _onSaved(
      ProductEditSaved event, Emitter<ProductEditState> emit) async {
    final currentState = state;
    if (currentState is ProductEditDataAvailable) {
      emit(
        ProductEditBusy(currentState.data),
      );

      try {
        final product = currentState.data.product;

        final saveProduct = product.copyWith(
          id: event.product?.id ?? product.id,
          category: event.product?.category ?? product.category,
          price: event.product?.price ?? product.price,
          dateCreated: event.product?.dateCreated ?? product.dateCreated,
          availableQuantity:
              event.product?.availableQuantity ?? product.availableQuantity,
          name: event.product?.name ?? product.name,
          defaultCode: event.product?.defaultCode ?? product.defaultCode,
          listPrice: event.product?.listPrice ?? product.listPrice,
          variantFistId: event.product?.variantFistId ?? product.variantFistId,
          virtualQuantity:
              event.product?.virtualQuantity ?? product.virtualQuantity,
          weight: event.product?.weight ?? product.weight,
        );

        if (saveProduct.id != null) {
          await _productApi.update(saveProduct);

          emit(
            ProductEditSaveSuccess(currentState.data),
          );
          return;
        }

        final newProduct = await _productApi.insert(saveProduct);

        emit(
          ProductEditSaveSuccess(
              currentState.data.copyWith(product: newProduct)),
        );
      } catch (exception, stack) {
        _logger.e('ProductEditSaveFailure', exception.toString(), stack);

        emit(
          ProductEditSaveFailure(
            error: exception.toString(),
            data: currentState.data,
          ),
        );
      }
    }
  }
}
