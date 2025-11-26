import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/cubits/user/user_state.dart';
import 'package:project/services/user_service.dart';
import 'package:project/model/user.dart';

import '../../services/auth_service.dart';

class UserCubit extends Cubit<UserState> {
  final UserService userService;
  final AuthService _authService;

  UserModel? currentUser;

  UserCubit(this.userService, this._authService) : super(UserInitial());

  Future<void> loadUser() async {
    emit(UserLoading());
    try {
      final user = await userService.getUserData();
      if (user != null) {
        currentUser = user;
        emit(UserLoaded(user));
      } else {
        emit(UserError("المستخدم غير موجود"));
      }
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> updateUserProfile({
    required String name,
    required String phone,
    required String address,
  }) async {
    if (currentUser == null) return;

    emit(UserLoading());
    try {
      final updatedUser = currentUser!.copyWith(
        name: name,
        phone: phone,
        address: address,
      );

      await userService.updateUserProfile(updatedUser);
      currentUser = updatedUser;
      emit(UserLoaded(updatedUser));
    } catch (e) {
      emit(UserError("فشل تحديث البيانات: $e"));
    }
  }

  Future<void> requestVendor() async {
    if (currentUser == null) return;

    emit(UserLoading());
    try {
      final updatedUser = currentUser!.copyWith(
        vendorRequest: true,
        vendorStatus: 'pending',
      );

      await userService.updateUserProfile(updatedUser);
      currentUser = updatedUser;
      emit(UserLoaded(updatedUser));
    } catch (e) {
      emit(UserError("فشل إرسال طلب البائع: $e"));
    }
  }
  Future<void> updateProfileImage(String imageUrl) async {
    if (currentUser == null) return;

    emit(UserLoading());
    try {
      final updatedUser = currentUser!.copyWith(image: imageUrl);
      await userService.updateUserProfile(updatedUser);
      currentUser = updatedUser;
      emit(UserLoaded(updatedUser));
    } catch (e) {
      emit(UserError("فشل تحديث صورة الحساب: $e"));
    }
  }

  bool get isLoggedIn => _authService.isLoggedIn;
  UserModel? get user => currentUser;
}
