class UserEndpoints {
  static const String base = 'users/login';

  static const String all = '$base/all';
  static const String count = '$base/count';
  static const String register = '$base/register';
  static const String update = '$base/update';
  static const String updateImage = '$base/updateImage';
  static const String delete = '$base/delete';
  static const String getById = '$base/getUserByID';
  static const String isPrivate = '$base/isPrivate';
  static const String exists = '$base/exists';

  // Document interactions via User service
  static const String documentSave = '$base/document/save';
  static const String documentSaved = '$base/document/saved';

  //admin
  static const String updateUserByAdmin = '$base/update/admin';

}