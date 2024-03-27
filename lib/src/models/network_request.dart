// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:multi_dropdown/src/enum/app_enums.dart';
// import 'package:multi_dropdown/src/models/dropdown_item.dart';

// /// Configuration for the network.
// ///
// /// [url] is the url of the network.
// /// [method] is the request method of the network.
// /// [headers] is the headers of the network.
// /// [body] is the body of the network.
// /// [queryParameters] is the query parameters of the network.

// class NetworkRequest<T> {
//   NetworkRequest({
//     required this.url,
//     this.method = RequestMethod.get,
//     this.headers = const {},
//     this.body,
//     this.queryParameters = const {},
//     this.responseParser,
//     this.responseErrorBuilder,
//   }) : customRequest = null;

//   NetworkRequest.custom({
//     this.responseErrorBuilder,
//     this.customRequest,
//   })  : url = '',
//         method = RequestMethod.get,
//         headers = const {},
//         body = const {},
//         queryParameters = const {},
//         responseParser = null;
//   final String url;
//   final RequestMethod method;
//   final Map<String, String>? headers;
//   final Map<String, dynamic>? body;
//   final Map<String, dynamic>? queryParameters;
//   final Future<List<ValueItem<T>>>? Function()? customRequest;
//   final Future<List<ValueItem<T>>> Function(dynamic response)? responseParser;
//   final Widget Function(BuildContext context, dynamic response)?
//       responseErrorBuilder;
// }
