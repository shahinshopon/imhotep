import 'package:flutter/material.dart';
import 'package:imhotep/constants.dart';

class EditDeleteSelector extends StatelessWidget {
  final Function()? onEdit;
  final Function()? onDelete;
  const EditDeleteSelector({
    Key? key,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (onEdit != null)
          ListTile(
            leading: Icon(Icons.edit_rounded),
            iconColor: blackColor,
            title: Text('Edit'),
            onTap: () {
              Navigator.pop(context);
              onEdit?.call();
            },
          ),
        Divider(
          height: 0.0,
        ),
        if (onDelete != null)
          ListTile(
            leading: Icon(Icons.delete_rounded),
            iconColor: redAccentColor,
            textColor: redAccentColor,
            title: Text('Delete'),
            onTap: () {
              Navigator.pop(context);
              onDelete?.call();
            },
          ),
      ],
    );
  }
}
