import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/services/auth_service.dart';
import 'package:project/services/user_service.dart';
import '../../model/user.dart';
import 'auth_state.dart';


class AuthCubit extends Cubit<AuthState> {
  final AuthService _authService;

  UserModel? currentUser;

  AuthCubit(this._authService) : super(AuthInitial());


  Future<void> LogIn(String email, String password) async {
    emit(LogInLoading());
    try {
      final user = await _authService.logIn(email, password);
      if(user == null){
        emit(LogInFailure('يجب تفعيل البريد الإلكتروني أولاً'));
        return;
      }
      emit(LogInSuccess());

      emit(LogInSuccess());

    } catch (e) {
      emit(LogInFailure(e.toString()));
    }
  }
  Future<void> signUp(String email, String password, String userName) async {
    emit(SignUpLoading());
    try {
      await _authService.signUp(email, password, userName);
      emit(SignUpSuccess());
    } catch (e) {
      emit(SignUpFailure(e.toString()));
    }
  }
  Future<void> logout() async {
    await _authService.signOut();
    currentUser = null;
    emit(AuthInitial());
  }




}
