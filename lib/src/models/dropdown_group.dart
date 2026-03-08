part of '../multi_dropdown.dart';

/// Represents a named group of dropdown items.
///
/// Groups are rendered with a section header in the dropdown list,
/// allowing items to be organized into logical categories.
///
/// ```dart
/// final groups = [
///   DropdownGroup(label: 'Fruits', items: [
///     DropdownItem(label: 'Apple', value: 'apple'),
///     DropdownItem(label: 'Banana', value: 'banana'),
///   ]),
///   DropdownGroup(label: 'Vegetables', items: [
///     DropdownItem(label: 'Carrot', value: 'carrot'),
///   ]),
/// ];
/// ```
class DropdownGroup<T> {
  /// Creates a new [DropdownGroup] with the given [label] and [items].
  const DropdownGroup({
    required this.label,
    required this.items,
  });

  /// The display label for this group's section header.
  final String label;

  /// The dropdown items belonging to this group.
  final List<DropdownItem<T>> items;

  /// Creates a copy of this [DropdownGroup] with the specified overrides.
  DropdownGroup<T> copyWith({
    String? label,
    List<DropdownItem<T>>? items,
  }) {
    return DropdownGroup<T>(
      label: label ?? this.label,
      items: items ?? this.items,
    );
  }

  @override
  String toString() => 'DropdownGroup(label: $label, items: $items)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DropdownGroup<T> &&
        other.label == label &&
        listEquals(other.items, items);
  }

  @override
  int get hashCode => label.hashCode ^ items.hashCode;
}
