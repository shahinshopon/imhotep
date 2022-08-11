import 'package:flutter/material.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:flutter_svg/svg.dart';
import 'package:imhotep/constants.dart';
import 'package:imhotep/enums/subscription_type.dart';
import 'package:imhotep/models/app_user_extra_data_model.dart';
import 'package:imhotep/screens/subscription_screen.dart';
import 'package:imhotep/widgets/common_widgets/hotep_button.dart';
import 'package:peaman/peaman.dart';
import 'package:provider/provider.dart';

enum _Type {
  small,
  medium,
  large,
}

class PremiumFeedCover extends StatefulWidget {
  final _Type _type;
  final double borderRadius;

  const PremiumFeedCover.small({
    Key? key,
    this.borderRadius = 0.0,
  })  : _type = _Type.small,
        super(key: key);

  const PremiumFeedCover.medium({
    Key? key,
    this.borderRadius = 0.0,
  })  : _type = _Type.medium,
        super(key: key);
  const PremiumFeedCover.large({
    Key? key,
    this.borderRadius = 0.0,
  })  : _type = _Type.large,
        super(key: key);

  @override
  State<PremiumFeedCover> createState() => _PremiumFeedCoverState();
}

class _PremiumFeedCoverState extends State<PremiumFeedCover> {
  bool _coverVisible = true;

  @override
  Widget build(BuildContext context) {
    final _appUser = context.watch<PeamanUser>();
    final _appUserExtraData = AppUserExtraData.fromJson(_appUser.extraData);

    if (!_coverVisible ||
        _appUserExtraData.subscriptionType == SubscriptionType.level2 ||
        _appUserExtraData.subscriptionType == SubscriptionType.level3)
      return Container();

    return ClipRRect(
      borderRadius: BorderRadius.circular(
        widget.borderRadius,
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 10.0,
          sigmaY: 10.0,
        ),
        child: Container(
          width: MediaQuery.of(context).size.width,
          color: Colors.black.withOpacity(0.3),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/svgs/lock.svg',
                height: widget._type == _Type.small ? 20.0 : null,
              ),
              SizedBox(
                height: widget._type == _Type.small ? 10.0 : 20.0,
              ),
              Text(
                'Unlock this post\nby becoming premium',
                style: TextStyle(
                  fontSize: widget._type == _Type.small
                      ? 12.0
                      : widget._type == _Type.medium
                          ? 20.0
                          : 26.0,
                  color: whiteColor,
                ),
                textAlign: TextAlign.center,
              ),
              if (widget._type != _Type.small)
                SizedBox(
                  height: 20.0,
                ),
              if (widget._type != _Type.small)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    HotepButton.gradient(
                      value: 'Join now',
                      width: 150.0,
                      padding: const EdgeInsets.all(3.0),
                      borderRadius: 50.0,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SubscriptionScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              if (_appUser.admin && widget._type != _Type.small)
                SizedBox(
                  height: 10.0,
                ),
              if (_appUser.admin && widget._type != _Type.small)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    HotepButton.bordered(
                      value: 'Show post',
                      width: 150.0,
                      borderColor: whiteColor,
                      padding: const EdgeInsets.all(3.0),
                      borderRadius: 50.0,
                      onPressed: () {
                        setState(() {
                          _coverVisible = false;
                        });
                      },
                    ),
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }
}
