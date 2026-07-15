import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:atlas_paragliding_v2/core/network/supabase_provider.dart';
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(supabase: ref.watch(supabaseClientProvider));
});

class AuthRepository {
  final SupabaseClient _supabase;

  AuthRepository({required SupabaseClient supabase}) : _supabase = supabase;

  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  User? get currentUser => _supabase.auth.currentUser;

  Future<AuthResponse> signInWithEmailPassword({
    required String email,
    required String password,
  }) => _supabase.auth.signInWithPassword(email: email ,password: password);
  

  Future<bool> signInWithOAuth(OAuthProvider provider) => 
    _supabase.auth.signInWithOAuth(
      provider,
      redirectTo: 'io.supabase.atlas://login-callback'
    );
  
  Future<void> sendOtpToPhone({required String phone}) => 
    _supabase.auth.signInWithOtp(phone: phone);
    
  Future<void> sendOtpToEmail({required String email}) => 
    _supabase.auth.signInWithOtp(email: email);
  
  Future<AuthResponse> verifyPhoneOtp({
    required String phone,
    required String tokenCode, 
  }) => _supabase.auth.verifyOTP(
    phone: phone,
    token: tokenCode,
    type: OtpType.sms);
  Future<AuthResponse> verifyEmailOtp({
    required String email,
    required String tokenCode,
  }) => _supabase.auth.verifyOTP(
    email: email,
    token: tokenCode,
    type: OtpType.email);
/*   Future<AuthResponse> signUpWithEmailPassword({
    required String email,
    required String password,
  }) => _supabase.auth.signUp(email: email,password: password);
 */
  Future<AuthResponse> signUpWithEmailPassword({
    required String email,
    required String password,
    required String username,
  }) => _supabase.auth.signUp(
      email: email,
      password: password,
      data: {'username': username},
    );
  Future<void> signOut() => _supabase.auth.signOut();
}