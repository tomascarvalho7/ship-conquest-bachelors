class EventModel {
  final String id;
  final String event;
  final String data;

  EventModel({required this.id, required this.event, required this.data});

  static EventModel? fromTextStream(String stream) {
    // Extract the event data
    RegExp eventRegex = RegExp(r'"data":(.*)', dotAll: true);
    RegExp idRegex = RegExp(r'id:(:*)');
    RegExp eventFieldRegex = RegExp(r'event:(\w+)');
    RegExp dataRegex = RegExp(r'"data":(.*)');
    Match? eventMatch = eventRegex.firstMatch(stream);
    if (eventMatch != null) {
      String eventData = eventMatch.group(1)!.trim();

      // Extract the id, event, and data fields
      Match? idMatch = idRegex.firstMatch(eventData);
      Match? eventFieldMatch = eventFieldRegex.firstMatch(eventData);
      Match? dataMatch = dataRegex.firstMatch(eventData);

      if (idMatch != null && eventFieldMatch != null && dataMatch != null) {
        String eventId = idMatch.group(1)!;
        String eventName = eventFieldMatch.group(1)!;
        String data = dataMatch.group(1)!;
        String trim = data.substring(
            0, data.indexOf(RegExp(r',"mediaType":(.*)')));

        return EventModel(id: eventId, event: eventName, data: trim);
      }
      return null;
    }
  }
}