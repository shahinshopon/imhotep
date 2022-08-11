import 'dart:io';
import 'package:flutter/material.dart';
import 'package:imhotep/widgets/create_post_widgets/upload_images_list_item.dart';

class UploadImagesList extends StatelessWidget {
  final List<File> imgFiles;
  final bool requiredEdit;
  final Function(File)? onDelete;
  final Function(File, int)? onEdit;
  const UploadImagesList({
    Key? key,
    required this.imgFiles,
    this.requiredEdit = false,
    this.onDelete,
    this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240.0,
      child: ListView.builder(
        itemCount: imgFiles.length,
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          final _imgFile = imgFiles[index];
          return UploadImageItem(
            imgFile: _imgFile,
            requiredEdit: requiredEdit,
            onDelete: onDelete,
            index: index,
            onEdit: (file) {
              onEdit?.call(file, index);
            },
            isLast: false,
          );
        },
      ),
    );
  }
}
