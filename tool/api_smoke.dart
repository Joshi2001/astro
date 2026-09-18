import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> main() async {
  final base = 'https://astro-backend-new-m37h.onrender.com/api';
  final client = http.Client();

  final login = await client.post(
    Uri.parse('$base/auth/login'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'email': 'tester@astro.app', 'password': 'secret123'}),
  );
  final setCookie = login.headers['set-cookie'] ?? '';
  final match = RegExp('token=([^;]+)').firstMatch(setCookie);
  print('status ${login.statusCode}, set-cookie has token: ${match != null}');
  final cookie = match!.group(1)!;

  for (final path in ['/profile/me', '/questionnaire/me', '/horoscope/me', '/matchmaking/my-matches']) {
    final r = await client.get(
      Uri.parse('$base$path'),
      headers: {'Cookie': 'token=$cookie'},
    );
    final body = jsonDecode(r.body) as Map;
    print('$path -> ${r.statusCode} success=${body['success']} msg=${body['message']}');
  }
}