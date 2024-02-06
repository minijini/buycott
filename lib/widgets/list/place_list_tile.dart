import 'package:buycott/constants/padding_size.dart';
import 'package:flutter/material.dart';

class PlaceListTile extends StatelessWidget {
  final String placeName;
  final String addressName;

  const PlaceListTile({super.key, required this.placeName, required this.addressName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: sized_10),
      child: Row(
        children: [
          Icon(Icons.location_pin),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(placeName),
              Text(addressName),
            ],
          )
        ],
      ),
    );
  }
}
