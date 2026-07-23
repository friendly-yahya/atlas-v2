import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:atlas_paragliding_v2/core/network/supabase_provider.dart';
import 'package:atlas_paragliding_v2/features/operator/domain/operator_application_draft.dart';

import 'dart:convert';
final operatorApplicationRepositoryProvider = Provider<OperatorApplicationRepository>((ref) {
  return OperatorApplicationRepository(
    supabase: ref.watch(supabaseClientProvider)
  );
});

class OperatorApplicationRepository {
  final SupabaseClient _supabase;
  OperatorApplicationRepository({required SupabaseClient supabase}) : _supabase = supabase;

/*   Future<void> submit(OperatorApplicationDraft draft) async {
    final uid = _supabase.auth.currentUser!.id;
    // ignore: avoid_print
    print('DEBUG uid: $uid');
    // ignore: avoid_print
    print('DEBUG session valid: ${_supabase.auth.currentSession != null}');
    // ignore: avoid_print
    print('DEBUG access token present: ${_supabase.auth.currentSession?.accessToken.isNotEmpty}');
    final frontPath = '$uid/front.jpg';
    await _supabase.storage.from('operator-identity-docs').upload(
      frontPath,
      draft.idFrontImage!,
      fileOptions: const FileOptions(upsert: true)
    );
    String? backPath;
    if (draft.idBackImage != null) {
      backPath = '$uid/back.jpg';
      await _supabase.storage.from('operator-identity-docs').upload(
            backPath,
            draft.idBackImage!,
            fileOptions: const FileOptions(upsert: true),
          );
    }
    print('=== RPC DEBUG ===');
    print('Params count: ${params.length}');
    print('Params keys: ${params.keys.toList()}');
    print('Params JSON: ${jsonEncode(params)}');
    print('=================');

    await _supabase.rpc('submit_operator_application', params: {
      'p_full_legal_name': draft.fullLegalName,
      'p_country': draft.country,
    });
  } */

Future<void> submit(OperatorApplicationDraft draft) async {
  final uid = _supabase.auth.currentUser!.id;
  
  print('DEBUG uid: $uid');
  print('DEBUG session valid: ${_supabase.auth.currentSession != null}');
  print('DEBUG access token present: ${_supabase.auth.currentSession?.accessToken.isNotEmpty}');

  final frontPath = '$uid/front.jpg';
  await _supabase.storage.from('operator-identity-docs').upload(
    frontPath,
    draft.idFrontImage!,
    fileOptions: const FileOptions(upsert: true),
  );

  String? backPath;
  if (draft.idBackImage != null) {
    backPath = '$uid/back.jpg';
    await _supabase.storage.from('operator-identity-docs').upload(
      backPath,
      draft.idBackImage!,
      fileOptions: const FileOptions(upsert: true),
    );
  }

  // Build the params map with DateTime converted to string
  final params = {
    'p_full_legal_name': draft.fullLegalName,
    'p_country': draft.country,
    'p_date_of_birth': draft.dateOfBirth.toIso8601String(),  // ← FIX: DateTime → String
    'p_id_type': draft.idType,
    'p_id_number': draft.idNumber,
    'p_id_front_path': frontPath,
    'p_id_back_path': backPath,
  };

  // Safe debug print — no jsonEncode needed, just print the map
  print('=== RPC DEBUG ===');
  print('Params count: ${params.length}');
  print('Params keys: ${params.keys.toList()}');
  print('Params: $params');
  print('=================');

  await _supabase.rpc('submit_operator_application', params: params);
}
}