import '../models/practice_level.dart';
import '../models/practice_segment.dart';

class PracticeCatalog {
  static const Map<PracticeSegment, List<PracticeLevel>> levels = {
    PracticeSegment.kids: [
      PracticeLevel.nursery,
      PracticeLevel.kg,
      PracticeLevel.class1,
      PracticeLevel.class2,
      PracticeLevel.class3,
      PracticeLevel.class4,
      PracticeLevel.class5,
    ],
    PracticeSegment.school: [
      PracticeLevel.class6,
      PracticeLevel.class7,
      PracticeLevel.class8,
      PracticeLevel.class9,
      PracticeLevel.class10,
    ],
    PracticeSegment.academic: [PracticeLevel.hsc, PracticeLevel.university],
    PracticeSegment.ielts: [PracticeLevel.ielts],
    PracticeSegment.gre: [PracticeLevel.gre],
    PracticeSegment.spokenEnglish: [PracticeLevel.spokenEnglish],
  };

  static String segmentName(PracticeSegment segment) {
    switch (segment) {
      case PracticeSegment.kids:
        return 'Kids';
      case PracticeSegment.school:
        return 'School';
      case PracticeSegment.academic:
        return 'Academic';
      case PracticeSegment.ielts:
        return 'IELTS';
      case PracticeSegment.gre:
        return 'GRE';
      case PracticeSegment.spokenEnglish:
        return 'Spoken English';
    }
  }

  static String levelName(PracticeLevel level) {
    switch (level) {
      case PracticeLevel.nursery:
        return 'Nursery';
      case PracticeLevel.kg:
        return 'KG';
      case PracticeLevel.class1:
        return 'Class 1';
      case PracticeLevel.class2:
        return 'Class 2';
      case PracticeLevel.class3:
        return 'Class 3';
      case PracticeLevel.class4:
        return 'Class 4';
      case PracticeLevel.class5:
        return 'Class 5';
      case PracticeLevel.class6:
        return 'Class 6';
      case PracticeLevel.class7:
        return 'Class 7';
      case PracticeLevel.class8:
        return 'Class 8';
      case PracticeLevel.class9:
        return 'Class 9';
      case PracticeLevel.class10:
        return 'Class 10';
      case PracticeLevel.hsc:
        return 'HSC';
      case PracticeLevel.university:
        return 'University';
      case PracticeLevel.ielts:
        return 'IELTS';
      case PracticeLevel.gre:
        return 'GRE';
      case PracticeLevel.spokenEnglish:
        return 'Spoken English';
    }
  }
}
