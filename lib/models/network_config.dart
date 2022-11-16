import 'package:multi_dropdown/enum/app_enums.dart';

/// Configuration for the network.
///
/// [url] is the url of the network.
/// [method] is the request method of the network.
/// [headers] is the headers of the network.
/// [body] is the body of the network.
/// [queryParameters] is the query parameters of the network.

class NetworkConfig {
  final String url;
  final RequestMethod method;
  final Map<String, String>? headers;
  final Map<String, dynamic>? body;
  final Map<String, dynamic>? queryParameters;

  NetworkConfig({
    required this.url,
    this.method = RequestMethod.get,
    this.headers = const {},
    this.body,
    this.queryParameters = const {},
  });
}
