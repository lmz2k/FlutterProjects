import 'package:flutter/material.dart';


class DrawerTile extends StatelessWidget {

  final IconData icon;
  final String text;
  final PageController controller;
  final int Page;
  const DrawerTile(this.icon, this.text, this.controller, this.Page);




  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: (){
          controller.jumpToPage(Page);
          Navigator.of(context).pop();
        },
        child: Container(
          height: 60.0,
          child: Row(
            children: <Widget>[
              Icon(this.icon, size: 32, color: controller.page.round() == Page ? Theme.of(context).primaryColor : Colors.grey[700],),
              SizedBox(width: 32,),
              Text(
                this.text,
                style: TextStyle(
                    color: controller.page.round() == Page ? Theme.of(context).primaryColor : Colors.grey[700],
                    fontSize: 16.0),
              )

            ],
          ),
        ),
      ),
    );
  }
}
