import 'package:flutter/material.dart';

import '../../../models/rack_model.dart';

class RackListTile extends StatelessWidget {
  const RackListTile({super.key, required this.rack});

  final RackModel rack;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250.0,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox.square(
                dimension: 72.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Icon(
                    Icons.electric_bike,
                    size: 52.0,
                    color: rack.isEnabled ? Colors.teal : Colors.grey,
                  ),
                ),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rack.city,
                      style: Theme.of(context).textTheme.bodyLarge,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4.0),
                    Column(
                      children: [
                        Text(
                          rack.address,
                          style: Theme.of(context).textTheme.bodyMedium,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4.0),
                      ],
                    ),
                    Text(
                      rack.isEnabled ? "Available" : "Not available",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: rack.isEnabled
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: rack.isEnabled ? Colors.black : Colors.red,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
