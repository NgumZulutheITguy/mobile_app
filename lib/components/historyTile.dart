import 'package:flutter/material.dart';

class HistoryTile extends StatefulWidget {
  final String text;
  final String sectionName;
  final void Function()? onPressed;

  const HistoryTile(
      {super.key,
      j,
      required this.text,
      required this.sectionName,
      this.onPressed});

  @override
  State<HistoryTile> createState() => _HistoryTileState();
}

class _HistoryTileState extends State<HistoryTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.only(left: 15, bottom: 15),
      margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
//section_name
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.sectionName,
                style: const TextStyle(color: Colors.black),
              ),

//edit button
              IconButton(onPressed: widget.onPressed, icon: const Icon(Icons.delete))
            ],
          ),

// text
          Text(widget.text),
        ],
      ),
    );
  }
}
