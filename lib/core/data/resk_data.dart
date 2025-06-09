class Category {
  final String title;
  final String description;
  final List<Question> questions;

  Category({
    required this.title,
    required this.description,
    required this.questions,
  });
}

class Question {
  final String questionText; // نص السؤال
  final int points; // عدد النقاط
  final String answer; // الإجابة الصحيحة

  Question({
    required this.questionText,
    required this.points,
    required this.answer,
  });
}

// هنا نقوم بتعريف الأسئلة الخاصة بكل فئة
List<Category> categories = [
  Category(
    title: 'دوريات عربية',
    description: 'أسئلة عن دوريات كرة القدم في البلدان العربية',
    questions: [
      Question(
          questionText: 'من هو بطل الدوري المصري لهذا العام؟',
          points: 5,
          answer: 'الأهلي'),
      Question(
          questionText: 'من هو الهداف التاريخي للدوري السعودي؟',
          points: 10,
          answer: 'ماجد عبدالله'),
      Question(
          questionText: 'ما هي أكبر فوز في تاريخ دوري الإمارات؟',
          points: 20,
          answer: 'الجزيرة 8-0 الوحدة'),
      Question(
          questionText: 'من هو اللاعب الأكثر تتويجًا بالدوري التونسي؟',
          points: 40,
          answer: 'النجم الساحلي'),
    ],
  ),
  Category(
    title: 'بنزيما',
    description: 'أسئلة عن اللاعب كريم بنزيما',
    questions: [
      Question(
          questionText: 'كم عدد أهداف بنزيما مع ريال مدريد؟',
          points: 5,
          answer: '437 هدف'),
      Question(
          questionText: 'في أي عام انضم بنزيما إلى ريال مدريد؟',
          points: 10,
          answer: '2009'),
      Question(
          questionText: 'من هو المدرب الذي أشرف على بنزيما في أول سنواته؟',
          points: 20,
          answer: 'جوزيه مورينيو'),
      Question(
          questionText: 'ما هو رقم قميص بنزيما مع المنتخب الفرنسي؟',
          points: 40,
          answer: '19'),
    ],
  ),
  Category(
    title: 'برشلونة',
    description: 'أسئلة عن فريق برشلونة',
    questions: [
      Question(
          questionText:
              'في أي موسم فاز برشلونة بالثلاثية (الدوري، كأس الملك، دوري الأبطال) بقيادة لويس إنريكي؟',
          points: 5,
          answer: '2014-2015 موسم'),
      Question(
          questionText:
              'من هو اللاعب الذي سجل أكبر عدد من الأهداف في تاريخ برشلونة في موسم واحد؟',
          points: 10,
          answer: 'ميسي'),
      Question(
          questionText:
              'ما هو رقم الموسم الذي فاز فيه برشلونة بكأس دوري أبطال أوروبا بعد 14 سنة من الغياب؟',
          points: 20,
          answer: '2006'),
      Question(
          questionText:
              'من هو المدرب الذي فاز بأكبر عدد من الألقاب مع برشلونة في القرن الواحد والعشرين؟',
          points: 40,
          answer: 'جوارديولا'),
    ],
  ),
  Category(
    title: 'ريال مدريد',
    description: 'أسئلة عن فريق ريال مدريد',
    questions: [
      Question(
        questionText:
            'في أي موسم فاز ريال مدريد بـ 5 بطولات كبرى في موسم واحد، مع إضافة لقب كأس السوبر الإسباني؟',
        points: 5,
        answer: 'موسم 2017',
      ),
      Question(
        questionText:
            'من هو المدرب الذي فاز بأكبر عدد من بطولات دوري أبطال أوروبا مع ريال مدريد في العصر الحديث؟',
        points: 10,
        answer: 'زين الدين زيدان',
      ),
      Question(
        questionText:
            'ما هو أكبر فوز حققه ريال مدريد في دوري أبطال أوروبا في تاريخه؟',
        points: 20,
        answer: '11-2 ضد كأسود ديور',
      ),
      Question(
        questionText:
            'من هو اللاعب الذي سجل أكثر أهداف في تاريخ ريال مدريد في مباراة واحدة في دوري الأبطال؟',
        points: 40,
        answer: 'كريستيانو رونالدو',
      ),
    ],
  ),
  Category(
    title: 'الدوري المصري',
    description: 'أسئلة عن الدوري المصري',
    questions: [
      Question(
        questionText:
            'من هو اللاعب الذي سجل أكبر عدد من الأهداف في تاريخ الدوري المصري؟',
        points: 40,
        answer: 'حسام حسن',
      ),
      Question(
        questionText:
            'كم مرة فاز الأهلي بالدوري المصري في العشر سنوات الأخيرة؟',
        points: 20,
        answer: '9 مرات',
      ),
      Question(
        questionText:
            'من هو الفريق الذي فاز بالدوري المصري في موسم 2002-2003 بعد صراع شديد مع الأهلي؟',
        points: 10,
        answer: 'الزمالك',
      ),
      Question(
        questionText:
            'في أي عام فاز النادي المصري البورسعيدي ببطولة كأس مصر لأول مرة في تاريخه؟',
        points: 5,
        answer: '1998',
      ),
    ],
  ),
  Category(
    title: 'الدوريات الأوروبية الكبرى',
    description: 'أسئلة عن الدوريات الأوروبية الكبرى',
    questions: [
      Question(
        questionText:
            'أي فريق في الدوري الإسباني حصل على أكبر عدد من النقاط في موسم واحد في تاريخ الليغا؟',
        points: 40,
        answer: 'ريال مدريد موسم 2011-2012',
      ),
      Question(
        questionText:
            'في أي عام تم تطبيق تقنية الفيديو (VAR) لأول مرة في الدوري الإنجليزي الممتاز؟',
        points: 20,
        answer: '2019',
      ),
      Question(
        questionText:
            'من هو اللاعب الذي فاز بجائزة أفضل لاعب في الدوري الإيطالي لثلاث مرات متتالية في أعوام 2010 و2011 و2012؟',
        points: 10,
        answer: 'كريستيانو رونالدو',
      ),
      Question(
        questionText:
            'كم عدد الأهداف التي سجلها كريستيانو رونالدو في موسم 2014-2015 مع ريال مدريد في دوري الأبطال؟',
        points: 5,
        answer: '10 أهداف',
      ),
    ],
  ),
  Category(
    title: 'الدوري الإنجليزي',
    description: 'أسئلة عن الدوري الإنجليزي الممتاز',
    questions: [
      Question(
        questionText:
            'من هو اللاعب الذي سجل أكبر عدد من الأهداف في تاريخ الدوري الإنجليزي؟',
        points: 40,
        answer: 'آلان شيرر',
      ),
      Question(
        questionText: 'أي فريق فاز بالدوري الإنجليزي موسم 2013-2014؟',
        points: 20,
        answer: 'مانشستر سيتي',
      ),
      Question(
        questionText:
            'من هو المدرب الذي فاز بأكبر عدد من بطولات الدوري الإنجليزي؟',
        points: 10,
        answer: 'السير أليكس فيرغسون',
      ),
      Question(
        questionText: 'أي فريق هو الأكثر فوزًا في تاريخ الدوري الإنجليزي؟',
        points: 5,
        answer: 'مانشستر يونايتد',
      ),
    ],
  ),
  Category(
    title: 'المنتخبات الكبرى',
    description: 'أسئلة عن المنتخبات الوطنية الكبيرة',
    questions: [
      Question(
        questionText: 'من هو الهداف التاريخي للمنتخب البرازيل؟',
        points: 40,
        answer: 'بيليه',
      ),
      Question(
        questionText: 'كم مرة فاز منتخب الأرجنتين بكأس العالم؟',
        points: 20,
        answer: '2 مرات',
      ),
      Question(
        questionText: 'من هو المنتخب الذي فاز بكأس الأمم الأوروبية 2016؟',
        points: 10,
        answer: 'البرتغال',
      ),
      Question(
        questionText: 'من هو منتخب الذي فاز بأكبر عدد من بطولات كأس آسيا؟',
        points: 5,
        answer: 'اليابان',
      ),
    ],
  ),
  Category(
    title: 'بطولات كأس العالم',
    description: 'أسئلة عن كأس العالم في كرة القدم',
    questions: [
      Question(
        questionText: 'أي منتخب فاز بكأس العالم 2014؟',
        points: 40,
        answer: 'ألمانيا',
      ),
      Question(
        questionText:
            'من هو اللاعب الذي سجل أكبر عدد من الأهداف في تاريخ كأس العالم؟',
        points: 20,
        answer: 'ميروسلاف كلوزه',
      ),
      Question(
        questionText: 'في أي عام فاز منتخب إيطاليا بكأس العالم في البرازيل؟',
        points: 10,
        answer: '2006',
      ),
      Question(
        questionText: 'أي منتخب فاز بكأس العالم لأول مرة في تاريخه في 1998؟',
        points: 5,
        answer: 'فرنسا',
      ),
    ],
  ),
  Category(
    title: 'تاريخ اللاعبين',
    description: 'أسئلة عن اللاعبين التاريخيين في كرة القدم',
    questions: [
      Question(
        questionText: 'من هو اللاعب الذي فاز بأكبر عدد من الكرات الذهبية؟',
        points: 40,
        answer: 'ميسي',
      ),
      Question(
        questionText:
            'من هو اللاعب الذي سجل أكبر عدد من الأهداف في تاريخ دوري الأبطال؟',
        points: 20,
        answer: 'كريستيانو رونالدو',
      ),
      Question(
        questionText:
            'من هو اللاعب الذي سجل أكبر عدد من الأهداف في نهائيات كأس العالم؟',
        points: 10,
        answer: 'ميروسلاف كلوزه',
      ),
      Question(
        questionText:
            'من هو اللاعب الذي حصل على أكبر عدد من الألقاب مع ريال مدريد؟',
        points: 5,
        answer: 'كريستيانو رونالدو',
      ),
    ],
  ),
  Category(
    title: 'أفضل المدربين في التاريخ',
    description: 'أسئلة عن المدربين الأكثر نجاحًا في كرة القدم',
    questions: [
      Question(
        questionText: 'من هو المدرب الأكثر فوزًا بدوري الأبطال؟',
        points: 40,
        answer: 'كارلو أنشيلوتي',
      ),
      Question(
        questionText:
            'من هو المدرب الذي فاز بأكبر عدد من البطولات مع مانشستر يونايتد؟',
        points: 20,
        answer: 'السير أليكس فيرغسون',
      ),
      Question(
        questionText:
            'من هو المدرب الذي فاز بأكبر عدد من بطولات الدوري الإنجليزي الممتاز؟',
        points: 10,
        answer: 'السير أليكس فيرغسون',
      ),
      Question(
        questionText:
            'من هو المدرب الذي قاد ريال مدريد لتحقيق دوري أبطال أوروبا 2014؟',
        points: 5,
        answer: 'كارلو أنشيلوتي',
      ),
    ],
  ),
  Category(
    title: 'الليغا الإسبانية',
    description: 'أسئلة عن الدوري الإسباني لكرة القدم',
    questions: [
      Question(
        questionText: 'من هو الهداف التاريخي للدوري الإسباني؟',
        points: 40,
        answer: 'كريستيانو رونالدو',
      ),
      Question(
        questionText:
            'من هو النادي الذي فاز بأكبر عدد من بطولات الدوري الإسباني؟',
        points: 20,
        answer: 'ريال مدريد',
      ),
      Question(
        questionText:
            'أي نادي في الدوري الإسباني حصل على أكبر عدد من النقاط في موسم واحد؟',
        points: 10,
        answer: 'ريال مدريد',
      ),
      Question(
        questionText:
            'من هو المدرب الذي فاز بأكبر عدد من بطولات الدوري الإسباني؟',
        points: 5,
        answer: 'بيب جوارديولا',
      ),
    ],
  ),
];
