import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDropdownSearch extends StatelessWidget {
  final String hint;
  final String? selectedValue;
  final List<String> items;
  final Function(String) onChanged;
  final String? recentlySelectedUser;
  final VoidCallback? onClearRecentlySelected;
  final VoidCallback? onRecentUserTap;

  const CustomDropdownSearch({
    super.key,
    required this.hint,
    required this.selectedValue,
    required this.items,
    required this.onChanged,
    this.recentlySelectedUser,
    this.onClearRecentlySelected,
    this.onRecentUserTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDropdown(context),
        if (recentlySelectedUser != null && recentlySelectedUser!.isNotEmpty)
          _buildRecentlySelected(context),
      ],
    );
  }

  Widget _buildDropdown(BuildContext context) {
    final TextEditingController searchController = TextEditingController();

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
          maxHeight: 300.h,
          direction: DropdownDirection.textDirection,
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
          scrollbarTheme: ScrollbarThemeData(radius: Radius.circular(40.r)),
        ),
        dropdownSearchData: DropdownSearchData(
          searchController: searchController,
          searchInnerWidgetHeight: 60.h,
          searchInnerWidget: Padding(
            padding: EdgeInsets.all(8.w),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search...',
                hintStyle: TextStyle(fontSize: 12.sp),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 10.w,
                  vertical: 8.h,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
          ),
          searchMatchFn: (item, searchValue) {
            final itemVal = item.value ?? '';
            final searchVal = searchValue ?? '';
            return itemVal.toLowerCase().contains(searchVal.toLowerCase());
          },
        ),
        onMenuStateChange: (isOpen) {
          if (!isOpen) {
            searchController.clear();
          }
        },
      ),
    );
  }

  Widget _buildRecentlySelected(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: Theme.of(context).primaryColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.history_rounded,
            size: 16.sp,
            color: Theme.of(context).primaryColor.withOpacity(0.7),
          ),
          SizedBox(width: 6.w),
          Expanded(
            child: GestureDetector(
              onTap: onRecentUserTap,
              child: RichText(
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                  children: [
                    TextSpan(text: 'Recent: '),
                    TextSpan(
                      text: recentlySelectedUser!,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 4.w),
          GestureDetector(
            onTap: onClearRecentlySelected,
            child: Container(
              padding: EdgeInsets.all(4.sp),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.close,
                size: 12.sp,
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }
}