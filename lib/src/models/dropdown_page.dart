part of '../multi_dropdown.dart';

/// One page of remote results. A null [nextCursor] means the final page.
class DropdownPage<T> {
  /// Creates a page. Item values identify duplicates across pages and queries.
  const DropdownPage({required this.items, this.nextCursor});

  /// Results for this page, in display order.
  final List<DropdownItem<T>> items;

  /// Opaque cursor to pass to the next request, or null when finished.
  final String? nextCursor;
}

/// Loads a page for [query]. The first request uses a null [cursor].
typedef RemoteRequest<T> = Future<DropdownPage<T>> Function(
  String query,
  String? cursor,
);

/// Builds remote error UI with a callback that retries the failed page.
typedef RemoteErrorBuilder = Widget Function(
  BuildContext context,
  Object error,
  VoidCallback retry,
);
