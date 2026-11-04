part of '../multi_dropdown.dart';

class _RemoteController<T> extends ChangeNotifier {
  _RemoteController(this.request, {required this.debounce});

  final RemoteRequest<T> request;
  final Duration debounce;
  List<DropdownItem<T>> items = [];
  String query = '';
  String? nextCursor;
  Object? error;
  bool loading = false;
  bool _disposed = false;
  int _generation = 0;
  Timer? _timer;
  String? _failedCursor;
  final Set<String> _usedCursors = {};

  void start([String value = '']) => _search(value, immediate: true);

  void search(String value) {
    if (value == query) return;
    _search(value);
  }

  void _search(String value, {bool immediate = false}) {
    _timer?.cancel();
    final generation = ++_generation;
    query = value;
    items = [];
    nextCursor = null;
    error = null;
    loading = true;
    _usedCursors.clear();
    notifyListeners();
    if (immediate || debounce <= Duration.zero) {
      unawaited(_load(null, generation));
    } else {
      _timer = Timer(debounce, () => unawaited(_load(null, generation)));
    }
  }

  void loadMore() {
    if (_disposed || loading || error != null || nextCursor == null) return;
    unawaited(_load(nextCursor, _generation));
  }

  void retry() {
    if (_disposed || loading || error == null) return;
    unawaited(_load(_failedCursor, _generation));
  }

  Future<void> _load(String? cursor, int generation) async {
    if (_disposed || generation != _generation) return;
    loading = true;
    error = null;
    notifyListeners();
    try {
      final page = await request(query, cursor);
      if (_disposed || generation != _generation) return;
      if (page.nextCursor != null &&
          (page.nextCursor == cursor ||
              _usedCursors.contains(page.nextCursor))) {
        throw StateError('Remote pagination returned a repeated cursor');
      }
      final merged = <T, DropdownItem<T>>{
        if (cursor != null)
          for (final item in items) item.value: item,
        for (final item in page.items) item.value: item,
      };
      items = merged.values.toList();
      if (cursor != null) _usedCursors.add(cursor);
      nextCursor = page.nextCursor;
    } on Object catch (e) {
      if (_disposed || generation != _generation) return;
      error = e;
      _failedCursor = cursor;
    }
    if (_disposed || generation != _generation) return;
    loading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _generation++;
    _timer?.cancel();
    super.dispose();
  }
}
