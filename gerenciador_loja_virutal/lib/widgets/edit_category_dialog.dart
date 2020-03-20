import 'package:flutter/material.dart';

class EditCategoryDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: GestureDetector(
                child: CircleAvatar(),
              ),
              title: TextField(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FlatButton(
                  onPressed: (){},
                  child: Text(
                    "Excluir",
                    style: TextStyle(color: Colors.red),
                  ),
                ),

                FlatButton(
                  onPressed: (){},
                  child: Text(
                    "Salvar",
                    style: TextStyle(color: Colors.black),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
