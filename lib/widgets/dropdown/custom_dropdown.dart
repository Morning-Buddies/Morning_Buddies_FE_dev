import 'package:flutter/material.dart';
import 'package:morning_buddies/utils/design_palette.dart';

class CustomDropdown extends StatefulWidget {
  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;

  const CustomDropdown({
    Key? key,
    required this.value,
    required this.items,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  bool _isDropdownOpen = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  @override
  void dispose() {
    _overlayEntry?.remove(); // OverlayEntry만 제거
    super.dispose();
  }

  void _toggleOverlay() {
    setState(() {
      _isDropdownOpen = !_isDropdownOpen; // Overlay 표시 상태 토글
      if (_isDropdownOpen) {
        _createOverlay();
      } else {
        _overlayEntry?.remove();
        _overlayEntry = null;
      }
    });
  }

  void _createOverlay() {
    _overlayEntry?.remove(); // 기존 OverlayEntry 제거
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: 156, // DropdownButton의 너비와 동일하게 설정
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: const Offset(0.0, 32.0), // DropdownButton 아래에 위치하도록 조정
          child: Material(
            elevation: 4.0,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.5, // 화면 높이의 절반
              child: ListView(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                children: widget.items.map((String item) {
                  return ListTile(
                    title: Text(item),
                    onTap: () {
                      widget.onChanged(item);
                      _overlayEntry?.remove();
                      _overlayEntry = null;
                    },
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Container(
        width: 156,
        height: 24,
        decoration: BoxDecoration(
          border: Border.all(color: ColorStyles.secondaryOrange),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.value,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                ),
                onPressed: () {
                  // _overlayEntry?.remove();
                  // _overlayEntry = null;
                  _toggleOverlay();
                },
                child: const Text("edit",
                    style: TextStyle(
                      fontSize: 8,
                      color: ColorStyles.secondaryOrange,
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
