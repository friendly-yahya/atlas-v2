import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:atlas_paragliding_v2/core/network/supabase_provider.dart';
import 'package:atlas_paragliding_v2/features/operator/domain/operator_application_draft.dart';


final operatorApplicationRepositoryProvider = Provider<OperatorApplicationRepository>((ref) {
  return OperatorApplicationRepository(
    supabase: ref.watch(supabaseClientProvider)
  );
});

class OperatorApplicationRepository {
  final SupabaseClient _supabase;
  OperatorApplicationRepository({required SupabaseClient supabase}) : _supabase = supabase;

  Future<void> submit(OperatorApplicationDraft draft) async {
    final uid = _supabase.auth.currentUser!.id;
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


    await _supabase.rpc('submit_operator_application', params: {
      'p_full_legal_name': draft.fullLegalName,
      'p_full_legal_name_ar': draft.fullLegalNameAr,
      'p_country': draft.country,
      'p_date_of_birth': draft.dateOfBirth.toIso8601String().split('T').first,
      'p_id_type': draft.idType,
      'p_id_number': draft.idNumber,
      'p_id_front_path': frontPath,
      'p_id_back_path': backPath,
    });
  }
}