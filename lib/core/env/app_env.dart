import 'package:envied/envied.dart';

part 'app_env.g.dart';

@Envied(
  path: '.env',
  obfuscate: true,
)
abstract class AppEnv {
  @EnviedField(varName: 'SUPABASE_URL')
  static final String supabaseUrl = _AppEnv.supabaseUrl;
  @EnviedField(varName: 'SUPABASE_PUBLISHABLE_KEY')
  static final String supabasePublishableKey = _AppEnv.supabasePublishableKey;
}