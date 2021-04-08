import 'package:flutter/material.dart';

class MessageTile extends StatelessWidget {
  final String _message;
  final bool _isSendByMe;

  MessageTile(this._message, this._isSendByMe);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      alignment: _isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _isSendByMe
                  ? [Color(0xff374ABE), Color(0xff64B6FF)]
                  : [Color(0xff0b5159), Color(0xff2a2f40)],
            ),
            borderRadius: _isSendByMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomLeft: Radius.circular(23),
                  )
                : BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomRight: Radius.circular(23),
                  )),
        child: Text(
          _message,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
