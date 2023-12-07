class Task {

  int Id;
  String Title;
  String Description;
  String CreationDate;
  bool IsCompleted;
  bool IsDeleted;
  String StartTime;
  String EndTime;
  int Duration;
  String Color;
  bool IsTracking;

  Task({this.Id, this.Title, this.Description, this.CreationDate, this.IsCompleted, this.IsDeleted, this.StartTime, this.EndTime, this.Duration, this.Color, this.IsTracking});

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
        Id : json["id"],
        Title : json["title"],
        Description : json["description"],
        CreationDate : json["creationDate"],
        IsCompleted : json["isCompleted"] == 0 ? false:true,
        IsDeleted : json["isDeleted"] == 0 ? false:true,
        StartTime : json["startTime"],
        EndTime : json["endTime"],
        Duration : json["duration"],
        Color : json["color"],
        IsTracking: json['isTracking'] == 0 ? false:true,
      );
  }

  Map<String, dynamic> toMap() => {
    "id": Id,
    "title": Title,
    "description": Description,
    "creationDate": CreationDate,
    "isCompleted": IsCompleted,
    "isDeleted" : IsDeleted,
    "startTime" : StartTime,
    "endTime" : EndTime,
    "duration" : Duration,
    "color" : Color,
    "isTracking" : IsTracking,
  };

  factory Task.fromJsonTest(Map<String, dynamic> json) {
    return Task(
      Id : json["id"],
      Title : json["title"]
    );
  }
}
