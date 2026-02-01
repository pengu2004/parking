import "package:flutter/material.dart";





class Parkingbox extends StatelessWidget{
final int slotNumber;
final bool isAvailable;
final VoidCallback? onTap;
const Parkingbox({
  super.key
  ,
  required this.slotNumber,
  required this.isAvailable,
  required this.onTap,
});


@override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isAvailable ? onTap : null,
      child:Ink(
        decoration: BoxDecoration(
          color: isAvailable ? Colors.green[300] : Colors.grey[400],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black26),
        ),
      )
    );

  }
}