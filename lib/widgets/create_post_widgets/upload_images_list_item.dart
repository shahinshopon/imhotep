import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';
import '../common_widgets/rounded_icon_button.dart';

class UploadImageItem extends StatelessWidget {
  final File imgFile;
  final bool requiredEdit;
  final Function(File)? onDelete;
  final Function(File)? onEdit;
  final bool? isLast;
  final int index;
  const UploadImageItem({
    Key? key,
    required this.imgFile,
    required this.index,
    this.requiredEdit = false,
    this.onDelete,
    this.onEdit,
    this.isLast = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160.0,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          decoration: BoxDecoration(
            color: kcLightOrangeColor,
            borderRadius: BorderRadius.circular(10.0),
            image: DecorationImage(
              image: imgFile.path.contains('_firebase_img123')
                  ? CachedNetworkImageProvider(
                      '${imgFile.path.replaceAll('_firebase_img123', '')}',
                    )
                  : FileImage(imgFile) as ImageProvider,
              fit: BoxFit.cover,
            ),
          ),
          padding: const EdgeInsets.only(
            bottom: 10.0,
            right: 10.0,
            top: 5.0,
            left: 6.0,
          ),
          child: isLast!
              ? Container()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RoundIconButton(
                      padding: const EdgeInsets.all(7.0),
                      shadow: BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.0,
                      ),
                      icon: Text(
                        '${index + 1}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        RoundIconButton(
                          onPressed: () => onEdit?.call(imgFile),
                          padding: const EdgeInsets.all(7.0),
                          shadow: BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10.0,
                          ),
                          icon: Icon(
                            Icons.edit,
                            size: 20.0,
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        RoundIconButton(
                          onPressed: () => onDelete?.call(imgFile),
                          padding: const EdgeInsets.all(7.0),
                          shadow: BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10.0,
                          ),
                          icon: Icon(
                            Icons.delete_outline_rounded,
                            size: 20.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
