List<int> dobToAge(DateTime dob){
  DateTime now = DateTime.now();
  return [now.day - dob.day, now.month - dob.month, now.year - dob.year];
}