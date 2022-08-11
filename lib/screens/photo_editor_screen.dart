import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imhotep/constants.dart';
import 'package:imhotep/helpers/date_time_helper.dart';
import 'package:imhotep/widgets/common_widgets/hotep_button.dart';
import 'package:path_provider/path_provider.dart';
import 'package:peaman/peaman.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import '../models/text_info.dart';
import '../widgets/stories_widgets/image_text.dart';

class PhotoEditorScreen extends StatefulWidget {
  const PhotoEditorScreen({Key? key}) : super(key: key);

  @override
  State<PhotoEditorScreen> createState() => _PhotoEditorScreenState();
}

class _PhotoEditorScreenState extends State<PhotoEditorScreen> {
  File? _imgFile;

  void _pickImage() async {
    final _pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (_pickedImage != null) {
      setState(() {
        _imgFile = File(_pickedImage.path);
      });
    }
  }

  TextEditingController textEditingController = TextEditingController();
  TextEditingController creatorText = TextEditingController();
  ScreenshotController screenshotController = ScreenshotController();
  DateTime _expiryDate = DateTime.now().add(
    Duration(hours: 24),
  );

  List<TextInfo> texts = [];
  int currentIndex = 0;
  bool _loading = false;

  saveToGallery(BuildContext context) async {
    final _currentDate = DateTime.now();
    setState(() {
      _loading = true;
    });
    final _appUser = context.read<PeamanUser>();

    try {
      final _img = await screenshotController.capture();

      if (_img == null) return;

      Directory tempDir = await getTemporaryDirectory();
      final _tempPath = tempDir.path;

      final _imgFile = await File(
        '${_tempPath}/my_image.png',
      ).writeAsBytes(_img);
      final _url = await PStorageProvider.uploadFile(
        'stories_imgs/${_appUser.uid}/${_currentDate.millisecondsSinceEpoch}',
        _imgFile,
      );

      if (_url == null) throw Future.error('Picture not uploaded');

      final _texts = texts.map((e) => e.text).toList();
      final _momentPicture = PeamanMomentPicture(
        id: Peaman.ref.collection('random').doc().id,
        url: _url,
        expiresAt: _expiryDate.millisecondsSinceEpoch,
        extraData: {
          'story_texts': _texts,
        },
      );

      final _moment = PeamanMoment(
        ownerId: _appUser.uid,
        pictures: [_momentPicture],
        expiresAt: _momentPicture.expiresAt,
        extraData: {
          'admin_created': _appUser.admin,
        },
      );

      PFeedProvider.createMoment(
        moment: _moment,
        onSuccess: (_) {
          Navigator.pop(context);
        },
        onError: (e) {
          print(e);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Unexpected error occured! Please try again later!',
              ),
            ),
          );
        },
      );
    } catch (e) {
      print(e);
    }
    setState(() {
      _loading = false;
    });
  }

  removeText(BuildContext context) {
    setState(() {
      texts.removeAt(currentIndex);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Deleted',
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }

  setCurrentIndex(BuildContext context, index) {
    setState(() {
      currentIndex = index;
    });
  }

  changeTextColor(Color color) {
    setState(() {
      texts[currentIndex].color = color;
    });
  }

  changeBgColor() {
    setState(() {
      if (texts[currentIndex].bgColor == whiteColor) {
        texts[currentIndex].bgColor = Colors.transparent;
      } else {
        texts[currentIndex].bgColor = whiteColor;
      }
    });
  }

  increaseFontSize() {
    setState(() {
      texts[currentIndex].fontSize += 2;
    });
  }

  decreaseFontSize() {
    setState(() {
      texts[currentIndex].fontSize -= 2;
    });
  }

  alignLeft() {
    setState(() {
      texts[currentIndex].textAlign = TextAlign.left;
    });
  }

  alignCenter() {
    setState(() {
      texts[currentIndex].textAlign = TextAlign.center;
    });
  }

  alignRight() {
    setState(() {
      texts[currentIndex].textAlign = TextAlign.right;
    });
  }

  boldText() {
    setState(() {
      if (texts[currentIndex].fontWeight == FontWeight.bold) {
        texts[currentIndex].fontWeight = FontWeight.normal;
      } else {
        texts[currentIndex].fontWeight = FontWeight.bold;
      }
    });
  }

  italicText() {
    setState(() {
      if (texts[currentIndex].fontStyle == FontStyle.italic) {
        texts[currentIndex].fontStyle = FontStyle.normal;
      } else {
        texts[currentIndex].fontStyle = FontStyle.italic;
      }
    });
  }

  addLinesToText() {
    setState(() {
      if (texts[currentIndex].text.contains('\n')) {
        texts[currentIndex].text =
            texts[currentIndex].text.replaceAll('\n', ' ');
      } else {
        texts[currentIndex].text =
            texts[currentIndex].text.replaceAll(' ', '\n');
      }
    });
  }

  addNewText(BuildContext context) {
    setState(() {
      texts.add(
        TextInfo(
          text: textEditingController.text,
          left: 0,
          top: 0,
          color: Colors.black,
          bgColor: Colors.white,
          fontWeight: FontWeight.normal,
          fontStyle: FontStyle.normal,
          fontSize: 20,
          textAlign: TextAlign.left,
        ),
      );

      textEditingController.clear();
      Navigator.of(context).pop();
    });
  }

  addNewDialog(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(
          'Add New Text',
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
        content: TextField(
          controller: textEditingController,
          decoration: const InputDecoration(
            suffixIcon: Icon(
              Icons.edit,
            ),
            filled: true,
            hintText: 'Your Text Here..',
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              bottom: 8.0,
              right: 8.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                HotepButton.bordered(
                  value: 'Done',
                  padding: const EdgeInsets.all(0.0),
                  onPressed: () {
                    addNewText(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _selectExpiryDate() async {
    final _currentDate = DateTime.now();
    final _selectedDate = await showDatePicker(
      context: context,
      initialDate: _currentDate,
      firstDate: _currentDate,
      lastDate: _currentDate.add(
        Duration(days: 1095),
      ),
    );

    if (_selectedDate != null) {
      setState(() {
        _expiryDate = DateTime(
          _selectedDate.year,
          _selectedDate.month,
          _selectedDate.day,
          _currentDate.hour,
          _currentDate.minute,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 10.0,
                left: 10.0,
                right: 20.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    color: whiteColor,
                    icon: Icon(
                      Icons.arrow_back_rounded,
                    ),
                  ),
                  if (_imgFile != null)
                    _loading
                        ? Container(
                            width: 30.0,
                            height: 30.0,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.0,
                              color: whiteColor,
                            ),
                          )
                        : Row(
                            children: [
                              GestureDetector(
                                onTap: _selectExpiryDate,
                                behavior: HitTestBehavior.opaque,
                                child: Text(
                                  'Expiry Date: ${DateTimeHelper.getFormattedDate(
                                    _expiryDate,
                                  )}',
                                  style: TextStyle(
                                    color: whiteColor,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 20.0,
                              ),
                              GestureDetector(
                                onTap: () {
                                  saveToGallery(context);
                                },
                                behavior: HitTestBehavior.opaque,
                                child: Text(
                                  'Upload',
                                  style: TextStyle(
                                    color: whiteColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                ],
              ),
            ),
            Expanded(
              child: Center(child: _imageBuilder()),
            ),
            Divider(),
            texts.isNotEmpty ? _actionsAfterTextAdd() : _actionsBuilder(),
            SizedBox(
              height: 10.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget _imageBuilder() {
    if (_imgFile == null)
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _pickImage,
        child: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_rounded,
                  color: whiteColor,
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  'Add Image',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: whiteColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    return Screenshot(
      controller: screenshotController,
      child: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Image.file(
                        _imgFile!,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          for (int i = 0; i < texts.length; i++)
            Positioned(
              left: texts[i].left,
              top: texts[i].top,
              child: GestureDetector(
                onLongPress: () {
                  setState(() {
                    currentIndex = i;
                    removeText(context);
                  });
                },
                onTap: () => setCurrentIndex(context, i),
                child: Draggable(
                  feedback: ImageText(textInfo: texts[i]),
                  child: ImageText(textInfo: texts[i]),
                  onDragEnd: (drag) {
                    final renderBox = context.findRenderObject() as RenderBox;
                    Offset off = renderBox.globalToLocal(drag.offset);
                    setState(() {
                      texts[i].top = off.dy - 96;
                      texts[i].left = off.dx;
                    });
                  },
                ),
              ),
            ),
          creatorText.text.isNotEmpty
              ? Positioned(
                  left: 0,
                  bottom: 0,
                  child: Text(
                    creatorText.text,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black.withOpacity(
                          0.3,
                        )),
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _actionsBuilder() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (_imgFile != null)
          IconButton(
            onPressed: () {
              addNewDialog(context);
            },
            color: whiteColor,
            splashRadius: 25.0,
            icon: Icon(
              Icons.text_increase_rounded,
            ),
          ),
      ],
    );
  }

  Widget _actionsAfterTextAdd() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {
                if (texts[currentIndex].textAlign == TextAlign.left) {
                  alignCenter();
                } else if (texts[currentIndex].textAlign == TextAlign.center) {
                  alignRight();
                } else if (texts[currentIndex].textAlign == TextAlign.right) {
                  alignLeft();
                }
              },
              splashRadius: 25.0,
              color: whiteColor,
              icon: Icon(
                texts[currentIndex].textAlign == TextAlign.left
                    ? Icons.format_align_left_rounded
                    : texts[currentIndex].textAlign == TextAlign.center
                        ? Icons.format_align_center_rounded
                        : Icons.format_align_right_rounded,
              ),
            ),
            IconButton(
              onPressed: () {
                boldText();
              },
              splashRadius: 25.0,
              color: whiteColor,
              icon: Container(
                padding: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: texts[currentIndex].fontWeight == FontWeight.bold
                      ? whiteColor
                      : Colors.transparent,
                ),
                child: Icon(
                  Icons.format_bold_rounded,
                  color: texts[currentIndex].fontWeight == FontWeight.bold
                      ? blackColor
                      : whiteColor,
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                italicText();
              },
              splashRadius: 25.0,
              color: whiteColor,
              icon: Container(
                padding: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: texts[currentIndex].fontStyle == FontStyle.italic
                      ? whiteColor
                      : Colors.transparent,
                ),
                child: Icon(
                  Icons.format_italic_rounded,
                  color: texts[currentIndex].fontStyle == FontStyle.italic
                      ? blackColor
                      : whiteColor,
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                addLinesToText();
              },
              splashRadius: 25.0,
              color: whiteColor,
              icon: Container(
                padding: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: texts[currentIndex].text.contains('\n')
                      ? whiteColor
                      : Colors.transparent,
                ),
                child: Icon(
                  Icons.next_plan_outlined,
                  color: texts[currentIndex].text.contains('\n')
                      ? blackColor
                      : whiteColor,
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                changeBgColor();
              },
              splashRadius: 25.0,
              color: whiteColor,
              icon: Container(
                padding: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: texts[currentIndex].bgColor == Colors.transparent
                      ? whiteColor
                      : Colors.transparent,
                ),
                child: Icon(
                  Icons.text_format_rounded,
                  color: texts[currentIndex].bgColor == Colors.transparent
                      ? blackColor
                      : whiteColor,
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                decreaseFontSize();
              },
              splashRadius: 25.0,
              color: whiteColor,
              icon: Icon(
                Icons.text_fields_rounded,
                color: whiteColor,
              ),
            ),
            IconButton(
              onPressed: () {
                increaseFontSize();
              },
              splashRadius: 25.0,
              color: whiteColor,
              icon: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(pi),
                child: Icon(
                  Icons.text_fields_rounded,
                  color: whiteColor,
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                addNewDialog(context);
              },
              color: whiteColor,
              splashRadius: 25.0,
              icon: Icon(
                Icons.text_increase_rounded,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10.0,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: _colorsBuilder(),
        ),
      ],
    );
  }

  Widget _colorsBuilder() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _colorItemBuilder(Colors.white),
        _colorItemBuilder(Colors.black),
        _colorItemBuilder(Colors.red),
        _colorItemBuilder(Colors.green),
        _colorItemBuilder(Colors.yellow),
        _colorItemBuilder(Colors.purple),
        _colorItemBuilder(Colors.orange),
        _colorItemBuilder(Colors.grey),
        _colorItemBuilder(Colors.brown),
        _colorItemBuilder(Colors.pink),
      ],
    );
  }

  Widget _colorItemBuilder(final Color color) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        changeTextColor(color);
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child: Container(
          width: 25.0,
          height: 25.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            border: Border.all(color: whiteColor),
          ),
        ),
      ),
    );
  }
}
