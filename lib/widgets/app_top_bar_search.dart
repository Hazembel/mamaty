import 'package:flutter/material.dart';
import '../widgets/app_search_bar.dart';
import '../widgets/app_filter_button.dart';

class AppSearchInput extends StatelessWidget {
  final String searchText;
  final VoidCallback? onSearchTap;
  final VoidCallback? onFilterTap;
  final ValueChanged<String>? onChanged; // ✅ added

  const AppSearchInput({
    super.key,
    required this.searchText,
    this.onSearchTap,
    this.onFilterTap,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppSearchBar(
            hintText: searchText,
            onChanged: onChanged, // ✅ pass it down
          ),
        ),
        const SizedBox(width: 35),
        AppFilterButton(onTap: onFilterTap),
      ],
    );
  }
}
