import 'package:flutter/material.dart';

class NumberDropdown extends StatefulWidget {
  const NumberDropdown({super.key});

  @override
  _NumberDropdownState createState() => _NumberDropdownState();
}

class _NumberDropdownState extends State<NumberDropdown> {
  int? _selectedValue;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
      value: _selectedValue,
      hint: const Text("Select how many people can join"),
      decoration: const InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFEFEFF0), width: 0.1),
        ),
      ),
      items: List.generate(5, (index) => index + 1)
          .map<DropdownMenuItem<int>>((int value) {
        return DropdownMenuItem<int>(
          value: value,
          child: Text(value.toString()),
        );
      }).toList(),
      onChanged: (int? newValue) {
        setState(() {
          _selectedValue = newValue;
        });
      },
    );
  }
}
