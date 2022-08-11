import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imhotep/constants.dart';
import 'package:country_picker/country_picker.dart';

class TextFieldWithIcon extends StatefulWidget {
  final String text;
  final String hinttext;
  final IconData icons;
  final Function(XFile)? onImageSelect;
  final Function(String)? onCountrySelect;
  const TextFieldWithIcon(
    this.text,
    this.hinttext,
    this.icons, {
    Key? key,
    this.onImageSelect,
    this.onCountrySelect,
  }) : super(key: key);

  @override
  _TextFieldWithIconState createState() => _TextFieldWithIconState();
}

class _TextFieldWithIconState extends State<TextFieldWithIcon> {
  List<XFile>? _imageFileList;

  set _imageFile(XFile? value) {
    _imageFileList = value == null ? null : [value];
  }

  bool isVideo = false;

  final ImagePicker _picker = ImagePicker();
  void _onImageButtonPressed(
    ImageSource source, {
    BuildContext? context,
  }) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: source,
      );
      setState(() {
        _imageFile = pickedFile;
      });

      if (pickedFile != null) {
        widget.onImageSelect?.call(pickedFile);
      }
    } catch (e) {}
  }

  var selectedCountry;
  bool checkHint = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.text,
              style: const TextStyle(
                color: whiteColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 5),
          InkWell(
            onTap: () {
              if (widget.text == 'Country') {
                showCountryPicker(
                  context: context,
                  searchAutofocus: true,
                  showPhoneCode: false,
                  onSelect: (Country country) {
                    widget.onCountrySelect?.call(country.name);
                    setState(() {
                      selectedCountry = country.name;
                      checkHint = true;
                    });
                  },
                );
              } else if (widget.text == 'Upload Profile Image') {
                _onImageButtonPressed(
                  ImageSource.gallery,
                  context: context,
                );
                print('profile clicked');
              }
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                color: whiteColor,
                border: Border.all(color: Colors.transparent),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: widget.text == 'Country'
                    ? TextField(
                        enabled: false,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          suffixIcon: Icon(widget.icons),
                          focusedBorder: InputBorder.none,
                          hintText:
                              checkHint ? selectedCountry : widget.hinttext,
                        ),
                      )
                    : (_imageFileList?.isEmpty ?? true)
                        ? TextField(
                            enabled: false,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              suffixIcon: Icon(widget.icons),
                              focusedBorder: InputBorder.none,
                              hintText:
                                  checkHint ? selectedCountry : widget.hinttext,
                            ),
                          )
                        : Container(
                            height: 45.0,
                            child: Row(
                              children: [
                                Container(
                                  height: 35.0,
                                  width: 35.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: FileImage(
                                        File(_imageFileList!.first.path),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Text(
                                  'Tap to change image',
                                  style: TextStyle(
                                    color: Colors.black38,
                                    fontSize: 15.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
