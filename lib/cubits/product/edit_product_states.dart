abstract class EditProductState {}

class EditProductInitial extends EditProductState {}

class EditProductLoading extends EditProductState {}

class EditProductSuccess extends EditProductState {}

class EditProductError extends EditProductState {
  final String message;
  EditProductError(this.message);
}
