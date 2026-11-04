import 'package:material_ui/material_ui.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class RemoteExample extends StatefulWidget {
  const RemoteExample({super.key});

  @override
  State<RemoteExample> createState() => _RemoteExampleState();
}

class _RemoteExampleState extends State<RemoteExample> {
  bool _bottomSheet = false;
  bool _failNext = false;
  List<int> _selected = [];

  // Replace this simulated service with your API call. The cursor is opaque
  // to MultiDropdown; here it is simply an offset into the matching results.
  Future<DropdownPage<int>> _fetch(String query, String? cursor) async {
    final shouldFail = _failNext;
    _failNext = false;
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (shouldFail) {
      throw StateError('Simulated connection failure');
    }
    final matches = List.generate(60, (index) => index + 1)
        .where((id) => 'Member $id'.toLowerCase().contains(query.toLowerCase()))
        .toList();
    final offset = int.tryParse(cursor ?? '') ?? 0;
    final page = matches.skip(offset).take(10).toList();
    final end = offset + page.length;
    return DropdownPage(
      items: [
        for (final id in page) DropdownItem(label: 'Member $id', value: id),
      ],
      nextCursor: end < matches.length ? '$end' : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Remote Search')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Search 60 members, loaded 10 at a time. '
            'Selections stay selected when you search again.',
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Use bottom sheet'),
            value: _bottomSheet,
            onChanged: (value) => setState(() {
              _bottomSheet = value;
              _selected = [];
            }),
          ),
          OutlinedButton(
            onPressed: () {
              _failNext = true;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'The next request will fail. Use Retry to recover.',
                  ),
                ),
              );
            },
            child: const Text('Fail next request'),
          ),
          const SizedBox(height: 16),
          MultiDropdown<int>.remote(
            key: ValueKey(_bottomSheet),
            request: _fetch,
            dropdownMode: _bottomSheet
                ? DropdownMode.bottomSheet
                : DropdownMode.overlay,
            fieldDecoration: const FieldDecoration(hintText: 'Choose members'),
            searchDecoration: const SearchFieldDecoration(
              hintText: 'Search members',
              searchDebounceMs: 300,
            ),
            onSelectionChange: (values) => setState(() => _selected = values),
          ),
          const SizedBox(height: 16),
          Text(
            'Selected: ${_selected.isEmpty ? 'None' : _selected.join(', ')}',
          ),
        ],
      ),
    );
  }
}
