import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        value: (selectedValue?.isEmpty ?? true) ? null : selectedValue,
        isExpanded: true,
        hint: Text(
          hint,
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        // Custom selected item builder to show full text
        selectedItemBuilder: (BuildContext context) {
          return items.map<Widget>((String value) {
            return Container(
              alignment: Alignment.centerLeft,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
                // Remove overflow constraints for selected value
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
              padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 1.w),
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
                // Allow text to wrap in dropdown items
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
          // Increased height to accommodate multi-line text
          height: 40.h,
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12.r),
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
            size: 20.sp,
          ),
          iconSize: 20.sp,
        ),
        dropdownStyleData: DropdownStyleData(
          // Increased max height for better visibility
          maxHeight: 300.h,
          padding: EdgeInsets.symmetric(vertical: 6.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          // Allow dropdown to expand as needed
          offset: const Offset(0, -5),
          scrollbarTheme: ScrollbarThemeData(
            radius: Radius.circular(40.r),
         
          ),
        ),
      ),
    );
  }
}