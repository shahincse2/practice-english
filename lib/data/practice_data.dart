import '../models/practice_question.dart';
import '../models/practice_type.dart';

const practiceQuestions = <PracticeQuestion>[
  PracticeQuestion(type: PracticeType.word, answer: 'apple'),
  PracticeQuestion(type: PracticeType.word, answer: 'book'),
  PracticeQuestion(type: PracticeType.word, answer: 'water'),
  PracticeQuestion(type: PracticeType.twoWords, answer: 'big cat'),
  PracticeQuestion(type: PracticeType.twoWords, answer: 'red ball'),
  PracticeQuestion(type: PracticeType.twoWords, answer: 'good boy'),
  PracticeQuestion(type: PracticeType.sentence, answer: 'I like cats'),
  PracticeQuestion(type: PracticeType.sentence, answer: 'This is a book'),
  PracticeQuestion(type: PracticeType.sentence, answer: 'I am happy'),
  PracticeQuestion(type: PracticeType.sentence, answer: 'She has a pen'),
];
