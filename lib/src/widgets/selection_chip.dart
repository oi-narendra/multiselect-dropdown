import 'package:flutter/material.dart';
import '../../multiselect_dropdown.dart';

/// [SelectionChip] is a selected option chip builder.
/// It is used to build the selected option chip.
class SelectionChip<T> extends StatelessWidget {
  final ChipConfig chipConfig;
  final Function(T)? onItemDelete;
  final T item;
  final String label;

  const SelectionChip({
    Key? key,
    required this.chipConfig,
    required this.item,
    required this.onItemDelete,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Chip(
        padding: chipConfig.padding.copyWith(
            right: chipConfig.padding.right + (onItemDelete == null ? 8 : 0)),
        label: Text(label),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(chipConfig.radius),
        ),
        deleteIcon: onItemDelete == null ? null : chipConfig.deleteIcon,
        deleteIconColor: chipConfig.deleteIconColor,
        labelPadding: chipConfig.labelPadding,
        backgroundColor: onItemDelete == null
            ? chipConfig.backgroundDisabledColor ??
                Theme.of(context).disabledColor
            : chipConfig.backgroundColor ?? Theme.of(context).primaryColor,
        labelStyle: chipConfig.labelStyle?.copyWith(
                color: onItemDelete == null
                    ? chipConfig.labelDisabledColor
                    : chipConfig.labelColor) ??
            TextStyle(
                color: onItemDelete == null
                    ? chipConfig.labelDisabledColor
                    : chipConfig.labelColor,
                fontSize: 14),
        onDeleted: onItemDelete == null ? null : () => onItemDelete!(item),
        side: chipConfig.borderSide,
      );
}
