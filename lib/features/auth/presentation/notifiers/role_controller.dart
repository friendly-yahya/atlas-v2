import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:atlas_paragliding_v2/features/auth/data/repositories/profile_repository.dart';
import 'package:atlas_paragliding_v2/features/auth/presentation/notifiers/auth_controller.dart';

final roleNotifierProvider = AsyncNotifierProvider<RoleNotifier, String?>((){
    return RoleNotifier();
});

class RoleNotifier extends AsyncNotifier<String?> {
  @override 
  FutureOr<String?> build() async {
    final user = ref.watch(authNotifierProvider).value;
    if (user == null) return null;

    final repo = ref.read(profileRepositoryProvider);
    return repo.getRole(user.id);
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}