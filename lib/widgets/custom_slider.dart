import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomSlider extends StatefulWidget {
  final String title;
  final double initialValue;
  final ValueChanged<double> onSave;
  final Color activeColor;
  final Color inactiveColor;

  const CustomSlider({super.key, 
    required this.title,
    required this.initialValue,
    required this.onSave,
    this.activeColor = const Color(0xFF064b8d),
    this.inactiveColor = Colors.grey,
  });

  @override
  _CustomSliderState createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  late double _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(widget.title, style: GoogleFonts.poppins(fontSize: 18)),
          Slider(
            value: _currentValue,
            min: 1,
            max: 5,
            divisions: 4,
            label: _currentValue.round().toString(),
            activeColor: widget.activeColor,
            inactiveColor: widget.inactiveColor,
            onChanged: (value) {
              setState(() {
                _currentValue = value;
              });
            },
          ),
          ElevatedButton(
            onPressed: () {
              widget.onSave(_currentValue);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFD700),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
            ),
            child: Text(
              'Guardar',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}