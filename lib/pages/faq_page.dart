import 'package:flutter/material.dart';
import '../widgets/app_search_bar.dart';
import '../widgets/app_faq_bar.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';

import '../pages/contact_page.dart';

class FaqPage extends StatefulWidget {
  const FaqPage({super.key});

  @override
  State<FaqPage> createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  final TextEditingController _searchController = TextEditingController();
  late List<FAQItem> _faqItems;
  late List<FAQItem> _filteredItems;

  @override
  void initState() {
    super.initState();
    _faqItems = [
      FAQItem(
        question: 'Lorem ipsum dolor sit amet?',
        answer:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, magna aliqua. Ut enim ad minim veniam.',
      ),
      FAQItem(
        question: 'Lorem ipsum dolor sit amet?',
        answer:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, magna aliqua. Ut enim ad minim veniam.',
      ),
      FAQItem(
        question: 'Lorem ipsum dolor sit amet?',
        answer:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, magna aliqua. Ut enim ad minim veniam.',
      ),
      FAQItem(
        question: 'Lorem ipsum dolor sit amet?',
        answer:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, magna aliqua. Ut enim ad minim veniam.',
      ),
    ];
    _filteredItems = _faqItems;
  }

  void _filterFaqs(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredItems = _faqItems;
      } else {
        _filteredItems = _faqItems
            .where(
              (item) =>
                  item.question.toLowerCase().contains(query.toLowerCase()) ||
                  item.answer.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppFaqBar(
                onBack: () => Navigator.of(context).pop(),
                onContact: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ContactPage()),
                  );
                },
              ),
              const SizedBox(height: 16),
              AppSearchBar(
                hintText: 'Rechercher un FAQ',
                controller: _searchController,
                onChanged: _filterFaqs,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: _filteredItems.length,
                  itemBuilder: (context, index) {
                    return FAQExpansionTile(item: _filteredItems[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FAQItem {
  final String question;
  final String answer;
  bool isExpanded;

  FAQItem({
    required this.question,
    required this.answer,
    this.isExpanded = false,
  });
}

class FAQExpansionTile extends StatelessWidget {
  final FAQItem item;

  const FAQExpansionTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [AppColors.defaultShadow],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: ExpansionTile(
            tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            title: Text(
              item.question,
              style: AppTextStyles.inter14Med.copyWith(
                color: AppColors.premier,
              ),
            ),
            trailing: Icon(
              item.isExpanded
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down,
              color: AppColors.premier,
            ),
            onExpansionChanged: (expanded) {
              item.isExpanded = expanded;
            },
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Text(
                  item.answer,
                  style: AppTextStyles.inter14Reg.copyWith(
                    color: AppColors.premier,
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
