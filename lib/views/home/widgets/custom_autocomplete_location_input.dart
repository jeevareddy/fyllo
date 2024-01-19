import 'package:flutter/material.dart';
import 'package:fyllo/api_keys.dart';
import 'package:google_maps_places_autocomplete_widgets/address_autocomplete_widgets.dart';

class CustomAutoCompleteLocationInput extends StatelessWidget {
  const CustomAutoCompleteLocationInput({
    super.key,
    this.controller,
    this.labelText,
    this.hintText, required this.onPlaceSelected,
  });
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final void Function(Place? selectedPlace) onPlaceSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null)
          Padding(
            padding: const EdgeInsets.only(left: 4.0, bottom: 4.0),
            child: Text(
              labelText!,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        AddressAutocompleteTextField(
          mapsApiKey: mapsApiKey,
          onSuggestionClick: (suggestion) {
            controller?.text = suggestion.formattedAddress ?? "";
            onPlaceSelected(suggestion);
          },
          componentCountry: 'uk',
          clearButton: const Icon(Icons.clear),
          onClearClick: () {
            onPlaceSelected(null);
            controller?.clear();
          },
          language: 'en-UK',
          controller: controller,
          decoration: InputDecoration(hintText: hintText),
        ),
      ],
    );
  }
}
