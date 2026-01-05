import 'package:flutter/material.dart';
import 'package:reserv_plus/features/faq/data/faq_data.dart';
import 'package:reserv_plus/features/faq/domain/entities/faq_item.dart';
import 'package:reserv_plus/shared/utils/navigation_utils.dart';
import 'package:reserv_plus/features/shared/presentation/widgets/custom_back_header.dart';
import 'faq_detail_page.dart';

class FaqListPage extends StatelessWidget {
  const FaqListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final faqItems = FaqData.getAllFaqItems();

    return Scaffold(
      backgroundColor: const Color.fromRGBO(226, 223, 204, 1),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomBackHeader(title: 'Питання та\nвідповіді'),
            const SizedBox(height: 24),
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  separatorBuilder: (context, index) => Divider(
                    height: 2,
                    thickness: 1,
                    color: Colors.grey[400],
                  ),
                  itemCount: faqItems.length,
                  itemBuilder: (context, index) {
                    final faqItem = faqItems[index];
                    return Padding(
                      padding: EdgeInsets.only(
                        top: index == 0 ? 16 : 0,
                        bottom: 0,
                      ),
                      child: _buildFaqItemCard(context, faqItem),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqItemCard(BuildContext context, FaqItem faqItem) {
    return GestureDetector(
      onTap: () {
        NavigationUtils.pushWithHorizontalAnimation(
          context: context,
          page: FaqDetailPage(faqItem: faqItem),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                faqItem.question,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  height: 1.1,
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Icon(
              Icons.chevron_right,
              color: Colors.black,
              size: 30,
            ),
          ],
        ),
      ),
    );
  }
}
