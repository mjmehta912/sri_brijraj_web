import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sri_brijraj_web/constants/color_constants.dart';
import 'package:sri_brijraj_web/features/login/controllers/login_controller.dart';
import 'package:sri_brijraj_web/styles/textstyles.dart';
import 'package:sri_brijraj_web/widgets/app_button.dart';
import 'package:sri_brijraj_web/widgets/app_loading_overlay.dart';
import 'package:sri_brijraj_web/widgets/app_paddings.dart';
import 'package:sri_brijraj_web/widgets/app_size_extensions.dart';
import 'package:sri_brijraj_web/widgets/app_spacings.dart';
import 'package:sri_brijraj_web/widgets/app_text_form_field.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({
    super.key,
  });

  final LoginController _controller = Get.put(
    LoginController(),
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
                        SizedBox(
                          width: 0.4.screenWidth,
                          child: AppTextFormField(
                            controller: _controller.mobileNumberController,
                            hintText: 'Mobile Number / Username',
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a valid username';
                              }
                              return null;
                            },
                          ),
                        ),
                        AppSpaces.v30,
                        Obx(
                          () => SizedBox(
                            width: 0.4.screenWidth,
                            child: AppTextFormField(
                              controller: _controller.passwordController,
                              hintText: 'Password',
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter a valid password';
                                }
                                return null;
                              },
                              isObscure: _controller.obscuredText.value,
                              suffixIcon: IconButton(
                                onPressed: () {
                                  _controller.togglePasswordVisibility();
                                },
                                icon: Icon(
                                  _controller.obscuredText.value
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
                          buttonWidth: 0.4.screenWidth,
                          title: 'Login',
                          onPressed: () async {
                            _controller.hasAttemptedLogin.value = true;
                            if (_controller.formKey.currentState!.validate()) {
                              FocusManager.instance.primaryFocus?.unfocus();
                              await _controller.login();
                            }
                          },
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
