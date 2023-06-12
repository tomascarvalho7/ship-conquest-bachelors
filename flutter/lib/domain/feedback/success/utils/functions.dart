import '../success_feedback.dart';

///
/// File containing the defined types of Successful Feedback that
/// contain variables.
///
SuccessFeedback fightResult(bool won) => switch(won) {
  true => const SuccessFeedback(title: 'Fight Won', details: 'Your ship has defeated your opponent.'),
  false => const SuccessFeedback(title: 'Fight Lost', details: 'Your ship has been defeated by your opponent.')
};