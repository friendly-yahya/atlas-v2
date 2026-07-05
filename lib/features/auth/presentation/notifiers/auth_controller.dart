import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:atlas_paragliding_v2/features/auth/data/repositories/auth_repository.dart';


final authNotifierProvider = AsyncNotifierProvider<AuthNotifier, User?>(() {
  return AuthNotifier();
});
final authStateStreamProvider = StreamProvider<AuthState>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});

class AuthNotifier extends AsyncNotifier<User?>{
  @override
  FutureOr<User?> build() {
    final repo = ref.read(authRepositoryProvider);

    ref.listen(authStateStreamProvider, (previous, next) {
      next.whenData((authState) {
        state = AsyncData(authState.session?.user);
      });
    });
    return repo.currentUser;
  }

  Future<void> loginWithEmail(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(authRepositoryProvider);
      final response = await repo.signInWithEmailPassword(email: email, password: password);
      return response.user;
    });
  }

  Future<void> registerWithEmail(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(authRepositoryProvider);
      final response = await repo.signUpWithEmailPassword(email: email, password: password);
      return response.user;
    });
  }
  Future<void> loginWithOAuth(OAuthProvider provider) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(authRepositoryProvider);
      await repo.signInWithOAuth(provider);
      return repo.currentUser;
    });
  }


  Future<void> requestPhoneOtp(String phone) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(authRepositoryProvider);
      await repo.sendOtpToPhone(phone: phone);
      return state.value; 
    });
  }

  Future<void> requestEmailOtp(String email) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(authRepositoryProvider);
      await repo.sendOtpToEmail(email: email);
      return state.value;
    });
  }


  Future<void> completePhoneOtpVerification(String phone, String tokenCode) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(authRepositoryProvider);
      final response = await repo.verifyPhoneOtp(phone: phone, tokenCode: tokenCode);
      return response.user;
    });
  }

  Future<void> completeEmailOtpVerification(String email, String tokenCode) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(authRepositoryProvider);
      final response = await repo.verifyEmailOtp(email: email, tokenCode: tokenCode);
      return response.user;
    });
  }
  
  Future<void> logout() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(authRepositoryProvider);
      await repo.signOut();
      return null; 
    });
  }
}