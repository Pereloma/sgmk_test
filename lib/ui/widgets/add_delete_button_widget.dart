import 'package:flutter/material.dart';

class AddDeleteButton extends StatelessWidget {
  final bool active;
  final bool isAdd;
  final GestureTapCallback? onTap;

  const AddDeleteButton.add({Key? key, required this.active, this.onTap})
      : isAdd = true,
        super(key: key);

  const AddDeleteButton.delete({Key? key, required this.active, this.onTap})
      : isAdd = false,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(9.81818),
          color: active ? null : const Color(0x1AF43F5E),
          gradient: active
              ? const LinearGradient(
              begin: FractionalOffset(0.0012, 0.5),
              end: FractionalOffset(0.9988, 0.5),
              transform: GradientRotation(3.92699),
              colors: [Color(0xFFFF1843), Color(0xFFFF7E95)])
              : null,
        ),
    child: InkWell(
      onTap: active?onTap:null,
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: isAdd?Image.asset("assets/icons/add.png",color: !active?null:const Color(0xFFFFFFFF)):Image.asset("assets/icons/delete.png",color: !active?null:const Color(0xFFFFFFFF)),
      ),
    ),
    );
  }
}
