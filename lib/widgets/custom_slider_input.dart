import 'package:flutter/material.dart';

class CustomSliderInput extends StatefulWidget {
  const CustomSliderInput({
    super.key,
    this.labelText,
    this.value,
    this.onChanged,
    this.min = 0,
    this.max = 50.0,
  });
  final String? labelText;
  final double? value;
  final double min;
  final double max;
  final void Function(double)? onChanged;

  @override
  State<CustomSliderInput> createState() => _CustomSliderInputState();
}

class _CustomSliderInputState extends State<CustomSliderInput> {
  @override
  void initState() {
    _value = widget.value ?? 0.0;
    super.initState();
  }

  double _value = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null)
          Padding(
            padding: const EdgeInsets.only(left: 4.0, bottom: 4.0),
            child: Text(
              widget.labelText!,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        Row(
          children: [
            Expanded(
              child: Slider(
                value: _value,
                min: widget.min,
                max: widget.max,
                label: _value.toString(),
                onChanged: (value) {
                  setState(() {
                    _value = value;
                  });
                  if (widget.onChanged != null) widget.onChanged!(value);
                },
              ),
            ),
            Text(
              "${_value.toStringAsPrecision(2)} mile(s)",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ],
    );
  }
}
