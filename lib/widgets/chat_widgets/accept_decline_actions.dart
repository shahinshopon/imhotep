import 'package:flutter/material.dart';
import 'package:imhotep/constants.dart';
import 'package:peaman/peaman.dart';

class AcceptDeclineActions extends StatelessWidget {
  final PeamanUser friend;
  final Function()? onPressedAccept;
  final Function()? onPressedDecline;
  const AcceptDeclineActions({
    Key? key,
    required this.friend,
    this.onPressedAccept,
    this.onPressedDecline,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            height: 20.0,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 32.0),
            child: Text(
              '${friend.name} wants to send\nyou a message',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
          ),
          SizedBox(height: 20.0),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 32.0),
            child: Text(
              "They can’t see when you're online or\nwhen you've read their messages.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
          ),
          SizedBox(height: 20.0),
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: greyColorshade400,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: TextButton(
                    onPressed: onPressedDecline,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.0),
                      child: Text(
                        'Decline'.toUpperCase(),
                        style: TextStyle(
                          color: redAccentColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 55.0,
                  width: 1,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: greyColorshade400,
                    ),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: onPressedAccept,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.0),
                      child: Text(
                        'Accept'.toUpperCase(),
                        style: TextStyle(
                          color: blackColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
