import 'package:flutter/material.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

/// [SelectionChip] is a selected option chip builder.
/// It is used to build the selected option chip.
class SelectionChip<T> extends StatelessWidget {
  final ChipConfig chipConfig;
  final Function(ValueItem<T>)? onItemDelete;
  final ValueItem<T> item;

  const SelectionChip({
    Key? key,
    required this.chipConfig,
    required this.item,
    required this.onItemDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Chip(
      padding: chipConfig.padding.copyWith(right: chipConfig.padding.right + (onItemDelete == null ? 8 : 0)),
      label: Text(item.label),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(chipConfig.radius),
      ),
      deleteIcon: onItemDelete == null ? null : chipConfig.deleteIcon,
      deleteIconColor: chipConfig.deleteIconColor,
      labelPadding: chipConfig.labelPadding,
      backgroundColor: onItemDelete == null ? chipConfig.backgroundDisabledColor ?? Theme.of(context).disabledColor:
          chipConfig.backgroundColor ?? Theme.of(context).primaryColor,
      labelStyle: chipConfig.labelStyle?.copyWith(color: onItemDelete == null ? chipConfig.labelDisabledColor :
      chipConfig.labelColor) ??
          TextStyle(color: onItemDelete == null ? chipConfig.labelDisabledColor : chipConfig.labelColor, fontSize: 14),
      onDeleted: onItemDelete == null ? null : () => onItemDelete!(item),
      side: chipConfig.borderSide,
    );
  }
}