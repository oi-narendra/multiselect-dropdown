/// [statusCode] is status code returned by the custom network function.
///
/// [body] is the body returned by the custom network function.
class CustomNetworkResponse {
  final int statusCode;
  final dynamic body;
  const CustomNetworkResponse({required this.body, required this.statusCode});
}
