part of '../multi_dropdown.dart';

class _RemoteStatus extends StatelessWidget {
  const _RemoteStatus({
    required this.loading,
    required this.error,
    required this.hasMore,
    required this.onLoadMore,
    required this.onRetry,
    this.loadingBuilder,
    this.errorBuilder,
  });

  final bool loading;
  final Object? error;
  final bool hasMore;
  final VoidCallback onLoadMore;
  final VoidCallback onRetry;
  final WidgetBuilder? loadingBuilder;
  final RemoteErrorBuilder? errorBuilder;

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return loadingBuilder?.call(context) ??
          const Padding(
            padding: EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(width: 12),
                Text('Loading results…'),
              ],
            ),
          );
    }
    if (error != null) {
      return errorBuilder?.call(context, error!, onRetry) ??
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                const Text('Could not load results.'),
                TextButton(onPressed: onRetry, child: const Text('Retry')),
              ],
            ),
          );
    }
    if (hasMore) {
      return TextButton(onPressed: onLoadMore, child: const Text('Load more'));
    }
    return const SizedBox.shrink();
  }
}
