import 'package:flutter/material.dart';

class AddColorDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {


    final _controller = TextEditingController();



    return Dialog(
      child: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: _controller,
            ),
            Container(
              alignment: Alignment.centerRight,
              child: FlatButton(
                child: Text("Add"),
                textColor: Colors.pinkAccent,
                onPressed: () {

                  Navigator.of(context).pop(_controller.text);

                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
