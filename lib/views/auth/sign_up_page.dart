import 'package:flutter/material.dart';
import 'package:ground_break/components/components.dart';
import 'package:ground_break/constants/constants.dart';
import 'package:ground_break/l10n/app_localizations.dart';
import 'package:ground_break/models/models.dart';
import 'package:ground_break/services/services.dart';
import 'package:ground_break/utils/utils.dart';
import 'package:ground_break/views/pages.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  static Route route() => AppUIUtils.fadeTransitionBuilder(const SignUpPage());

  @override
  State<StatefulWidget> createState() {
    return _SignUpPageState();
  }
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _organizationController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _loading = false, _obscureText = true;
  String? _errorMessage;
  double? _width, _height;

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _loading = true;
      });
      String? error = await AuthenticationService().signUpWithEmail(
        profile: UserProfileModel(
          uid: '',
          email: _emailController.text,
          displayName: _fullNameController.text,
          organization: _organizationController.text,
        ),
        password: _passwordController.text,
      );
      setState(() {
        _loading = false;
      });
      if (mounted) {
        if (error == null) {
          Navigator.of(context).pushAndRemoveUntil(
            RecordingPage.route(),
            (route) => route.isFirst,
          );
        } else {
          setState(() {
            _errorMessage = error;
          });
        }
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _loading = true;
    });
    String? error = await AuthenticationService().signInWithGoogle();
    setState(() {
      _loading = false;
    });
    if (mounted) {
      if (error == null) {
        Navigator.of(context).pushAndRemoveUntil(
          RecordingPage.route(),
          (route) => route.isFirst,
        );
      } else {
        setState(() {
          _errorMessage = error;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.yellowGreen,
            AppColors.lightYellow,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: AppColors.transparent,
        appBar: const AppLogoBar(),
        body: LayoutBuilder(
          builder: (context, constraints) {
            _width ??= constraints.maxWidth;
            _height ??= constraints.maxHeight;
            return SingleChildScrollView(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                child: Container(
                  width: _width,
                  height: _height,
                  margin: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 36),
                          child: Text(
                            AppLocalizations.of(context)!.startSelling,
                            style: AppFontStyles.k50BoldTextStyle.copyWith(
                              color: AppColors.black,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(36, 24, 36, 0),
                          child: Text(
                            AppLocalizations.of(context)!
                                .startSellingDescription,
                            style: AppFontStyles.k16TextStyle.copyWith(
                              color: AppColors.black,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 24,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: AppBorders.roundedBorder30TopOnly,
                            color: AppColors.black,
                          ),
                          child: SafeArea(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 24,
                                  ),
                                  child: Text(
                                    AppLocalizations.of(context)!.createAccount,
                                    style:
                                        AppFontStyles.k20BoldTextStyle.copyWith(
                                      color: AppColors.white,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  child: AppTextFormField(
                                    controller: _fullNameController,
                                    hintText:
                                        AppLocalizations.of(context)!.fullName,
                                    style: AppFontStyles.k16TextStyle.copyWith(
                                      color: AppColors.white,
                                    ),
                                    validator: Validator.validateString,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  child: AppTextFormField(
                                    controller: _emailController,
                                    hintText: AppLocalizations.of(context)!
                                        .emailAddress,
                                    textCapitalization: TextCapitalization.none,
                                    keyboardType: TextInputType.emailAddress,
                                    style: AppFontStyles.k16TextStyle.copyWith(
                                      color: AppColors.white,
                                    ),
                                    validator: Validator.validateEmailAddress,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  child: AppTextFormField(
                                    controller: _organizationController,
                                    hintText: AppLocalizations.of(context)!
                                        .organization,
                                    style: AppFontStyles.k16TextStyle.copyWith(
                                      color: AppColors.white,
                                    ),
                                    validator: Validator.validateString,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  child: AppTextFormField(
                                    controller: _passwordController,
                                    hintText: AppLocalizations.of(context)!
                                        .createPassword,
                                    textCapitalization: TextCapitalization.none,
                                    obscureText: _obscureText,
                                    style: AppFontStyles.k16TextStyle.copyWith(
                                      color: AppColors.white,
                                    ),
                                    validator: Validator.validateString,
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        !_obscureText
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscureText = !_obscureText;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 30,
                                  ),
                                  child: AppRoundedRectangleButton(
                                    buttonType: AppButtonType.green,
                                    text: AppLocalizations.of(context)!
                                        .getStarted,
                                    loading: _loading,
                                    onTap: _signUp,
                                  ),
                                ),
                                if (_errorMessage != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 14),
                                    child: Text(
                                      _errorMessage!,
                                      textAlign: TextAlign.center,
                                      style:
                                          AppFontStyles.k14TextStyle.copyWith(
                                        color: AppColors.red,
                                      ),
                                    ),
                                  ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 30,
                                    bottom: 14,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          height: 1,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                AppColors.black,
                                                AppColors.yellowGreen
                                                    .withOpacity(0.5),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                        ),
                                        child: Text(
                                          AppLocalizations.of(context)!.orText,
                                          style: AppFontStyles.k12TextStyle
                                              .copyWith(
                                            color: AppColors.white
                                                .withOpacity(0.75),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          height: 1,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                AppColors.yellowGreen
                                                    .withOpacity(0.5),
                                                AppColors.black,
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: _signInWithGoogle,
                                  child: Container(
                                    height: 42,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: AppBorders.roundedBorder5,
                                      border: Border.all(
                                        color: AppColors.white.withOpacity(0.5),
                                      ),
                                    ),
                                    child: Image.asset(
                                      ImageAssets.googlePng,
                                      width: 22,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
              ),
            );
          },
        ),
      ),
    );
  }
}
