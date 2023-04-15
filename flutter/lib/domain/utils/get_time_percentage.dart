double getTimePercentage(DateTime startTime, DateTime endTime) {
  // Calculate the duration of the time interval in seconds
  int durationInSeconds = (endTime.difference(startTime)).inSeconds;
  // Calculate the number of seconds that have passed since the start time
  int secondsPassed = (DateTime.now().difference(startTime)).inSeconds;
  // Calculate the percentage of time that has passed
  double percentage = (secondsPassed / durationInSeconds);
  // Ensure that the percentage is within the range of 0 to 1
  if (percentage < 0) {
    percentage = 0;
  } else if (percentage > 1) {
    percentage = 1;
  }

  return percentage;
}