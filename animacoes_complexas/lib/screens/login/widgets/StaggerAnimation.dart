import 'package:flutter/material.dart';

class StaggerAnimation extends StatelessWidget {
  final AnimationController controller;

  StaggerAnimation({this.controller})
      : buttonsqueeze = Tween(begin: 320.0, end: 60.0).animate(
      CurvedAnimation(parent: controller, curve: Interval(0.0, 0.150))), buttomZoomOut = Tween(
            begin: 60.0,
            end: 1000.0,
        ).animate(CurvedAnimation(parent: controller, curve: Interval(0.5, 1,curve: Curves.bounceInOut)));

  final Animation<double> buttonsqueeze;
  final Animation<double> buttomZoomOut;

  Widget _buildInside(context) {
    if (buttonsqueeze.value > 75) {
      return Text(
        "Sign In",
        style: TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.w300),
      );
    } else {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        strokeWidth: 1.0,
      );
    }
  }

  Widget _buildAnimation(BuildContext context, Widget child) {
    return Padding(
      padding: EdgeInsets.only(bottom: 50),
      child: InkWell(
        onTap: () {
          controller.forward();
        },
        child: Hero(tag: "fade", child:  buttomZoomOut.value<= 60 ?
        Container(
          width: buttonsqueeze.value,
          height: 60,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Color.fromRGBO(247, 64, 106, 1.0),
              borderRadius: BorderRadius.all(Radius.circular(30.0))),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _buildInside(context),
              ),
            ],
          ),
        ) :
        Container(
          width: buttomZoomOut.value,
          height: buttomZoomOut.value,
          decoration: BoxDecoration(
            color: Color.fromRGBO(247, 64, 106, 1.0),
            shape: buttomZoomOut.value <= 500 ? BoxShape.circle: BoxShape.rectangle,
          ),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
              ),
            ],
          ),
        ))

      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: _buildAnimation,
    );
  }
}
