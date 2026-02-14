import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

void main() {
  group('Decoration Models', () {
    test('SearchFieldDecoration has customization properties', () {
      const decoration = SearchFieldDecoration(
        textStyle: TextStyle(fontSize: 16),
        hintStyle: TextStyle(color: Colors.grey),
        fillColor: Colors.white,
        filled: true,
        cursorColor: Colors.blue,
        autofocus: true,
      );

      expect(decoration.textStyle?.fontSize, 16);
      expect(decoration.filled, true);
      expect(decoration.showClearIcon, true);
      expect(decoration.autofocus, true);
      expect(decoration.cursorColor, Colors.blue);
      expect(decoration.fillColor, Colors.white);
    });

    test('DropdownItemDecoration accepts Widget? for icons', () {
      const decoration = DropdownItemDecoration(
        disabledIcon: Icon(Icons.block),
        textStyle: TextStyle(fontSize: 14),
        selectedTextStyle: TextStyle(fontWeight: FontWeight.bold),
      );

      expect(decoration.selectedIcon, isA<Icon>());
      expect(decoration.disabledIcon, isA<Icon>());
      expect(decoration.textStyle?.fontSize, 14);
      expect(decoration.selectedTextStyle?.fontWeight, FontWeight.bold);
    });

    test('DropdownDecoration has noItemsFoundText and expandDirection', () {
      const decoration = DropdownDecoration(
        noItemsFoundText: 'Custom empty text',
        expandDirection: ExpandDirection.down,
      );

      expect(decoration.noItemsFoundText, 'Custom empty text');
      expect(decoration.expandDirection, ExpandDirection.down);
    });

    test('DropdownDecoration defaults to auto expandDirection', () {
      const decoration = DropdownDecoration();
      expect(decoration.expandDirection, ExpandDirection.auto);
    });

    test('ChipDecoration has maxDisplayCount', () {
      const decoration = ChipDecoration(maxDisplayCount: 3);
      expect(decoration.maxDisplayCount, 3);
    });

    test('ChipDecoration maxDisplayCount defaults to null', () {
      const decoration = ChipDecoration();
      expect(decoration.maxDisplayCount, null);
    });

    test('FieldDecoration has selectedItemTextStyle', () {
      const decoration = FieldDecoration(
        selectedItemTextStyle: TextStyle(fontSize: 18),
      );
      expect(decoration.selectedItemTextStyle?.fontSize, 18);
    });

    test('FieldDecoration has inputDecoration override', () {
      const decoration = FieldDecoration(
        inputDecoration: InputDecoration(labelText: 'Test'),
      );
      expect(decoration.inputDecoration?.labelText, 'Test');
    });

    test('ExpandDirection enum has all expected values', () {
      expect(ExpandDirection.values.length, 3);
      expect(ExpandDirection.values, contains(ExpandDirection.auto));
      expect(ExpandDirection.values, contains(ExpandDirection.up));
      expect(ExpandDirection.values, contains(ExpandDirection.down));
    });
  });
}
