import 'package:flutter/material.dart';
import 'package:imhotep/constants.dart';
import 'package:imhotep/widgets/feed_widgets/feed_share_users_list_item.dart';
import 'package:peaman/peaman.dart';

enum _Type {
  expanded,
  rounded,
}

class FeedShareUsersList extends StatelessWidget {
  final List<String> usersIds;
  final bool scroll;
  final Function(PeamanUser)? onPressedSend;
  final Function()? onPressedSearch;
  final Axis scrollDirection;
  final bool requiredSearch;
  final _Type type;

  const FeedShareUsersList.expanded({
    Key? key,
    required this.usersIds,
    this.scroll = false,
    this.onPressedSend,
    this.onPressedSearch,
    this.requiredSearch = false,
  })  : type = _Type.expanded,
        scrollDirection = Axis.vertical,
        super(key: key);

  const FeedShareUsersList.rounded({
    Key? key,
    required this.usersIds,
    this.scroll = false,
    this.onPressedSend,
    this.onPressedSearch,
    this.scrollDirection = Axis.vertical,
    this.requiredSearch = false,
  })  : type = _Type.rounded,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String?> _list = usersIds;

    if (requiredSearch) {
      _list = [null, ...usersIds];
    }

    return SizedBox(
      height: type == _Type.rounded && scrollDirection == Axis.horizontal
          ? 105.0
          : null,
      child: ListView.builder(
        itemCount: _list.length,
        shrinkWrap: !scroll,
        scrollDirection: scrollDirection,
        physics: scroll
            ? AlwaysScrollableScrollPhysics()
            : NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final _userId = _list[index];

          if (_userId == null) return _searchUserBuilder();

          return type == _Type.expanded
              ? FeedShareUsersListItem.expanded(
                  userId: _userId,
                  onPressedSend: onPressedSend,
                )
              : FeedShareUsersListItem.rounded(
                  userId: _userId,
                  onPressedSend: onPressedSend,
                );
        },
      ),
    );
  }

  Widget _searchUserBuilder() {
    if (type == _Type.expanded) return Container();
    return GestureDetector(
      onTap: onPressedSearch,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Container(
              width: 60.0,
              height: 60.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: greyColorshade300,
              ),
              child: Center(
                child: Icon(
                  Icons.search_rounded,
                  size: 30.0,
                  color: Colors.black45,
                ),
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Text(
              'Search',
              style: TextStyle(
                color: greyColor,
                fontWeight: FontWeight.bold,
                fontSize: 12.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
