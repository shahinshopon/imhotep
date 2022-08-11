import 'package:flutter/material.dart';
import 'package:imhotep/constants.dart';
import 'package:imhotep/helpers/common_helper.dart';
import 'package:imhotep/widgets/stories_widgets/stories_list_item.dart';
import 'package:peaman/peaman.dart';

class StoriesList extends StatelessWidget {
  final List<PeamanMoment> moments;
  final Function()? onPressedCreateMoment;

  StoriesList({
    required this.moments,
    this.onPressedCreateMoment,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: _momentsListBuilder(context),
    );
  }

  Widget _momentsListBuilder(final BuildContext context) {
    final _moments = moments;

    _moments.sort((a, b) {
      final _isAdminCreated = b.extraData['admin_created'] ?? false;
      return _isAdminCreated ? 1 : -1;
    });

    final _list = _moments.isEmpty ? [null] : [null, ..._moments];

    return Container(
      height: 100.0,
      child: Center(
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _list.length,
          itemBuilder: (context, index) {
            final _moment = _list[index];

            if (_moment == null) {
              return _addMomentBuilder(context);
            }
            return StoriesListItem(
              moment: _moment,
              moments: _moments,
            );
          },
        ),
      ),
    );
  }

  Widget _addMomentBuilder(final BuildContext context) {
    return GestureDetector(
      onTap: onPressedCreateMoment,
      behavior: HitTestBehavior.opaque,
      child: Container(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: CommonHelper.canCreateStory(context)
              ? Column(
                  children: [
                    Container(
                      width: 62.0,
                      height: 62.0,
                      decoration: BoxDecoration(
                        color: blueColor.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.add,
                          color: blueColor,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      'My Story',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12.0,
                        color: blackColor,
                      ),
                    ),
                  ],
                )
              : Container(),
        ),
      ),
    );
  }
}
