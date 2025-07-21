import 'package:flutter/material.dart';

// تعريف فئة للاعبين (Player) - تحتوي على الاسم والنقاط والأيقونة واللون
class Player {
  final String id; // معرف اللاعب الفريد
  final String name; // اسم اللاعب
  int position; // موقع اللاعب على اللوحة
  int score; // نقاط اللاعب الفردية
  int skippedTurns; // عدد الأدوار المتخطاة بسبب الكارت الأحمر
  final Widget icon; // <--- تم تغيير النوع إلى Widget لاستيعاب الصورة
  final Color color; // لون اللاعب (يمكن استخدامه لتظليل أو تأثيرات)

  Player({
    required this.id,
    required this.name,
    this.position = 0, // تبدأ من المربع الأول
    this.score = 0, // تبدأ النقاط بصفر
    this.skippedTurns = 0, // لا يوجد أدوار متخطاة في البداية
    required this.icon,
    required this.color,
  });

  // دالة لإنشاء نسخة من اللاعب مع تحديث بعض الخصائص
  Player copyWith({
    String? name,
    int? position,
    int? score,
    int? skippedTurns,
    int? previousPosition,
  }) {
    return Player(
      id: id,
      name: name ?? this.name,
      position: position ?? this.position,
      score: score ?? this.score,
      skippedTurns: skippedTurns ?? this.skippedTurns,
      icon: icon, // لا نغير الأيقونة هنا
      color: color,
    );
  }
}
