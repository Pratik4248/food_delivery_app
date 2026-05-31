import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repository/auth_repository.dart';
import 'auth_state.dart';

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) {
    return AuthController(AuthRepository());
  },
);

class AuthController extends StateNotifier<AuthState> {
  final AuthRepository repository;

  AuthController(this.repository) : super(const AuthState());

  Future<void> sendOtp(String email) async {
    try {
      state = state.copyWith(isLoading: true, clearError: true);
      await repository.sendOtp(email: email);
      state = state.copyWith(isLoading: false, clearError: true);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: _cleanError(e));
    }
  }

  Future<void> verifyOtp({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String address,
    required String otp,
  }) async {
    try {
      state = state.copyWith(isLoading: true, clearError: true);

      await repository.verifyOtp(
        name: name,
        email: email,
        password: password,
        phone: phone,
        address: address,
        otp: otp,
      );

      state = state.copyWith(isLoading: false, clearError: true);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: _cleanError(e));
    }
  }

  Future<void> login({required String email, required String password}) async {
    try {
      state = state.copyWith(isLoading: true, clearError: true);
      await repository.login(email: email, password: password);
      state = state.copyWith(isLoading: false, clearError: true);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: _cleanError(e));
    }
  }

  Future<void> checkUser({required String email}) async {
   try {
      state = state.copyWith(isLoading: true, clearError: true);
      await repository.checkUser(email: email);
      state = state.copyWith(isLoading: false, clearError: true);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: _cleanError(e));
    }
  }
  }


  String _cleanError(Object error) {
    return error.toString().replaceFirst('Exception: ', '');
  }

