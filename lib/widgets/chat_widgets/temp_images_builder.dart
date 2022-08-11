import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/temp_imgs_vm.dart';

class TempImgsBuilder extends StatelessWidget {
  final String parentId;
  const TempImgsBuilder(
    this.parentId, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _tempImgVm = context.watch<TempImgVM>();

    final _widgets = <Widget>[];

    _tempImgVm.tempImgs
        .where((element) => element.parentId == parentId)
        .forEach((element) {
      final _widget = Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width / 1.7,
              ),
              child: Center(
                child: Stack(
                  children: [
                    Image.file(
                      element.imgFile!,
                    ),
                    Positioned.fill(
                      child: Center(
                        child: Container(
                          width: 50.0,
                          height: 50.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black45,
                          ),
                          padding: const EdgeInsets.all(4.0),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            width: 20.0,
          ),
        ],
      );
      _widgets.add(_widget);
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: _widgets,
    );
  }
}
