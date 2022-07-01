class SurveyData{
  String name;
  String recentApp;
  String moodBefore;
  String moodAfter;

  SurveyData(
  this.name,
  this.recentApp,
  this.moodBefore,
  this.moodAfter,
  );

  Map<String,dynamic> toJson() => {
    'name': name,
    'recentApp' : recentApp,
    'moodBefore' : moodBefore,
    'moodAfter' : moodAfter
  };
}

