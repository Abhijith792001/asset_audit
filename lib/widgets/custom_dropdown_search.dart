import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

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
            fontSize: 12,
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
                  fontSize: 12,
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
                  fontSize: 12,
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
          height: 40,
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
            size: 20,
          ),
          iconSize: 20,
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 300,
          direction: DropdownDirection.textDirection,
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
          scrollbarTheme: ScrollbarThemeData(radius: Radius.circular(40)),
        ),
        dropdownSearchData: DropdownSearchData(
          searchController: searchController,
          searchInnerWidgetHeight: 60,
          searchInnerWidget: Padding(
            padding: EdgeInsets.all(8),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search...',
                hintStyle: TextStyle(fontSize: 12),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
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
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Theme.of(context).primaryColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.history_rounded,
            size: 16,
            color: Theme.of(context).primaryColor.withOpacity(0.7),
          ),
          SizedBox(width: 6),
          Expanded(
            child: GestureDetector(
              onTap: onRecentUserTap,
              child: RichText(
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 11,
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
          SizedBox(width: 4),
          GestureDetector(
            onTap: onClearRecentlySelected,
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.close,
                size: 12,
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }
}