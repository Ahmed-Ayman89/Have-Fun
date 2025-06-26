// تعريف فئة لمربعات اللوحة (Square)
class BoardSquare {
  final String type; // normal, yellowCard, redCard
  final String content; // النص المعروض على المربع
  final String? question; // السؤال (لكروت الأصفار)
  final String? answer; // الإجابة (لكروت الأصفار)

  BoardSquare(
      {required this.type, required this.content, this.question, this.answer});
}
