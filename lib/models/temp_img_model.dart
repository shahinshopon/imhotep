import 'dart:io';

class TempImg {
  final String? parentId;
  final File? imgFile;
  final double? progress;

  TempImg({
    this.parentId,
    this.imgFile,
    this.progress,
  });

  TempImg copyWith({
    final String? parentId,
    final File? imgFile,
    final double? progress,
  }) {
    return TempImg(
      parentId: parentId ?? this.parentId,
      imgFile: imgFile ?? this.imgFile,
      progress: progress ?? this.progress,
    );
  }
}
