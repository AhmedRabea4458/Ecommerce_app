import '../../model/user.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthSuccess extends AuthState {
  final UserModel user;
  AuthSuccess(this.user);
}
class AuthFailure extends AuthState {
  final String error;
  AuthFailure(this.error);
}
class LogInLoading extends AuthState {}
class LogInSuccess extends AuthState {}
class LogInFailure extends AuthState {
  final String error;
  LogInFailure(this.error);
}
class SignUpLoading extends AuthState {}
class SignUpSuccess extends AuthState {}
class SignUpFailure extends AuthState {
  final String error;
  SignUpFailure(this.error);
}