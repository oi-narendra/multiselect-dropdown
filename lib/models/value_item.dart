/// [label] is the item that is displayed in the list. [value] is the value that is returned when the item is selected.
/// If the [value] is not provided, the [label] is used as the value.
/// An example of a [ValueItem] is:
/// ```dart
/// const ValueItem(label: 'Option 1', value: '1')
/// ```

class ValueItem {
  /// The label of the value item
  final String label;

  /// The value of the value item
  final String? value;

  const ValueItem({required this.label, this.value});
}
