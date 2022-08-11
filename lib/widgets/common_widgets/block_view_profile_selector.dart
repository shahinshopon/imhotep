import 'package:flutter/material.dart';
import 'package:imhotep/constants.dart';

class BlockAndViewProfileSelector extends StatelessWidget {
  final Function()? onViewProfile;
  final Function()? onBlock;
  final bool alreadyBlocked;
  const BlockAndViewProfileSelector({
    Key? key,
    this.onViewProfile,
    this.onBlock,
    this.alreadyBlocked = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (onViewProfile != null)
          ListTile(
            leading: Icon(Icons.person_rounded),
            iconColor: blackColor,
            title: Text('View Profile'),
            onTap: () {
              Navigator.pop(context);
              onViewProfile?.call();
            },
          ),
        Divider(
          height: 0.0,
        ),
        if (onBlock != null)
          ListTile(
            leading: Icon(Icons.block_rounded),
            iconColor: redAccentColor,
            textColor: redAccentColor,
            title: Text(
              alreadyBlocked ? 'Unblock User' : 'Block User',
            ),
            onTap: () {
              Navigator.pop(context);
              onBlock?.call();
            },
          ),
      ],
    );
  }
}
