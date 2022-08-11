import 'package:flutter/material.dart';
import 'package:imhotep/constants.dart';
import 'package:imhotep/widgets/common_widgets/hotep_button.dart';

class DialogProvider {
  final BuildContext context;
  DialogProvider(this.context);

  // show normal dialog
  Future showNormalDialog({
    required final Widget widget,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.all(10.0),
        child: widget,
      ),
    );
  }

  // show alert dialog
  Future<void> showAlertDialog({
    required final String title,
    required final String description,
    final String? positiveText,
    final String? negativeText,
    final Function()? onPressedPositiveBtn,
    final Function()? onPressedNegativeBtn,
  }) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          insetPadding: const EdgeInsets.all(15.0),
          contentPadding: const EdgeInsets.only(
            top: 10.0,
            bottom: 20.0,
            left: 24.0,
            right: 24.0,
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (description.isNotEmpty)
                Text(
                  description,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: greyColor,
                    fontSize: 14.0,
                  ),
                ),
              SizedBox(
                height: description.isNotEmpty ? 15.0 : 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: HotepButton.filled(
                      value: positiveText ?? 'Yes',
                      color: redAccentColor,
                      onPressed: () {
                        onPressedPositiveBtn?.call();
                        Navigator.pop(context);
                      },
                      padding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                      ),
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                      borderRadius: 10.0,
                    ),
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  Expanded(
                    child: HotepButton.filled(
                      value: negativeText ?? 'No',
                      onPressed: () {
                        onPressedNegativeBtn?.call();
                        Navigator.pop(context);
                      },
                      padding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                      ),
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                      borderRadius: 10.0,
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  // show bottomsheet
  Future showBottomSheet({
    required final Widget widget,
    final bool scrollable = true,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: scrollable,
      builder: (context) => widget,
    );
  }

  // show maat warrior dialog
  Future showBadgeDialog({
    required final String badgeUrl,
    final Function()? onPressed,
  }) async {
    return showDialog(
      context: context,
      useRootNavigator: true,
      builder: (BuildContext ctx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(10),
          child: GestureDetector(
            onTap: onPressed,
            child: Image.asset(badgeUrl),
          ),
        );
      },
    );
  }
}
