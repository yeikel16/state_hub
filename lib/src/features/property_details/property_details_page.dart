import 'package:flutter/material.dart';
import 'package:state_hub/src/data/models/models.dart';
import 'package:state_hub/src/features/property_details/view/property_details_view.dart';

class PropertyDetailsPage extends StatelessWidget {
  const PropertyDetailsPage({required this.property, super.key});

  final PropertyModel? property;

  @override
  Widget build(BuildContext context) {
    if (property == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(
          child: Text('Property not found'),
        ),
      );
    }

    return PropertyDetailsView(property: property!);
  }
}
