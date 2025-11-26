import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../model/product.dart';
import '../../services/product_service.dart';

part 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  final ProductService _productService;

  StreamSubscription? _subscription;

  ProductsCubit(this._productService) : super(ProductsInitial());
  Future<void> getProducts({required String category}) async {
    emit(ProductsLoading());
    try {
      await _subscription?.cancel();
      _subscription = _productService.streamProductsByCategory(category).listen(
            (products) => emit(ProductsSuccess(products)),
        onError: (error) => emit(ProductsError(error.toString())),
      );
    } catch (e) {
      emit(ProductsError(e.toString()));
    }
  }

  Future<void> getMyProducts({required String category, required String sellerId}) async {
    emit(ProductsLoading());
    try {
      await _subscription?.cancel();
      _subscription = _productService.streamMyProductsByCategory(category, sellerId).listen(
            (products) => emit(ProductsSuccess(products, isMyProducts: true)),
        onError: (error) => emit(ProductsError(error.toString())),
      );
    } catch (e) {
      emit(ProductsError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
