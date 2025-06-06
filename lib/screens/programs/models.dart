class Program {
  final int id;
  final String name;
  final int durationYears;
  final int institutionId;

  Program({
    required this.id,
    required this.name,
    required this.durationYears,
    required this.institutionId,
  });

  factory Program.fromJson(Map<String, dynamic> json) {
    return Program(
      id: json['id'],
      name: json['name'],
      durationYears: json['duration_years'],
      institutionId: json['institution'],
    );
  }
}

class Course {
  final int id;
  final String title;
  final int semester;
  final int programId;

  Course({
    required this.id,
    required this.title,
    required this.semester,
    required this.programId,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      title: json['title'],
      semester: json['semester'],
      programId: json['program'],
    );
  }
}

class Institution {
  final int id;
  final String name;
  final String code;
  final String website;

  Institution({
    required this.id,
    required this.name,
    required this.code,
    required this.website,
  });

  factory Institution.fromJson(Map<String, dynamic> json) {
    return Institution(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      website: json['website'],
    );
  }
}

class AcademicUnit {
  final int id;
  final String code;
  final String name;
  final String description;
  final int courseId;

  AcademicUnit({
    required this.id,
    required this.code,
    required this.name,
    required this.description,
    required this.courseId,
  });

  factory AcademicUnit.fromJson(Map<String, dynamic> json) {
    return AcademicUnit(
      id: json['id'],
      code: json['code'],
      name: json['name'],
      description: json['description'],
      courseId: json['course'],
    );
  }
}

