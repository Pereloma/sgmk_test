import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  const Background({Key? key, required this.scaffold}) : super(key: key);
  final Scaffold scaffold;
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/Rectangle.png"),
              fit: BoxFit.fitWidth,
              alignment: AlignmentDirectional.topCenter
          ),
      ),
      child: DecoratedBox(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: FractionalOffset(0.5, 0.2188),
                end: FractionalOffset.topCenter,
                colors: [
                  Color(0xFFFFFFFF),

                  Color(0x00FFFFFF)
                ])
        ),
        child: Scaffold(
          body: scaffold,
        ),
      ),
    );
  }
}
