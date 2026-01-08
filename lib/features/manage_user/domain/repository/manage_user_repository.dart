import 'package:studydocs/data/model/user.dart';

abstract class ManageUserRepository {
  Future<List<UserModel>> getListUserPage(int frompage,int topage,int numUser);
  Future<bool> deleteUser(String userID);
  Future<bool> addUser(String userID);
  Future<bool> editUser(UserModel user);
  Future<List<UserModel>> findUserPage(int frompage,int topage,String username);
}