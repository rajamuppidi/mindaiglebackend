import 'package:get/get.dart';
import 'package:mindaigle/features/profile/controllers/profile_controller.dart';

class DashboardController extends GetxController {
  final ProfileController _profileController = Get.find<ProfileController>();

  RxString userName = ''.obs;
  RxString userPhotoUrl = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    await _profileController.fetchUserData();
    userName.value = _profileController.fullName ?? 'User';
    userPhotoUrl.value = _profileController.photoURL ?? '';
  }
}
