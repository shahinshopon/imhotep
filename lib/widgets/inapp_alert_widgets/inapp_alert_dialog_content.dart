import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:imhotep/models/inapp_alert_model.dart';
import 'package:imhotep/widgets/common_widgets/hotep_button.dart';

import '../../constants.dart';

class InAppAlertDialogContent extends StatefulWidget {
  final InAppAlert inAppAlert;
  final Function(bool)? onDontShowAgain;
  final bool fromCreateScreen;
  const InAppAlertDialogContent({
    Key? key,
    required this.inAppAlert,
    this.onDontShowAgain,
    this.fromCreateScreen = false,
  }) : super(key: key);

  @override
  State<InAppAlertDialogContent> createState() =>
      _InAppAlertDialogContentState();
}

class _InAppAlertDialogContentState extends State<InAppAlertDialogContent> {
  bool _checked = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SizedBox(
        height: 450.0,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 200.0,
                      decoration: BoxDecoration(
                        color: greyColorshade200,
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(
                            widget.inAppAlert.imgUrl,
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Text(
                      widget.inAppAlert.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Linkify(
                            text: widget.inAppAlert.description,
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            if (!widget.fromCreateScreen)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: _checked,
                        onChanged: (val) {
                          setState(() {
                            _checked = val ?? false;
                          });

                          widget.onDontShowAgain?.call(_checked);
                        },
                      ),
                      Text("Don't show again")
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: HotepButton.bordered(
                      value: 'Close',
                      borderRadius: 20.0,
                      padding: const EdgeInsets.all(0.0),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
            if (!widget.fromCreateScreen)
              SizedBox(
                height: 0.0,
              ),
          ],
        ),
      ),
    );
  }
}
