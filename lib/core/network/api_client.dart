import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../constants/app_constants.dart';
import 'api_exceptions.dart';

class ApiClient {
  ApiClient._();

  static final ApiClient instance = ApiClient._();

  final http.Client _client = http.Client();

  String? token;

  /// JWT sent via the `Cookie` header — the deployed backend only accepts
  /// cookie-based auth (httpOnly `Set-Cookie: token=...` on login/register).
  String? authCookie;

  static const String _cookieName = 'token';

  Map<String, String> get _defaultHeaders {
    final cookie =
        (authCookie != null && authCookie!.isNotEmpty) ? authCookie : token;
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (cookie != null && cookie.isNotEmpty)
        'Cookie': '$_cookieName=$cookie',
    };
  }

  Future<dynamic> get(String path, {Map<String, dynamic>? query}) async {
    return _send(
      () => _client.get(_uri(path, query: query), headers: _defaultHeaders),
    );
  }

  Future<dynamic> post(
    String path, {
    Map<String, dynamic>? query,
    Map<String, dynamic>? body,
  }) async {
    final encoded = body == null ? null : jsonEncode(body);
    return _send(
      () => _client.post(
        _uri(path, query: query),
        headers: _defaultHeaders,
        body: encoded,
      ),
    );
  }

  Future<dynamic> put(
    String path, {
    Map<String, dynamic>? query,
    Map<String, dynamic>? body,
  }) async {
    final encoded = body == null ? null : jsonEncode(body);
    return _send(
      () => _client.put(
        _uri(path, query: query),
        headers: _defaultHeaders,
        body: encoded,
      ),
    );
  }

  Uri _uri(String path, {Map<String, dynamic>? query}) {
    final base = '${AppConstants.apiBaseUrl}$path';
    final uri = Uri.parse(base);
    if (query == null || query.isEmpty) return uri;
    final q = query.map((k, v) => MapEntry(k, v.toString()));
    return uri.replace(queryParameters: q);
  }

  Future<dynamic> _send(Future<http.Response> Function() request) async {
    http.Response response;
    try {
      response = await request().timeout(AppConstants.requestTimeout);
    } on TimeoutException {
      throw const TimeoutException();
    } on http.ClientException {
      throw const NetworkException();
    } catch (_) {
      throw const NetworkException();
    }

    _captureAuthCookie(response);

    final decoded = _decode(response);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      debugPrint('API_OK ${response.statusCode} ${response.request?.url}');
      return decoded;
    }

    debugPrint(
      'API_ERR ${response.statusCode} ${response.request?.url} '
      'cookie=${authCookie?.substring(0, authCookie!.length > 30 ? 30 : authCookie!.length)}',
    );
    throw ApiException(
      response.statusCode,
      _extractMessage(decoded, response.statusCode),
    );
  }

  void _captureAuthCookie(http.Response response) {
    final setCookie = response.headers['set-cookie'];
    if (setCookie == null || setCookie.isEmpty) return;
    final match = RegExp('$_cookieName=([^;]+)').firstMatch(setCookie);
    if (match != null) {
      final value = match.group(1);
      if (value != null && value.isNotEmpty) authCookie = value;
    }
  }

  void clearAuth() {
    token = null;
    authCookie = null;
  }

  dynamic _decode(http.Response response) {
    final text = utf8.decode(response.bodyBytes);
    if (text.isEmpty) return null;
    try {
      return jsonDecode(text);
    } catch (_) {
      throw const ParseException();
    }
  }

  String _extractMessage(dynamic body, int statusCode) {
    if (body is Map &&
        body['message'] is String &&
        body['message'].toString().trim().isNotEmpty) {
      return body['message'] as String;
    }
    switch (statusCode) {
      case 400:
        return 'Bad request. Please check your details.';
      case 401:
      case 403:
        return 'Your session has expired. Please log in again.';
      case 404:
        return 'The requested record was not found.';
      case 409:
        return 'A record with that value already exists.';
      case 422:
        return 'Validation failed. Please review your input.';
      case 500:
        return 'Server error. Please try again later.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}
