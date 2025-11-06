import 'package:flutter/material.dart';
import '../widgets/app_top_bar_text.dart';
import '../widgets/app_top_bar_search.dart';
import '../theme/colors.dart';
import '../theme/dimensions.dart';

class ArticlesPage extends StatefulWidget {
  final String title;
  final String searchPlaceholder;
  final VoidCallback? onBack;

  const ArticlesPage({
    super.key,
    this.title = 'Articles',
    this.searchPlaceholder = 'Rechercher un article',
    this.onBack,
  });

  @override
  State<ArticlesPage> createState() => _ArticlesPageState();
}

class _ArticlesPageState extends State<ArticlesPage> {
  String _searchQuery = '';

  void _onSearchChanged(String query) {
    setState(() => _searchQuery = query);
    // 🔹 You can later filter articles here based on _searchQuery
  }

  void _onFilterTap() {
    // 🔹 Open your filter modal here
    debugPrint('Filter button tapped');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: AppDimensions.pagePadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTopBarText(
                title: widget.title,
                onBack: widget.onBack ??
                    () {
                      if (Navigator.canPop(context)) Navigator.pop(context);
                    },
              ),
              const SizedBox(height: 15),
              AppSearchInput(
                searchText: widget.searchPlaceholder,
                onChanged: _onSearchChanged,
                onFilterTap: _onFilterTap,
              ),
              const SizedBox(height: 15),

              // 🔹 Placeholder for articles list
              Expanded(
                child: Center(
                  child: Text(
                    'Articles will appear here...',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
