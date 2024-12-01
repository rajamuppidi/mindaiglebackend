import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import '../services/placeautocomplete_service.dart';

class LocationInputField extends StatefulWidget {
  final String hintText;
  final String? initialValue;
  final Function(LatLng) onLocationSelected;

  const LocationInputField({
    super.key,
    required this.hintText,
    this.initialValue,
    required this.onLocationSelected,
  });

  @override
  _LocationInputFieldState createState() => _LocationInputFieldState();
}

class _LocationInputFieldState extends State<LocationInputField> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, String>> _suggestions = [];
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _controller.text = widget.initialValue ?? '';
  }

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (value.length > 2) {
        _getSuggestions(value);
      } else {
        setState(() {
          _suggestions = [];
        });
      }
    });
  }

  void _getSuggestions(String input) async {
    try {
      final suggestions =
          await PlaceAutocompleteService.getPlaceSuggestions(input);
      setState(() {
        _suggestions = suggestions;
      });
    } catch (e) {
      print('Error fetching suggestions: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching suggestions: $e')),
      );
    }
  }

  void _selectPlace(String placeId, String description) async {
    try {
      final details = await PlaceAutocompleteService.getPlaceDetails(placeId);
      final location = LatLng(details['latitude']!, details['longitude']!);
      widget.onLocationSelected(location);
      _controller.text = description;
      setState(() {
        _suggestions = [];
      });
    } catch (e) {
      print('Error fetching place details: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching place details: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: widget.hintText,
            suffixIcon: const Icon(Icons.location_on),
          ),
          onChanged: _onChanged,
        ),
        if (_suggestions.isNotEmpty)
          SizedBox(
            height: 200,
            child: ListView.builder(
              itemCount: _suggestions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_suggestions[index]['description']!),
                  onTap: () => _selectPlace(_suggestions[index]['placeId']!,
                      _suggestions[index]['description']!),
                );
              },
            ),
          ),
      ],
    );
  }
}
