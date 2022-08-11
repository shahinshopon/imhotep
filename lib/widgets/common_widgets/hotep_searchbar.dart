import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HotepSearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final bool autoFocus;
  final String hintText;
  final Function()? onPressed;
  final Function(String)? onFormSubmitted;
  final Function(String)? onChanged;
  final bool enabled;
  final Widget? trailing;
  final bool requiredPadding;
  final double? height;

  const HotepSearchBar({
    Key? key,
    this.controller,
    this.autoFocus = false,
    this.hintText = 'Search anyone...',
    this.onPressed,
    this.onFormSubmitted,
    this.onChanged,
    this.enabled = true,
    this.trailing,
    this.requiredPadding = true,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: requiredPadding ? 15.0 : 0.0),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onPressed,
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xffE4E4E4),
            borderRadius: BorderRadius.circular(20.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Row(
            children: [
              SvgPicture.asset('assets/svg/search.svg'),
              SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: SizedBox(
                  height: height,
                  child: TextFormField(
                    controller: controller,
                    autofocus: autoFocus,
                    enabled: enabled,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                    textInputAction: TextInputAction.search,
                    onFieldSubmitted: onFormSubmitted,
                    onChanged: onChanged,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: hintText,
                      hintStyle: TextStyle(
                        color: Color(0xff888888),
                      ),
                    ),
                  ),
                ),
              ),
              if (trailing != null)
                SizedBox(
                  width: 10.0,
                ),
              if (trailing != null) trailing!,
            ],
          ),
        ),
      ),
    );
  }
}
