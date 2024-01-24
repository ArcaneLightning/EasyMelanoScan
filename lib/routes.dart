import 'package:melanoma_detection/camera_upload/camera_upload.dart';
import 'package:melanoma_detection/center/center.dart';
import 'package:melanoma_detection/home/home.dart';
import 'package:melanoma_detection/login/login.dart';
import 'package:melanoma_detection/storage/storage.dart';

var appRoutes = {
  "/": (context) => const HomeScreen(),
  "/login": (context) => const LoginScreen(),
  "/center": (context) => const CenterScreen(),
  "/upload": (context) => const UploadScreen(),
  "/storage": (context) => const StorageScreen(),
};