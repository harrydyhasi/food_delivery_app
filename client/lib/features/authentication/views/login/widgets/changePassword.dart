import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/data/authentication/auth_repository.dart';
import 'package:food_delivery_h2d/data/response/status.dart';
import 'package:food_delivery_h2d/features/authentication/controllers/login_controller.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:food_delivery_h2d/utils/popups/loaders.dart';
import 'package:food_delivery_h2d/utils/validations/validators.dart';
import 'package:get/get.dart';

class ChangingPassword extends StatelessWidget {
  const ChangingPassword({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: const Icon(
          Icons.edit,
          size: MySizes.iconMd,
        ),
        onPressed: () {
          final oldPasswordController = TextEditingController();
          final newPasswordController = TextEditingController();
          final confirmPasswordController = TextEditingController();
          GlobalKey<FormState> passWordFormKey = GlobalKey<FormState>();
          // Show dialog for changing password
          Get.defaultDialog(
              contentPadding: const EdgeInsets.all(MySizes.md),
              title: "Thay đổi mật khẩu",
              content: Form(
                  key: passWordFormKey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (value) =>
                            Validators.validateEmptyText("Mật khẩu cũ", value),
                        controller: oldPasswordController,
                        decoration:
                            const InputDecoration(hintText: "Nhập mật khẩu cũ"),
                      ),
                      const SizedBox(
                        height: MySizes.spaceBtwInputFields,
                      ),
                      TextFormField(
                        validator: (value) =>
                            Validators.validateEmptyText("Mật khẩu mới", value),
                        controller: newPasswordController,
                        decoration: const InputDecoration(
                            hintText: "Nhập mật khẩu mới"),
                      ),
                      const SizedBox(
                        height: MySizes.spaceBtwInputFields,
                      ),
                      TextFormField(
                        validator: (value) => Validators.validateEmptyText(
                            "Xác nhận mật khẩu", value),
                        controller: confirmPasswordController,
                        decoration: const InputDecoration(
                            hintText: "Xác nhận mật khẩu"),
                      ),
                    ],
                  )),
              confirm: ElevatedButton(
                  onPressed: () async {
                    try {
                      // handle changing password
                      if (!passWordFormKey.currentState!.validate()) {
                        return;
                      }

                      if (newPasswordController.text !=
                          confirmPasswordController.text) {
                        Loaders.errorSnackBar(
                            title: "Mật khẩu không trùng khớp!");
                        return;
                      }
                      final res = await AuthRepository.instance.changePassword(
                          LoginController.instance.currentUser.userId,
                          oldPasswordController.text,
                          newPasswordController.text);

                      if (res.status == Status.ERROR) {
                        Loaders.errorSnackBar(
                            title: "Lỗi", message: res.message);
                        return;
                      }
                      Loaders.successSnackBar(title: res.message);
                      Navigator.of(Get.overlayContext!).pop();
                    } catch (err) {
                      Loaders.successSnackBar(
                          title: "Thất bại!", message: "Từ chối");
                    }
                  },
                  child: const Text("Cập nhật")),
              cancel: OutlinedButton(
                  onPressed: () => Navigator.of(Get.overlayContext!).pop(),
                  child: const Text("Hủy")));
        });
  }
}
