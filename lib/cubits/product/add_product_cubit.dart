import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'add_product_state.dart';
import '../../services/product_service.dart';
import '../../services/image_service.dart';
import '../../services/auth_service.dart';

class AddProductCubit extends Cubit<AddProductState> {
  final ProductService _productService;
  final ImageService _imageService;
  final AuthService _authService;

  AddProductCubit(
      this._productService,
      this._imageService,
      this._authService,
      ) : super(AddProductInitial());

  Future<void> addProduct({
    required String name,
    required String price,
    required String description,
    required String category,
    required File image,
  }) async {
    emit(AddProductLoading());
    await Future.delayed(Duration.zero);

    try {

      final user = _authService.currentUser;
      if (user == null) {
        emit(AddProductFailure("المستخدم غير مسجل دخول"));
        return;
      }

      final imageUrl = await _imageService.processAndUpload(image);
      if (imageUrl == null) {
        emit(AddProductFailure("فشل في رفع الصورة"));
        return;
      }

      await _productService.addProduct(
        productName: name,
        price: double.parse(price),
        description: description,
        category: category,
        imageUrl: imageUrl,
        sellerId: user.uid,
        sellerName: user.displayName ?? "Unknown",
      );

      emit(AddProductSuccess());
    } catch (e) {
      emit(AddProductFailure("حدث خطأ أثناء إضافة المنتج: ${e.toString()}"));
    }
  }

  void reset() {
    emit(AddProductInitial());
  }
}
