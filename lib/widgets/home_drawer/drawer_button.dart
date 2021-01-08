import 'package:flutter/material.dart';

class DrawerButton extends StatelessWidget {
  final String title;
  final Icon icon;
  final void Function()? onTap;

  DrawerButton({required this.title, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              SizedBox(
                width: 6,
              ),
              Text(
                title,
                style: TextStyle(fontSize: 20),
              )
            ],
          ),
        ));
  }
}
