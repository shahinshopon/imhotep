import 'package:flutter/material.dart';

class CommentInput extends StatelessWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? replyingTo;
  final Function()? onPressedSend;
  final Function()? onPressedCancelReply;
  final bool editing;
  const CommentInput({
    Key? key,
    this.controller,
    this.focusNode,
    this.replyingTo,
    this.onPressedSend,
    this.onPressedCancelReply,
    this.editing = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (editing || replyingTo != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    editing && replyingTo != null
                        ? 'Editing reply to '
                        : editing
                            ? 'Editing comment '
                            : 'Replying to ',
                  ),
                  if (replyingTo != null)
                    Text(
                      '$replyingTo',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
              GestureDetector(
                onTap: onPressedCancelReply,
                behavior: HitTestBehavior.opaque,
                child: Icon(
                  Icons.close_rounded,
                ),
              )
            ],
          ),
        if (editing || replyingTo != null)
          SizedBox(
            height: 10.0,
          ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
          ),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            margin: EdgeInsets.zero,
            elevation: 5,
            child: ListTile(
              title: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: TextFormField(
                  controller: controller,
                  keyboardType: TextInputType.multiline,
                  maxLines: 5,
                  minLines: 1,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black87,
                  ),
                  cursorColor: Colors.black87,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Type your comment...',
                    hintStyle: TextStyle(
                      color: Colors.black87.withOpacity(0.3),
                    ),
                  ),
                ),
              ),
              trailing: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onPressedSend,
                child: Text("Send"),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
