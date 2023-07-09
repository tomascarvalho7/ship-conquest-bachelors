import 'package:ship_conquest/domain/feedback/success/success_feedback.dart';

///
/// File containing the constant defined types of Successful Feedback
/// constant variables of type [SuccessFeedback]
///
const travelling = SuccessFeedback(
    title: "Travelling...",
    details: "Your ship will soon reach it's destiny."
);

const fighting = SuccessFeedback(
    title: "Fighting!",
    details: "Your ship has entered a battle with an opponent."
);

const islandFound = SuccessFeedback(
    title: "Island found!",
    details: "Your journey led to a newly discovered island."
);