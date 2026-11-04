import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

import 'test_helpers.dart';

DropdownItem<int> _item(int value, [String? label]) =>
    DropdownItem(value: value, label: label ?? 'Result $value');

class _Request {
  _Request(this.query, this.cursor);
  final String query;
  final String? cursor;
  final result = Completer<DropdownPage<int>>();
}

class _Harness {
  final requests = <_Request>[];
  final controller = MultiSelectController<int>();
  final selections = <List<int>>[];
  late Widget widget;

  Future<DropdownPage<int>> load(String query, String? cursor) {
    final request = _Request(query, cursor);
    requests.add(request);
    return request.result.future;
  }

  Future<void> mount(
    WidgetTester tester,
    DropdownMode mode, {
    int maxSelections = 0,
    bool singleSelect = false,
    List<DropdownItem<int>> initialItems = const [],
    DropdownItemBuilder<int>? itemBuilder,
    WidgetBuilder? loadingBuilder,
    RemoteErrorBuilder? errorBuilder,
  }) async {
    widget = MultiDropdown<int>.remote(
      request: load,
      controller: controller,
      dropdownMode: mode,
      initialItems: initialItems,
      maxSelections: maxSelections,
      singleSelect: singleSelect,
      itemBuilder: itemBuilder,
      loadingBuilder: loadingBuilder,
      errorBuilder: errorBuilder,
      fieldDecoration: const FieldDecoration(hintText: 'Choose'),
      onSelectionChange: (values) => selections.add(List.of(values)),
    );
    await tester.pumpWidget(buildTestApp(widget));
    addTearDown(controller.dispose);
  }

  Future<void> open(WidgetTester tester) async {
    await tester.tap(find.byType(MultiDropdown<int>));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump();
  }

  Future<void> complete(
    WidgetTester tester,
    List<DropdownItem<int>> items, {
    String? next,
    int? index,
  }) async {
    requests[index ?? requests.length - 1].result.complete(
      DropdownPage(items: items, nextCursor: next),
    );
    await tester.pumpAndSettle();
  }

  Future<void> search(WidgetTester tester, String query) async {
    await tester.enterText(find.byType(TextField), query);
    await tester.pump(const Duration(milliseconds: 301));
    await tester.pump();
  }
}

void main() {
  for (final mode in DropdownMode.values) {
    group('$mode', () {
      testWidgets('initial loading, results and no extra terminal request', (
        tester,
      ) async {
        final h = _Harness();
        await h.mount(tester, mode);
        expect(h.requests.single.query, '');
        expect(h.requests.single.cursor, isNull);
        await h.open(tester);
        expect(find.text('Loading results…'), findsOneWidget);
        expect(find.text('No items found'), findsNothing);
        await h.complete(tester, [_item(1)]);
        expect(find.text('Result 1'), findsOneWidget);
        expect(find.text('Load more'), findsNothing);
        expect(find.byType(CircularProgressIndicator), findsNothing);
        expect(h.requests, hasLength(1));
      });

      testWidgets('debounces queries and rejects responses during debounce', (
        tester,
      ) async {
        final h = _Harness();
        await h.mount(tester, mode);
        await h.open(tester);
        await tester.enterText(find.byType(TextField), 'a');
        await tester.pump(const Duration(milliseconds: 150));
        await tester.enterText(find.byType(TextField), 'ab');
        h.requests.first.result.complete(
          DropdownPage(items: [_item(9, 'stale')]),
        );
        await tester.pump();
        expect(find.text('stale'), findsNothing);
        expect(h.requests, hasLength(1));
        await tester.pump(const Duration(milliseconds: 301));
        expect(h.requests, hasLength(2));
        expect(h.requests.last.query, 'ab');
        // Server matching may use fields other than the displayed label.
        await h.complete(tester, [_item(1, 'Server match')]);
        expect(find.text('Server match'), findsOneWidget);
      });

      testWidgets(
        'out-of-order success and failure cannot overwrite new query',
        (tester) async {
          final h = _Harness();
          await h.mount(tester, mode);
          await h.open(tester);
          await h.search(tester, 'old');
          await h.search(tester, 'new');
          await h.complete(tester, [_item(3, 'Newest')]);
          h.requests[1].result.completeError(StateError('old failure'));
          h.requests[0].result.complete(
            DropdownPage(items: [_item(1, 'Oldest')]),
          );
          await tester.pumpAndSettle();
          expect(find.text('Newest'), findsOneWidget);
          expect(find.text('Oldest'), findsNothing);
          expect(find.text('Retry'), findsNothing);
          expect(tester.takeException(), isNull);
        },
      );

      testWidgets('pagination keeps selection and deduplicates by value', (
        tester,
      ) async {
        final h = _Harness();
        await h.mount(tester, mode);
        await h.complete(tester, [_item(1)], next: 'page2');
        await h.open(tester);
        await tester.tap(find.text('Result 1'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Load more'));
        await tester.pump();
        expect(h.requests.last.cursor, 'page2');
        await h.complete(tester, [_item(1, 'Updated'), _item(2), _item(2)]);
        expect(h.controller.items.map((i) => i.value), [1, 2]);
        expect(h.controller.selectedItems.single.value, 1);
        expect(h.controller.selectedItems.single.label, 'Updated');
        expect(h.selections, [
          [1],
        ]);
      });

      testWidgets('first-page failure retries and then shows empty state', (
        tester,
      ) async {
        final h = _Harness();
        await h.mount(tester, mode);
        await h.open(tester);
        h.requests.single.result.completeError(StateError('offline'));
        await tester.pumpAndSettle();
        expect(find.text('Could not load results.'), findsOneWidget);
        await tester.tap(find.text('Retry'));
        await tester.pump();
        expect(h.requests.last.cursor, isNull);
        await h.complete(tester, []);
        expect(find.text('No items found'), findsOneWidget);
        expect(find.text('Retry'), findsNothing);
      });

      testWidgets('page failure retains rows and retries the same cursor', (
        tester,
      ) async {
        final h = _Harness();
        await h.mount(tester, mode);
        await h.complete(tester, [_item(1)], next: 'next');
        await h.open(tester);
        await tester.tap(find.text('Load more'));
        await tester.pump();
        h.requests.last.result.completeError(StateError('offline'));
        await tester.pumpAndSettle();
        expect(find.text('Result 1'), findsOneWidget);
        await tester.tap(find.text('Retry'));
        await tester.pump();
        expect(h.requests.last.cursor, 'next');
        await h.complete(tester, [_item(2)]);
        expect(h.controller.items.map((i) => i.value), [1, 2]);
      });

      testWidgets(
        'selections survive searches and limits include hidden selections',
        (tester) async {
          final h = _Harness();
          await h.mount(tester, mode, maxSelections: 1);
          await h.complete(tester, [_item(1)]);
          await h.open(tester);
          await tester.tap(find.text('Result 1'));
          await tester.pumpAndSettle();
          await h.search(tester, 'two');
          await h.complete(tester, [_item(2)]);
          await tester.tap(find.text('Result 2'));
          await tester.pumpAndSettle();
          expect(h.controller.selectedItems.map((i) => i.value), [1]);
          expect(h.controller.items.map((i) => i.value), [2]);
          h.controller.clearAll();
          await tester.pumpAndSettle();
          await tester.tap(find.text('Result 2'));
          await tester.pumpAndSettle();
          expect(h.controller.selectedItems.map((i) => i.value), [2]);
        },
      );

      testWidgets(
        'initial selections persist but server selection flags are ignored',
        (tester) async {
          final h = _Harness();
          await h.mount(
            tester,
            mode,
            initialItems: [_item(7).copyWith(selected: true)],
          );
          await h.complete(tester, [_item(1).copyWith(selected: true)]);
          expect(h.controller.selectedItems.map((i) => i.value), [7]);
          expect(h.controller.items.map((i) => i.value), [1]);
          expect(h.selections, isEmpty);
        },
      );

      testWidgets(
        'programmatic clearSearch updates text and fetches blank query',
        (tester) async {
          final h = _Harness();
          await h.mount(tester, mode);
          await h.complete(tester, []);
          await h.open(tester);
          await h.search(tester, 'find');
          await h.complete(tester, [_item(1)]);
          h.controller.clearSearch();
          await tester.pump(const Duration(milliseconds: 301));
          expect(
            tester.widget<TextField>(find.byType(TextField)).controller!.text,
            '',
          );
          expect(h.requests.last.query, '');
          await h.complete(tester, [_item(2)]);
        },
      );

      testWidgets('loading and error builders receive retry callback', (
        tester,
      ) async {
        final h = _Harness();
        await h.mount(
          tester,
          mode,
          loadingBuilder: (_) => const Text('Fetching'),
          errorBuilder: (_, error, retry) =>
              TextButton(onPressed: retry, child: Text('Again: $error')),
        );
        await h.open(tester);
        expect(find.text('Fetching'), findsOneWidget);
        h.requests.single.result.completeError(StateError('offline'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Again: Bad state: offline'));
        await tester.pump();
        await h.complete(tester, [_item(1)]);
      });

      testWidgets('scrolling near end loads only one page at a time', (
        tester,
      ) async {
        final h = _Harness();
        await h.mount(tester, mode);
        await h.complete(
          tester,
          List.generate(20, _item),
          next: 'next',
        );
        await h.open(tester);
        for (var i = 0; i < 8 && h.requests.length == 1; i++) {
          await tester.drag(find.byType(ListView).last, const Offset(0, -400));
          await tester.pump(const Duration(milliseconds: 400));
        }
        expect(h.requests, hasLength(2));
        await tester.drag(find.byType(ListView).last, const Offset(0, -100));
        await tester.pump(const Duration(milliseconds: 400));
        expect(h.requests, hasLength(2));
        await h.complete(tester, [_item(21)]);
      });

      testWidgets('stale next page is discarded when query changes', (
        tester,
      ) async {
        final h = _Harness();
        await h.mount(tester, mode);
        await h.complete(tester, [_item(1)], next: 'next');
        await h.open(tester);
        await tester.tap(find.text('Load more'));
        await tester.pump();
        await h.search(tester, 'new');
        await h.complete(tester, [_item(3)]);
        h.requests[1].result.complete(DropdownPage(items: [_item(2)]));
        await tester.pumpAndSettle();
        expect(h.controller.items.map((i) => i.value), [3]);
      });

      testWidgets('single selection replaces hidden selection and closes', (
        tester,
      ) async {
        final h = _Harness();
        await h.mount(
          tester,
          mode,
          singleSelect: true,
          initialItems: [
            DropdownItem(value: 7, label: 'Initial', selected: true),
          ],
        );
        await h.complete(tester, [_item(1)]);
        await h.open(tester);
        await tester.tap(find.text('Result 1'));
        await tester.pumpAndSettle();
        expect(h.controller.selectedItems.map((item) => item.value), [1]);
        expect(h.controller.isOpen, isFalse);
        expect(find.byType(TextField), findsNothing);
        expect(h.selections, [
          [1],
        ]);
      });

      testWidgets('reopening retains query and clear button resets results', (
        tester,
      ) async {
        final h = _Harness();
        await h.mount(tester, mode);
        await h.complete(tester, [_item(1)]);
        await h.open(tester);
        await h.search(tester, 'saved');
        await h.complete(tester, [_item(2)]);
        if (mode == DropdownMode.bottomSheet) {
          Navigator.of(tester.element(find.byType(TextField))).pop();
        } else {
          h.controller.closeDropdown();
        }
        await tester.pumpAndSettle();
        await h.open(tester);
        expect(
          tester.widget<TextField>(find.byType(TextField)).controller!.text,
          'saved',
        );
        expect(h.requests, hasLength(2));
        await tester.tap(find.byIcon(Icons.clear));
        await tester.pump(const Duration(milliseconds: 301));
        expect(h.requests.last.query, '');
        await h.complete(tester, [_item(3)]);
      });

      testWidgets('empty intermediate page can load the next page', (
        tester,
      ) async {
        final h = _Harness();
        await h.mount(tester, mode);
        await h.complete(tester, [], next: 'next');
        await h.open(tester);
        await tester.tap(find.text('Load more'));
        await tester.pump();
        expect(h.requests.last.cursor, 'next');
        await h.complete(tester, [_item(1)]);
        expect(find.text('Result 1'), findsOneWidget);
      });

      testWidgets('disabled results cannot be selected', (tester) async {
        final h = _Harness();
        await h.mount(tester, mode);
        await h.complete(tester, [
          DropdownItem(value: 1, label: 'Disabled', disabled: true),
        ]);
        await h.open(tester);
        await tester.tap(find.text('Disabled'));
        await tester.pumpAndSettle();
        expect(h.controller.selectedItems, isEmpty);
        expect(h.selections, isEmpty);
      });

      testWidgets('replacing loader ignores the previous request', (
        tester,
      ) async {
        final h = _Harness();
        await h.mount(tester, mode);
        await h.open(tester);
        final replacement = Completer<DropdownPage<int>>();
        var calls = 0;
        await tester.pumpWidget(
          buildTestApp(
            MultiDropdown<int>.remote(
              request: (query, cursor) {
                calls++;
                return replacement.future;
              },
              controller: h.controller,
              dropdownMode: mode,
            ),
          ),
        );
        expect(calls, 1);
        h.requests.single.result.complete(
          DropdownPage(items: [_item(9, 'Old')]),
        );
        await tester.pump();
        expect(find.text('Old'), findsNothing);
        replacement.complete(DropdownPage(items: [_item(2, 'New')]));
        await tester.pumpAndSettle();
        expect(find.text('New'), findsOneWidget);
      });

      testWidgets('replacing controller leaves external controller usable', (
        tester,
      ) async {
        final h = _Harness();
        await h.mount(tester, mode);
        final replacement = MultiSelectController<int>();
        addTearDown(replacement.dispose);
        await tester.pumpWidget(
          buildTestApp(
            MultiDropdown<int>.remote(
              request: h.load,
              controller: replacement,
              dropdownMode: mode,
            ),
          ),
        );
        expect(h.requests, hasLength(2));
        h.requests.first.result.completeError(StateError('old request'));
        await h.complete(tester, [_item(2)]);
        expect(h.controller.isDisposed, isFalse);
        h.controller.clearAll();
        expect(replacement.items.single.value, 2);
        await h.open(tester);
        expect(find.text('Result 2'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('dispose ignores pending requests and cancels debounce', (
        tester,
      ) async {
        final h = _Harness();
        await h.mount(tester, mode);
        await h.open(tester);
        await tester.enterText(find.byType(TextField), 'pending');
        await tester.pumpWidget(const SizedBox.shrink());
        h.requests.first.result.completeError(StateError('late'));
        await tester.pump(const Duration(seconds: 1));
        expect(h.requests, hasLength(1));
        expect(h.controller.isDisposed, isFalse);
        expect(tester.takeException(), isNull);
      });
    });
  }

  testWidgets('remote sheet keeps results and retry above the keyboard', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetViewInsets);
    final h = _Harness();
    await h.mount(tester, DropdownMode.bottomSheet);
    await h.complete(tester, [_item(1)]);
    await h.open(tester);
    await tester.tap(find.byType(TextField));
    tester.view.viewInsets = const FakeViewPadding(bottom: 336);
    await tester.pumpAndSettle();
    await h.search(tester, 'new');
    h.requests.last.result.completeError(StateError('offline'));
    await tester.pumpAndSettle();
    expect(tester.getBottomLeft(find.text('Retry')).dy, lessThan(508));
    await tester.tap(find.text('Retry'));
    await tester.pump();
    await h.complete(tester, [_item(2)]);
    expect(tester.getBottomLeft(find.text('Result 2')).dy, lessThan(508));
    await tester.tap(find.text('Result 2'));
    await tester.pumpAndSettle();
    expect(h.controller.selectedItems.single.value, 2);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'repeated cursor produces a recoverable error rather than a loop',
    (tester) async {
      final h = _Harness();
      await h.mount(tester, DropdownMode.overlay);
      await h.complete(tester, [_item(1)], next: 'same');
      await h.open(tester);
      await tester.tap(find.text('Load more'));
      await tester.pump();
      await h.complete(tester, [_item(2)], next: 'same');
      expect(find.text('Retry'), findsOneWidget);
      expect(h.controller.items.map((i) => i.value), [1]);
      expect(h.requests, hasLength(2));
    },
  );
}
