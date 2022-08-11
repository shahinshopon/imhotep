import 'package:flutter/material.dart';
import 'package:imhotep/screens/user_search_screen.dart';
import 'package:imhotep/viewmodels/chats_vm.dart';
import 'package:imhotep/viewmodels/vm_provider.dart';
import 'package:peaman/peaman.dart';
import '../../constants.dart';
import '../../widgets/chat_widgets/chats_tabs/contests_tab.dart';
import '../../widgets/chat_widgets/chats_tabs/primary_tab.dart';
import '../../widgets/chat_widgets/chats_tabs/requests_tab.dart';
import '../../widgets/common_widgets/hotep_searchbar.dart';

class ChatsTab extends StatefulWidget {
  const ChatsTab({Key? key}) : super(key: key);

  @override
  _ChatsTabState createState() => _ChatsTabState();
}

class _ChatsTabState extends State<ChatsTab> {
  @override
  Widget build(BuildContext context) {
    return VMProvider<ChatsVm>(
      vm: ChatsVm(context),
      builder: (context, vm, appVm, appUser) {
        final _acceptedChats = vm.allChats == null
            ? null
            : vm.allChats!
                .where((chat) =>
                    chat.chatRequestStatus ==
                        PeamanChatRequestStatus.accepted ||
                    chat.chatRequestSenderId == appUser!.uid)
                .toList();
        final _idleChats = vm.allChats == null
            ? null
            : vm.allChats!
                .where((chat) =>
                    chat.chatRequestStatus == PeamanChatRequestStatus.idle &&
                    chat.chatRequestSenderId != appUser!.uid)
                .toList();
        return DefaultTabController(
          length: 3,
          child: Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  SizedBox(
                    height: 10.0,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_1, _2, _3) => UserSearchScreen(),
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                      ),
                    ),
                    behavior: HitTestBehavior.opaque,
                    child: HotepSearchBar(
                      enabled: false,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        TabBar(
                          labelColor: blackColor,
                          unselectedLabelColor: greyColorshade400,
                          indicatorColor: blackColor,
                          tabs: [
                            Tab(
                              icon: Text(
                                'Primary',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            Tab(
                              icon: Text(
                                _idleChats != null && _idleChats.length != 0
                                    ? 'Requests (${_idleChats.length})'
                                    : 'Requests',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            Tab(
                              icon: Text(
                                'Contests',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              PrimaryTab(
                                appUser: appUser!,
                                chats: _acceptedChats,
                              ),
                              RequestsTab(
                                idleChats: _idleChats,
                              ),
                              ContestsTab(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
