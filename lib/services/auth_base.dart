import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_fundraising_goal_chart/models/user_model.dart';

abstract class AuthBase{
Future<UserModel?> createWithInEmailAndPassword(String email, String password);
Future<UserModel?>signInWithEmailAndPassword(String email, String password);
Future<bool?>signOutWithEmailAndPassword(String userID);
Future<bool?>sendPasswordResetEmail(String email);
Future<User?>checkCurrentUser();
Future<bool?>updatePassword(String newPassword);


}