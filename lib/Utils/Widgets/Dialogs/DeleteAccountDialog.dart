import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_music_app/Controller/BaseController.dart';
import 'package:new_music_app/Utils/ChopperClientService/AuthChopperService.dart';
import 'package:new_music_app/Utils/Constants/CustomSnackBar.dart';
import 'package:new_music_app/Utils/Models/GeneralErrorModel.dart';
import 'package:new_music_app/Utils/Network/AppChopperClient.dart';
import 'package:new_music_app/Utils/Router/RouteName.dart';
import 'package:new_music_app/Utils/SharedPreferences/shared_preferences.dart';
import 'package:new_music_app/Utils/Styling/AppColors.dart';
import 'package:new_music_app/Utils/Widgets/AppButtonWidget.dart';
import 'package:new_music_app/Utils/Widgets/AppTextWidget.dart';

/// Asks for the account password and permanently deletes the logged-in account.
class DeleteAccountDialog extends StatefulWidget {
  const DeleteAccountDialog({super.key});

  @override
  State<DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<DeleteAccountDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _deleteAccount() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _loading = true);
    try {
      final response = await AppChopperClient()
          .getChopperService<AuthChopperService>()
          .deleteAccountApi(param: {"password": _passwordController.text});
      if (response.body?.success == true) {
        await UserPreference.clear();
        Get.find<BaseController>().imageUrl.value = '';
        Get.back();
        Get.offAllNamed(RoutesName.loginScreen);
        Utility.showSnackBar(
            response.body?.message ?? 'Your account has been deleted.');
      } else {
        Utility.showSnackBar(
            response.body?.message ??
                (response.error as GeneralErrorModel?)?.message ??
                'Could not delete your account. Please try again.',
            isError: true);
      }
    } catch (e) {
      Utility.showSnackBar(
          'Could not delete your account. Please try again.',
          isError: true);
    }
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
      backgroundColor: AppColors.black,
      title: const AppTextWidget(
        txtTitle: 'Delete Account',
        fontSize: 18,
        fontWeight: FontWeight.w700,
        txtColor: AppColors.white,
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AppTextWidget(
              txtTitle:
                  'This permanently deletes your account, playlists and favorites. This cannot be undone.\n\nEnter your password to confirm.',
              fontSize: 14,
              maxLine: 6,
              txtColor: AppColors.white,
            ),
            10.verticalSpace,
            Material(
              color: AppColors.transparent,
              child: TextFormField(
                controller: _passwordController,
                obscureText: true,
                style: TextStyle(color: AppColors.white, fontSize: 16.sp),
                decoration: InputDecoration(
                  hintText: 'Password',
                  hintStyle: TextStyle(
                      color: AppColors.darkgrey, fontSize: 16.sp),
                  enabledBorder: const UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: AppColors.textFormFieldTextColor)),
                  focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.appButton)),
                ),
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Please enter your password'
                    : null,
              ),
            ),
          ],
        ),
      ),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [
        AppButtonWidget(
          width: 110.w,
          btnColor: AppColors.textFormFieldTextColor,
          btnName: 'Cancel',
          isEnable: !_loading,
          onPressed: () => Get.back(),
        ),
        AppButtonWidget(
          width: 110.w,
          btnColor: AppColors.error,
          btnName: _loading ? 'Deleting...' : 'Delete',
          isEnable: !_loading,
          onPressed: _deleteAccount,
        ),
      ],
    );
  }
}
