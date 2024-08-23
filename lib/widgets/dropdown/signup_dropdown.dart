// dropdown_widget.dart
import 'package:flutter/material.dart';

class HoursDropdown extends StatefulWidget {
  final Function(String) onChanged;
  final String hintText;
  final double maxHeight;
  String? selectedHour;

  HoursDropdown({
    super.key,
    required this.onChanged,
    this.hintText = "Select time",
    this.maxHeight = 200,
    this.selectedHour,
  });

  @override
  _HoursDropdownState createState() => _HoursDropdownState();
}

class _HoursDropdownState extends State<HoursDropdown> {
  @override
  void initState() {
    super.initState();
    _selectedhours = widget.selectedHour;
  }

  final _hours = [
    '00:00',
    '01:00',
    '02:00',
    '03:00',
    '04:00',
    '05:00',
    '06:00',
    '07:00',
    '08:00',
    '09:00',
    '10:00',
    '11:00',
    '12:00',
    '13:00',
    '14:00',
    '15:00',
    '16:00',
    '17:00',
    '18:00',
    '19:00',
    '20:00',
    "21:00",
    "22:00",
    "23:00",
    "24:00",
  ];
  String? _selectedhours;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Preferred Wake-up Time",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8), // 레이블과 드롭다운 사이 간격 추가
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            // 밑줄 제거
            child: DropdownButton<String>(
              value: _selectedhours,
              isExpanded: true, // 드롭다운 너비를 컨테이너에 맞춤
              hint: Text(widget.hintText), // 힌트 텍스트 표시
              items: _hours
                  .map((hour) =>
                      DropdownMenuItem(value: hour, child: Text(hour)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedhours = value!;
                  widget.selectedHour = value;
                });
                widget.onChanged(value!);
              },
              menuMaxHeight: widget.maxHeight,
            ),
          ),
        ),
      ],
    );
  }
}
