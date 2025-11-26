part of 'products_cubit.dart';
@immutable
sealed class ProductsState {}

final class ProductsInitial extends ProductsState {}
final class ProductsLoading extends ProductsState {}

final class ProductsSuccess extends ProductsState {
  final List<Product> products;
  final bool isMyProducts;
  ProductsSuccess(this.products, {this.isMyProducts = false});
}

final class ProductsError extends ProductsState {
  final String message;
  ProductsError(this.message);
}
