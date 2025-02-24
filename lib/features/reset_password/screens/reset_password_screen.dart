import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sri_brijraj_web/constants/color_constants.dart';
import 'package:sri_brijraj_web/features/reset_password/controllers/reset_password_controller.dart';
import 'package:sri_brijraj_web/styles/textstyles.dart';
import 'package:sri_brijraj_web/widgets/app_button.dart';
import 'package:sri_brijraj_web/widgets/app_loading_overlay.dart';
import 'package:sri_brijraj_web/widgets/app_paddings.dart';
import 'package:sri_brijraj_web/widgets/app_size_extensions.dart';
import 'package:sri_brijraj_web/widgets/app_spacings.dart';
import 'package:sri_brijraj_web/widgets/app_text_form_field.dart';

class ResetPasswordScreen extends StatelessWidget {
  ResetPasswordScreen({
    super.key,
    required this.userName,
  });

  final String userName;

  final ResetPasswordController _controller = Get.put(
    ResetPasswordController(),
  );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            backgroundColor: kColorwhite,
            body: Center(
              child: Padding(
                padding: AppPaddings.ph20,
                child: SingleChildScrollView(
                  child: Form(
                    key: _controller.formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'SRI BRIJRAJ',
                          style: TextStyles.kBoldInstrumentSans(
                            fontSize: FontSize.k40FontSize,
                            color: kColorPrimary,
                          ),
                        ),
                        AppSpaces.v50,
                        Obx(
                          () => SizedBox(
                            width: 0.4.screenWidth,
                            child: AppTextFormField(
                              controller: _controller.newPasswordController,
                              hintText: 'New Password',
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter a valid new password';
                                }
                                return null;
                              },
                              isObscure: _controller.obscuredNewPassword.value,
                              suffixIcon: IconButton(
                                onPressed: () {
                                  _controller.toggleNewPasswordVisibility();
                                },
                                icon: Icon(
                                  _controller.obscuredConfirmPassword.value
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                        AppSpaces.v30,
                        Obx(
                          () => SizedBox(
                            width: 0.4.screenWidth,
                            child: AppTextFormField(
                              controller: _controller.confirmPasswordController,
                              hintText: 'Confirm Password',
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please confirm your password';
                                }
                                if (value !=
                                    _controller.newPasswordController.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                              isObscure:
                                  _controller.obscuredConfirmPassword.value,
                              suffixIcon: IconButton(
                                onPressed: () {
                                  _controller.toggleConfirmPasswordVisibility();
                                },
                                icon: Icon(
                                  _controller.obscuredConfirmPassword.value
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                        AppSpaces.v60,
                        AppButton(
                          onPressed: () async {
                            _controller.hasAttemptedSubmit.value = true;
                            if (_controller.formKey.currentState!.validate()) {
                              FocusManager.instance.primaryFocus?.unfocus();
                              _controller.resetPassword(
                                userName: userName,
                              );
                            }
                          },
                          buttonHeight: 50,
                          buttonWidth: 0.4.screenWidth,
                          title: 'Reset Password',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Obx(
          () => CustomLoadingOverlay(
            isLoading: _controller.isLoading.value,
          ),
        ),
      ],
    );
  }
}
