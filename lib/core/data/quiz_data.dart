import 'dart:math';

/// قائمة تحتوي على جميع الأسئلة.
/// كل سؤال هو عبارة عن Map يحتوي على:
/// - "question": نص السؤال.
/// - "options": قائمة بنصوص الخيارات.
/// - "answer": نص الإجابة الصحيحة (يجب أن يكون أحد الخيارات).
final List<Map<String, dynamic>> questions = [
  {
    "question": "Who directed the movie 'Inception'?",
    "options": ["Christopher Nolan", "Steven Spielberg", "James Cameron"],
    "answer": "Christopher Nolan",
  },
  {
    "question": "What is the name of the main character in 'Breaking Bad'?",
    "options": ["Walter White", "Jesse Pinkman", "Saul Goodman"],
    "answer": "Walter White",
  },
  {
    "question": "Which movie won the Oscar for Best Picture in 2020?",
    "options": ["Parasite", "1917", "Joker"],
    "answer": "Parasite",
  },
  {
    "question": "Who directed the movie 'Titanic'?",
    "options": ["James Cameron", "Steven Spielberg", "Christopher Nolan"],
    "answer": "James Cameron",
  },
  {
    "question": "What is the highest-grossing movie of all time?",
    "options": ["Avatar", "Avengers: Endgame", "Titanic"],
    "answer": "Avatar",
  },
  {
    "question": "Which movie features the quote 'I’ll be back'?",
    "options": ["The Terminator", "Rambo", "Predator"],
    "answer": "The Terminator",
  },
  {
    "question": "Who played the Joker in 'The Dark Knight'?",
    "options": ["Heath Ledger", "Joaquin Phoenix", "Jared Leto"],
    "answer": "Heath Ledger",
  },
  {
    "question": "What is the name of the wizarding school in 'Harry Potter'?",
    "options": ["Hogwarts", "Durmstrang", "Beauxbatons"],
    "answer": "Hogwarts",
  },
  {
    "question": "What is the name of the coffee shop in 'Friends'?",
    "options": ["The Bean", "Central Perk", "Coffee House"],
    "answer": "Central Perk",
  },
  {
    "question": "Which character says 'Winter is Coming' in 'Game of Thrones'?",
    "options": [
      "Jon Snow",
      "Tyrion Lannister" "Ned Stark",
    ],
    "answer": "Ned Stark",
  },
  {
    "question": "In 'Breaking Bad', what is Walter White's alias?",
    "options": ["Gustavo", "Heisenberg", "Tuco"],
    "answer": "Heisenberg",
  },
  {
    "question": "Which city is the main setting for 'Money Heist'?",
    "options": ["Barcelona", "Madrid", "Seville"],
    "answer": "Madrid",
  },
  {
    "question": "What is the name of the kingdom in 'The Witcher'?",
    "options": ["Nilfgaard", "Cintra", "Kaer Morhen"],
    "answer": "Cintra",
  },
  {
    "question": "Who is known as the 'King of Pop'?",
    "options": ["Elvis Presley", "Prince", "Michael Jackson"],
    "answer": "Michael Jackson",
  },
  {
    "question": "Which band released the song 'Bohemian Rhapsody'?",
    "options": ["The Beatles", "Queen", "Pink Floyd"],
    "answer": "Queen",
  },
  {
    "question": "Who sang 'Rolling in the Deep'?",
    "options": ["Beyoncé", "Adele", "Taylor Swift"],
    "answer": "Adele",
  },
  {
    "question": "Which artist is known for the album 'Thriller'?",
    "options": ["Madonna", "Prince", "Michael Jackson"],
    "answer": "Michael Jackson",
  },
  {
    "question": "Who is the lead singer of 'Coldplay'?",
    "options": ["Adam Levine", "Bono", "Chris Martin"],
    "answer": "Chris Martin",
  },
  {
    "question": "What is the capital of France?",
    "options": ["Paris", "Rome", "Berlin"],
    "answer": "Paris",
  },
  {
    "question": "How many continents are there on Earth?",
    "options": ["7", "5", "6"],
    "answer": "7",
  },
  {
    "question": "What is the chemical symbol for water?",
    "options": ["H2O", "O2", "CO2"],
    "answer": "H2O",
  },
  {
    "question": "Which planet is known as the Red Planet?",
    "options": ["Mars", "Venus", "Jupiter"],
    "answer": "Mars",
  },
  {
    "question": "Who wrote 'Romeo and Juliet'?",
    "options": ["William Shakespeare", "Charles Dickens", "Mark Twain"],
    "answer": "William Shakespeare",
  },
  {
    "question": "من أخرج فيلم 'The Godfather'?",
    "options": ["Francis Ford Coppola", "Martin Scorsese", "Quentin Tarantino"],
    "answer": "Francis Ford Coppola",
  },
  {
    "question": "من كان بطل فيلم 'The Matrix'؟",
    "options": ["Keanu Reeves", "Brad Pitt", "Johnny Depp"],
    "answer": "Keanu Reeves",
  },
  {
    "question": "أي فيلم فاز بجائزة أفضل فيلم في حفل الأوسكار لعام 1994؟",
    "options": ["Forrest Gump", "Pulp Fiction", "The Shawshank Redemption"],
    "answer": "Forrest Gump",
  },
  {
    "question": "في فيلم 'The Dark Knight'، من كان يؤدي دور شخصية 'The Joker'؟",
    "options": ["Heath Ledger", "Jared Leto", "Jack Nicholson"],
    "answer": "Heath Ledger",
  },
  {
    "question":
        "ما هو اسم الفيلم الذي أخرجه ستيفن سبيلبرغ حول الحرب العالمية الثانية؟",
    "options": ["Saving Private Ryan", "Schindler's List", "The Pianist"],
    "answer": "Saving Private Ryan",
  },
  {
    "question": "في مسلسل 'الأسطورة'، من كان يؤدي دور شخصية 'رفاعي الدسوقي'؟",
    "options": ["محمد رمضان", "أحمد السقا", "أمير كرارة"],
    "answer": "محمد رمضان",
  },
  {
    "question":
        "أي مسلسل عربي حصل على جائزة 'أفضل مسلسل درامي' في مهرجان القاهرة للإذاعة والتلفزيون 2020؟",
    "options": ["الهيبة", "كلبش", "حكايات بنات"],
    "answer": "الهيبة",
  },
  {
    "question": "في مسلسل 'فوق مستوى الشبهات'، من كانت تؤدي دور شخصية 'جيهان'؟",
    "options": ["يسرا", "غادة عبد الرازق", "منى زكي"],
    "answer": "يسرا",
  },
  {
    "question":
        "أي مسلسل عربي تدور أحداثه حول قصة حقيقية لشخصية مشهورة في مجال الرياضة؟",
    "options": ["العراب", "باب الحارة", "السبع وصايا"],
    "answer": "العراب",
  },
  {
    "question":
        "ما هو اسم المسلسل الذي كان يعرض في رمضان 2021 ويحكي قصة حياة أحد النجوم الكوميديين؟",
    "options": ["الاختيار", "بـ100 وش", "المرحلة"],
    "answer": "بـ100 وش",
  },
  {
    "question": "من هو بطل فيلم 'عمارة يعقوبيان'؟",
    "options": ["عادل إمام", "محمود عبد العزيز", "أحمد زكي"],
    "answer": "عادل إمام",
  },
  {
    "question":
        "في فيلم 'إبراهيم الأبيض'، من كان يؤدي دور شخصية 'إبراهيم الأبيض'؟",
    "options": ["أحمد السقا", "محمد رمضان", "كريم عبد العزيز"],
    "answer": "أحمد السقا",
  },
  {
    "question": "من هو المخرج الذي أخرج فيلم 'الفيل الأزرق'؟",
    "options": ["مروان حامد", "شريف عرفة", "طارق العريان"],
    "answer": "مروان حامد",
  },
  {
    "question": "أي فيلم عربي فاز بجائزة الأوسكار أفضل فيلم أجنبي في عام 2012؟",
    "options": [
      "فيلم 'الفرح'",
      "فيلم 'الشوق'",
      "فيلم 'الماء والخضرة والوجه الحسن'"
    ],
    "answer": "فيلم 'الماء والخضرة والوجه الحسن'",
  },
  {
    "question":
        "من كان أول من حصل على جائزة أفضل ممثل في مهرجان القاهرة السينمائي الدولي؟",
    "options": ["عادل إمام", "أحمد حلمي", "محمود عبد العزيز"],
    "answer": "عادل إمام",
  },
  {
    "question": "من هو بطل فيلم 'الجزيرة'؟",
    "options": ["أحمد السقا", "أمير كرارة", "محمود عبد العزيز"],
    "answer": "أحمد السقا",
  },
  {
    "question": "من هو المخرج الذي أخرج فيلم 'المصير'؟",
    "options": ["يوسف شاهين", "خالد يوسف", "شريف عرفة"],
    "answer": "يوسف شاهين",
  },
  {
    "question": "في فيلم 'عيون الصقر'، من كان يؤدي دور شخصية 'سيف'؟",
    "options": ["أحمد عبد العزيز", "أحمد السقا", "كريم عبد العزيز"],
    "answer": "أحمد عبد العزيز",
  },
  {
    "question": "من هو الفنان الذي شارك في فيلم 'الوعد' 2003؟",
    "options": ["محمود عبد العزيز", "أحمد زكي", "عمرو واكد"],
    "answer": "عمرو واكد",
  },
  {
    "question":
        "أي فيلم من أفلام أحمد حلمي فاز بجائزة أفضل فيلم كوميدي في مهرجان دبي السينمائي؟",
    "options": ["البدلة", "كده رضا", "آيس كريم في جليم"],
    "answer": "البدلة",
  },
];

final Random random = Random();

/// دالة لخلط قائمة الأسئلة وقائمة الخيارات داخل كل سؤال.
/// يجب استدعاء هذه الدالة في بداية كل اختبار جديد وفي كل مرة يتم فيها إعادة الاختبار.
void shuffleQuestionsAndOptions(List<Map<String, dynamic>> questionsList) {
  questionsList.shuffle(random);

  // ثانياً: المرور على كل سؤال في القائمة وخلط الخيارات الخاصة به.
  for (var question in questionsList) {
    // نتأكد من أننا نعمل على نسخة من القائمة لتجنب المشاكل
    final options = List<String>.from(question['options']);
    options.shuffle(random);

    // إعادة تعيين قائمة الخيارات بعد خلطها
    question['options'] = options;
  }
}
