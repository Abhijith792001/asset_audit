import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final String hint;
  final String? selectedValue;
  final List<String> items;
  final Function(String) onChanged;

  const CustomDropdown({
    super.key,
    required this.hint,
    required this.selectedValue,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 600;
        final double fontSize = isDesktop ? 14 : 12;
        final double iconSize = isDesktop ? 22 : 20;
        final double buttonHeight = isDesktop ? 48 : 40;

        return DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            value: (selectedValue?.isEmpty ?? true) ? null : selectedValue,
            isExpanded: true,
            hint: Text(
              hint,
              style: TextStyle(
                fontSize: fontSize,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            selectedItemBuilder: (BuildContext context) {
              return items.map<Widget>((String value) {
                return Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.visible,
                  ),
                );
              }).toList();
            },
            items: items.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 1),
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.visible,
                  ),
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                onChanged(newValue);
              }
            },
            buttonStyleData: ButtonStyleData(
              height: buttonHeight,
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
            ),
            iconStyleData: IconStyleData(
              icon: Icon(
                Icons.keyboard_arrow_down_rounded, 
                color: Colors.grey[600],
                size: iconSize,
              ),
              iconSize: iconSize,
            ),
            dropdownStyleData: DropdownStyleData(
              maxHeight: 300,
              padding: EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              offset: const Offset(0, -5),
              scrollbarTheme: ScrollbarThemeData(
                radius: Radius.circular(40),
              ),
            ),
          ),
        );
      },
    );
  }
}