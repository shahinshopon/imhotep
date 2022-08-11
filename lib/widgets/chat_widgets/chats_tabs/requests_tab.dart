import 'package:flutter/material.dart';
import 'package:imhotep/widgets/chat_widgets/chats_list.dart';
import 'package:peaman/peaman.dart';
import 'package:provider/provider.dart';
import '../../../constants.dart';
import '../../common_widgets/hotep_searchbar.dart';

class RequestsTab extends StatelessWidget {
  final List<PeamanChat>? idleChats;

  RequestsTab({
    Key? key,
    required this.idleChats,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _appUser = context.watch<PeamanUser>();
    return idleChats == null
        ? Center(
            child: CircularProgressIndicator(
              color: blueColor,
            ),
          )
        : Column(
            children: [
              SizedBox(
                height: 10.0,
              ),
              HotepSearchBar(
                hintText: 'Search requests...',
              ),
              SizedBox(
                height: 20.0,
              ),
              Expanded(
                child: ChatsList(
                  appUser: _appUser,
                  chats: idleChats,
                  requiredDivider: true,
                ),
              )
            ],
          );
  }
}
