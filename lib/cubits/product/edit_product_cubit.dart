import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/image_service.dart';
import '../../services/product_service.dart';
import '../../model/product.dart';
import 'dart:io';

import 'edit_product_states.dart';

class EditProductCubit extends Cubit<EditProductState> {
  final ProductService productService;
  final ImageService imageService;

  EditProductCubit(this.productService, this.imageService) : super(EditProductInitial());

  Future<void> updateProduct({
    required Product existingProduct,
    required String name,
    required String description,
    required String category,
    required double price,
    File? image,
  }) async {
    emit(EditProductLoading());

    try {
      String imageUrl = existingProduct.imageUrl ?? "";

      if (image != null) {
        final newImageUrl = await imageService.processAndUpload(image);
        if (newImageUrl == null) {
          emit(EditProductError("فشل في رفع الصورة"));
          return;
        }
        imageUrl = newImageUrl;
      }

      await productService.updateProduct(
        productId: existingProduct.id.toString(),
        productName: name,
        category: category,
        price: price,
        description: description,
        imageUrl: imageUrl,
      );

      emit(EditProductSuccess());
    } catch (e) {
      emit(EditProductError(e.toString()));
    }
  }
}
