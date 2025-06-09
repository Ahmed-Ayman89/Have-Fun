import '../utils/App_assets.dart';

final List<MovieModel> moviesAndSeries = [
  MovieModel(
      title: 'الفيل الأزرق',
      description: 'فيلم غموض وتشويق عن الطبيب يحيى راشد.',
      year: 2014,
      type: 'فيلم',
      image: AppAssets.elephantBlue),
  MovieModel(
      title: 'كيرة والجن',
      description: 'فيلم تاريخي عن المقاومة المصرية ضد الاحتلال.',
      year: 2022,
      type: 'فيلم',
      image: AppAssets.kiraAndGen),
  MovieModel(
      title: 'الاختيار',
      description: 'مسلسل وطني يوثق بطولات الجيش المصري.',
      year: 2020,
      type: 'مسلسل',
      image: AppAssets.elkhtyar),
  MovieModel(
      title: 'جزيرة غمام',
      description: 'دراما اجتماعية في إطار صعيدي.',
      year: 2023,
      type: 'مسلسل',
      image: AppAssets.geziretGhamam),
  MovieModel(
      title: 'تراب الماس',
      description: 'فيلم إثارة وغموض مستوحى من رواية.',
      year: 2018,
      type: 'فيلم',
      image: AppAssets.trabElmas),
  MovieModel(
      title: 'ب 100 وش',
      description: 'مسلسل كوميدي عن عمليات نصب بطريقة طريفة.',
      year: 2020,
      type: 'مسلسل',
      image: AppAssets.b100Wesh),
  MovieModel(
      title: 'العار',
      description: 'مسلسل كلاسيكي عن صراعات الأخوة بعد وفاة والدهم.',
      year: 1982,
      type: 'مسلسل',
      image: AppAssets.elaar),
  MovieModel(
      title: 'عمارة يعقوبيان',
      description: 'فيلم درامي يتناول قضايا اجتماعية وسياسية في مصر.',
      year: 2006,
      type: 'فيلم',
      image: AppAssets.omaraYacoubian),
  MovieModel(
      title: 'ما وراء الطبيعة',
      description: 'مسلسل مستوحى من سلسلة روايات أحمد خالد توفيق.',
      year: 2020,
      type: 'مسلسل',
      image: AppAssets.maWaraAltabea),
  MovieModel(
      title: 'الحريف',
      description: 'فيلم درامي عن لاعب كرة موهوب يبحث عن ذاته.',
      year: 1984,
      type: 'فيلم',
      image: AppAssets.elharef),
  MovieModel(
      title: 'نيران صديقة',
      description: 'مسلسل غموض وتشويق عن أصدقاء تواجههم أسرار الماضي.',
      year: 2013,
      type: 'مسلسل',
      image: AppAssets.niranSadiqa),
  MovieModel(
      title: 'اللمبي',
      description: 'فيلم كوميدي عن شخصية اللمبي الطريفة.',
      year: 2002,
      type: 'فيلم',
      image: AppAssets.ellemby),
  MovieModel(
      title: 'ذات',
      description: 'مسلسل يحكي قصة حياة امرأة مصرية خلال حقب زمنية مختلفة.',
      year: 2013,
      type: 'مسلسل',
      image: AppAssets.that),
  MovieModel(
      title: 'صعيدي في الجامعة الأمريكية',
      description: 'فيلم كوميدي عن طالب صعيدي يتأقلم مع الحياة الجامعية.',
      year: 1998,
      type: 'فيلم',
      image: AppAssets.saidiAm),
  MovieModel(
      title: 'يوميات ونيس',
      description: 'مسلسل عائلي يناقش الحياة اليومية بأسلوب فكاهي.',
      year: 1994,
      type: 'مسلسل',
      image: AppAssets.yomiyatWanees),
  MovieModel(
      title: 'البريء',
      description: 'فيلم درامي سياسي عن الجنود والسلطة.',
      year: 1986,
      type: 'فيلم',
      image: AppAssets.elbaree),
  MovieModel(
      title: 'قصر النيل',
      description: 'مسلسل درامي مليء بالغموض والإثارة.',
      year: 2021,
      type: 'مسلسل',
      image: AppAssets.qasrElneil),
  MovieModel(
      title: 'غبي منه فيه',
      description: 'فيلم كوميدي حول مغامرات رجل ساذج.',
      year: 2004,
      type: 'فيلم',
      image: AppAssets.ghabyMenFeh),
  MovieModel(
      title: 'ربع رومي',
      description: 'مسلسل كوميدي عن عائلة تواجه مواقف طريفة.',
      year: 2018,
      type: 'مسلسل',
      image: AppAssets.robRommy),
  MovieModel(
      title: 'احكي يا شهرزاد',
      description: 'فيلم درامي يعرض قضايا المرأة والمجتمع.',
      year: 2009,
      type: 'فيلم',
      image: AppAssets.ehkyYaShahrazad),
];

class MovieModel {
  final String title;
  final String description;
  final int year;
  final String type;
  final String image;

  MovieModel({
    required this.title,
    required this.description,
    required this.year,
    required this.type,
    required this.image,
  });

  factory MovieModel.fromMap(Map<String, dynamic> map) {
    return MovieModel(
      title: map['title'] as String,
      description: map['description'] as String,
      year: map['year'] as int,
      type: map['type'] as String,
      image: map['image'] as String,
    );
  }
}
