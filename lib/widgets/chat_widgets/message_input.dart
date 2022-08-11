import 'package:flutter/material.dart';

class MessageInput extends StatelessWidget {
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final Function()? onPressedOpenGallery;
  final Function()? onPressedSendMessage;
  const MessageInput({
    Key? key,
    this.controller,
    this.onChanged,
    this.onPressedSendMessage,
    this.onPressedOpenGallery,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      //search container
      padding: EdgeInsets.symmetric(
        horizontal: 8,
      ),
      margin: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.black12,
          width: 0.75,
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: <Widget>[
          IconButton(
            // send media icon
            icon: Icon(Icons.photo),
            iconSize: 30,
            color: Colors.black54,
            onPressed: onPressedOpenGallery,
          ),
          Expanded(
            child: TextFormField(
              controller: controller,
              keyboardType: TextInputType.multiline,
              maxLines: 5,
              minLines: 1,
              decoration: InputDecoration.collapsed(
                border: InputBorder.none,
                hintText: "Send a message..",
              ),
              onChanged: onChanged,
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
          IconButton(
            //send message Icon
            icon: Icon(Icons.send),
            iconSize: 25,
            color: Colors.black54,
            onPressed: onPressedSendMessage,
          ),
        ],
      ),
    );
  }
}
