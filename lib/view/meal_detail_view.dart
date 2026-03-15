import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../model/meal_detail_model.dart';
import '../app_config.dart';

class MealDetailView extends StatelessWidget {
  final MealDetailModel meal;
  const MealDetailView({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 35.h,
            pinned: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.share, color: Colors.white),
                onPressed: () {
                  final text = 'Check out this delicious ${meal.strMeal}!\n\n'
                      'Ingredients: ${meal.ingredients?.take(5).join(', ')}...\n\n'
                      'Instructions: ${meal.strInstructions?.substring(0, 100)}...\n\n'
                      'Source: ${meal.strSource ?? 'TheMealDB'}';
                  SharePlus.instance.share(ShareParams(text: text));
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                meal.strMeal!,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(color: Colors.black45, blurRadius: 6, offset: Offset(1, 1))],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: 'meal-${meal.idMeal}',
                    child: Image.network(meal.strMealThumb!, fit: BoxFit.cover),
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Colors.black54, Colors.transparent],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(5.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _tag(meal.strCategory ?? 'Main'),
                      const SizedBox(width: 8),
                      _tag(meal.strArea ?? 'Global'),
                    ],
                  ),
                  SizedBox(height: 3.h),
                  const Text('Ingredients', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ...?meal.ingredients?.asMap().entries.map((e) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
                        Expanded(child: Text('${e.value} (${meal.measures![e.key]})')),
                      ],
                    ),
                  )),
                  SizedBox(height: 3.h),
                  const Text('Preparation', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(
                    meal.strInstructions!, 
                    style: TextStyle(height: 1.6, color: Colors.grey.shade800, fontSize: 15),
                  ),
                  SizedBox(height: 10.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tag(String text) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
    decoration: BoxDecoration(
      color: AppColors.primary.withValues(alpha: 0.1), 
      borderRadius: BorderRadius.circular(20)
    ),
    child: Text(
      text, 
      style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)
    ),
  );
}
