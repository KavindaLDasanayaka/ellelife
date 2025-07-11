enum Mood { happy, sad, angry, excited, bored }

//Mood exension
extension MoodExtension on Mood {
  String get name {
    switch (this) {
      case Mood.happy:
        return "Happy";

      case Mood.sad:
        return "Sad";

      case Mood.angry:
        return "Angry";

      case Mood.bored:
        return "Bored";

      case Mood.excited:
        return "Excited";

      default:
        return "";
    }
  }

  // Get the emoji of the mood
  String get emoji {
    switch (this) {
      case Mood.happy:
        return '😊'; // Happy emoji
      case Mood.sad:
        return '😢'; // Sad emoji
      case Mood.angry:
        return '😡'; // Angry emoji
      case Mood.excited:
        return '🤩'; // Excited emoji
      case Mood.bored:
        return '😴'; // Bored emoji
      default:
        return '';
    }
  }

  static Mood fromString(String moodString) {
    return Mood.values.firstWhere(
      (mood) => mood.name == moodString,
      orElse: () => Mood.happy,
    );
  }
}
