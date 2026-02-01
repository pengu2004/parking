import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static Future<void> initializeSupabase() async {
    await Supabase.initialize(
      url: dotenv.env['url']!,
      anonKey: dotenv.env['anonkey']!,
    );
  }
}
