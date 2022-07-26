import 'package:flutter_dotenv/flutter_dotenv.dart';

final tmdbKey = dotenv.get('TMDB_KEY');
final tmdbLanguage = dotenv.get(
  'TMDB_LANGUAGE',
  fallback: 'en-US',
);
final tmdbBaseUrl = dotenv.get(
  'TMDB_BASE_URL',
  fallback: 'https://api.themoviedb.org/3/',
);
