import 'package:flutter/material.dart';
import 'package:flutter_google_maps_webservices/places.dart';
import 'package:fyllo/api_keys.dart';

class ClusterListTile extends StatelessWidget {
  const ClusterListTile({super.key, required this.cluster});

  final PlacesSearchResult cluster;

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
                  child: Image.network(
                    cluster.photos.isEmpty
                        ? "https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/No-Image-Placeholder.svg/330px-No-Image-Placeholder.svg.png"
                        : "https://maps.googleapis.com/maps/api/place/photo?photo_reference=${cluster.photos.first.photoReference}&maxheight=${cluster.photos.first.height}&maxwidth=${cluster.photos.first.width}&key=$mapsApiKey",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cluster.name,
                      style: Theme.of(context).textTheme.bodyLarge,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4.0),
                    if (cluster.formattedAddress != null)
                      Column(
                        children: [
                          Text(
                            cluster.formattedAddress!,
                            style: Theme.of(context).textTheme.bodyMedium,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4.0),
                        ],
                      ),
                    Row(
                      children: [
                        SizedBox.square(
                          dimension: 16.0,
                          child: Image.network(cluster.icon ?? ""),
                        ),
                        const SizedBox(width: 4.0),
                        if (cluster.rating != null)
                          Flexible(
                            child: Text(
                              cluster.rating.toString(),
                              style: Theme.of(context).textTheme.bodyMedium,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        const SizedBox(width: 8.0),
                        if (cluster.openingHours != null)
                          Text(
                            cluster.openingHours!.openNow
                                ? "Open Now"
                                : "Closed",
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      fontWeight: cluster.openingHours!.openNow
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: cluster.openingHours!.openNow
                                          ? Colors.black
                                          : Colors.red,
                                    ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
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
