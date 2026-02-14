part of '../multi_dropdown.dart';

/// [RequestMethod]
/// RequestMethod enum for the request method of the dropdown items.
/// * [RequestMethod.get]: get request
/// * [RequestMethod.post]: post request
/// * [RequestMethod.put]: put request
/// * [RequestMethod.delete]: delete request
/// * [RequestMethod.patch]: patch request
enum RequestMethod {
  /// get request
  get,

  /// post request
  post,

  /// put request
  put,

  /// patch request
  patch,

  /// delete request
  delete
}

/// Controls the direction in which the dropdown overlay expands.
///
/// * [ExpandDirection.auto]: Automatically determines the direction based on
///   available space. Falls back to showing above if there's not enough space below.
/// * [ExpandDirection.down]: Forces the dropdown to expand downward.
/// * [ExpandDirection.up]: Forces the dropdown to expand upward.
enum ExpandDirection {
  /// Automatically determine the best direction based on available space.
  auto,

  /// Force the dropdown to expand downward.
  down,

  /// Force the dropdown to expand upward.
  up,
}
