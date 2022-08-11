import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:imhotep/constants.dart';
import 'package:imhotep/enums/subscription_type.dart';
import 'package:imhotep/helpers/dialog_provider.dart';
import 'package:imhotep/models/admin_model.dart';
import 'package:imhotep/models/app_user_extra_data_model.dart';
import 'package:imhotep/screens/conversation_screen.dart';
import 'package:imhotep/screens/subscription_screen.dart';
import 'package:imhotep/widgets/chat_widgets/chats_list.dart';
import 'package:peaman/peaman.dart';
import 'package:provider/provider.dart';

import '../../common_widgets/hotep_button.dart';

class PrimaryTab extends StatelessWidget {
  final PeamanUser appUser;
  final List<PeamanChat>? chats;
  PrimaryTab({
    Key? key,
    required this.appUser,
    required this.chats,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              HotepButton.bordered(
                value: 'Ask a question to Mr. Imhotep',
                borderColor: blueColor,
                textStyle: TextStyle(
                  color: blueColor,
                ),
                onPressed: () {
                  // if user is not subscribed then show them popup
                  final _appUserExtraData = AppUserExtraData.fromJson(
                    appUser.extraData,
                  );
                  if (_appUserExtraData.subscriptionType !=
                      SubscriptionType.level3) {
                    return DialogProvider(context).showBadgeDialog(
                      badgeUrl: 'assets/images/get_premium_dialog.png',
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SubscriptionScreen(),
                          ),
                        );
                      },
                    );
                  }
                  //

                  // open chat with admin
                  final _admin = context.read<Admin?>();
                  if (_admin == null) {
                    return Fluttertoast.showToast(
                      msg: 'An unexpected error occured!!!',
                    );
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ConversationScreen(
                        friend: _admin.user,
                      ),
                    ),
                  );
                  //
                },
                borderRadius: 20.0,
                padding: EdgeInsets.symmetric(
                  horizontal: 30.0,
                  vertical: 10.0,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          ChatsList(
            appUser: appUser,
            chats: chats,
          )
        ],
      ),
    );
  }
}

// Padding(
//   padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
//   child: Align(
//     alignment: Alignment.bottomCenter,
//     child: Container(
//       decoration:
//           BoxDecoration(borderRadius: BorderRadius.circular(30)),
//       child: Card(
//         shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(30)),
//         margin: EdgeInsets.zero,
//         elevation: 5,
//         child: ListTile(
//           title: Container(
//             child: TextField(
//               controller: msgController,
//               style: TextStyle(
//                 fontSize: 13,
//                 color: Colors.black87,
//               ),
//               cursorColor: Colors.black87,
//               decoration: InputDecoration(
//                 prefixIcon: Icon(Icons.attach_file),
//                 hintText: 'Comment',
//                 hintStyle: TextStyle(
//                   color: Colors.black87,
//                 ),
//                 enabledBorder: InputBorder.none,
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(50),
//                   borderSide: BorderSide(
//                     color: Color(0xffD5DDE0),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           trailing: GestureDetector(
//             onTap: () {
//               setState(() {
//                 textMsg = msgController.text.trim();
//                 count++;
//                 msgController.clear();
//               });
//             },
//             child: Text("Send"),
//           ),
//         ),
//       ),
//     ),
//   ),
// )
