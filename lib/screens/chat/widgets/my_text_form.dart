import 'package:flutter/material.dart';

class MyTextForm extends StatelessWidget {
  const MyTextForm({
    this.controller,
    this.onTap,
    Key? key,
    this.hintText = 'Your Massage',
    this.borderRadius = borderRadiusTop,
    this.color = Colors.amber,
    this.focusNode,
  }) : super(key: key);

  const MyTextForm.top({
    this.focusNode,
    this.controller,
    this.onTap,
    Key? key,
    this.hintText = 'Your Nickname',
    this.color = Colors.amber,
    this.borderRadius = borderRadiusBottom,
  }) : super(key: key);

  final FocusNode? focusNode;
  final String hintText;
  final Color color;
  final BorderRadius? borderRadius;
  final Function()? onTap;
  final TextEditingController? controller;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: boxDecoration,
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Container(
          decoration: BoxDecoration(
            color: color,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextFormField(
              focusNode: focusNode,
              autofocus: true,
              controller: controller,
              style: const TextStyle(fontSize: 18),
              decoration: InputDecoration(
                border: const OutlineInputBorder(borderSide: BorderSide.none),
                hintText: hintText,
                suffix: InkWell(
                  onTap: () {
                    onTap?.call();
                  },
                  child: const Icon(Icons.send),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

const boxDecoration = BoxDecoration(boxShadow: [
  BoxShadow(
    offset: Offset(0, 0),
    spreadRadius: 0.1,
    color: Colors.black26,
    blurRadius: 20,
  ),
]);

const borderRadiusTop = BorderRadius.only(
  topLeft: Radius.circular(20),
  topRight: Radius.circular(20),
);
const borderRadiusBottom = BorderRadius.only(
  bottomLeft: Radius.circular(20),
  bottomRight: Radius.circular(20),
);
