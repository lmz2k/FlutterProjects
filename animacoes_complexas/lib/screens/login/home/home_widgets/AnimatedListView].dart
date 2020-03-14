import 'package:animacoes_complexas/screens/login/home/home_widgets/ListData.dart';
import 'package:flutter/material.dart';



class AnimatedListView extends StatelessWidget {

  final Animation<EdgeInsets> ListSlidePosition;
  AnimatedListView({this.ListSlidePosition});


  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        ListData(
          titulo: "Exercicios W",
          subtitle: "Series: X - Repetições X",
          image: AssetImage("images/fisioicon.jpg"),
          margin: ListSlidePosition.value * 0,
        ),
        ListData(
          titulo: "Exercicios T",
          subtitle: "Series: X - Repetições X",
          image: AssetImage("images/fisioicon.jpg"),
          margin: ListSlidePosition.value * 1,
        ),
        ListData(
          titulo: "Exercicios O",
          subtitle: "Series: X - Repetições X",
          image: AssetImage("images/fisioicon.jpg"),
          margin: ListSlidePosition.value * 2,
        ),
        ListData(
          titulo: "Exercicios X",
          subtitle: "Series: X - Repetições X",
          image: AssetImage("images/fisioicon.jpg"),
          margin: ListSlidePosition.value * 3,
        ),
        ListData(
          titulo: "Exercicios Y",
          subtitle: "Series: X - Repetições X",
          image: AssetImage("images/fisioicon.jpg"),
          margin: ListSlidePosition.value * 4,
        )
      ]
    );
  }
}
