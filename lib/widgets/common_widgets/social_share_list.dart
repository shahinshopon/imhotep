import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:imhotep/widgets/common_widgets/social_share_list_item.dart';
import 'package:share/share.dart';

class SocialShareList extends StatelessWidget {
  final String link;
  SocialShareList({
    Key? key,
    required this.link,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 105.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          SocialShareListItem(
            img: 'assets/images/insta_logo.png',
            title: 'Instagram',
            onPressed: () {
              Share.share(link);
            },
          ),
          SocialShareListItem(
            img: 'assets/images/fb_logo.png',
            title: 'Facebook',
            onPressed: () {
              Share.share(link);
            },
          ),
          SocialShareListItem(
            img: 'assets/images/copy_link_logo.png',
            title: 'Copy Link',
            onPressed: () async {
              await Clipboard.setData(
                ClipboardData(text: link),
              );
              Fluttertoast.showToast(msg: 'Link Copied');
            },
          ),
          SocialShareListItem(
            img: 'assets/images/whats_app_logo.png',
            title: 'WhatsApp',
            onPressed: () {
              Share.share(link);
            },
          ),
          SocialShareListItem(
            img: 'assets/images/sms_logo.png',
            title: 'SMS',
            onPressed: () {
              Share.share(link);
            },
          ),
          SocialShareListItem(
            img: 'assets/images/more_logo.png',
            title: 'More',
            onPressed: () {
              Share.share(link);
            },
          ),
        ],
      ),
    );
  }
}
