# Forget Password Feature

## Overview
The forget password feature allows users to reset their password by receiving a password reset email from Firebase Authentication.

## Implementation Details

### Architecture
The feature follows the BLoC pattern for state management:

1. **Events** (`user_login_event.dart`):
   - `ForgotPasswordEvent`: Triggered when user requests password reset

2. **States** (`user_login_state.dart`):
   - `ForgotPasswordLoading`: While sending reset email
   - `ForgotPasswordSuccess`: When reset email sent successfully
   - `ForgotPasswordError`: When reset email fails to send

3. **BLoC** (`user_login_bloc.dart`):
   - `_forgotPasswordEvent`: Handles the forget password logic

4. **Repository** (`user_auth_repo_impl.dart`):
   - `resetPassword`: Sends password reset email via Firebase

### User Interface
- **Login Screen**: Contains "Forgot Password? Click here to reset" button
- **Reset Dialog**: Modal dialog with email input field
- **Validation**: Email format validation
- **Feedback**: Success/error messages via SnackBar

### How to Use
1. On the login screen, tap "Forgot Password? Click here to reset"
2. Enter your email address in the dialog
3. Tap "Send Reset Email"
4. Check your email for the password reset link
5. Follow the link to create a new password

### Features
- ✅ Email validation
- ✅ Loading states
- ✅ Success/error feedback
- ✅ Clean UI with proper dialog
- ✅ BLoC pattern implementation
- ✅ Firebase integration

### Error Handling
- Invalid email format validation
- Firebase authentication errors
- Network connectivity issues
- User-friendly error messages

## Files Modified
- `lib/core/auth/presentation/bloc/user_login_event.dart`
- `lib/core/auth/presentation/bloc/user_login_state.dart`
- `lib/core/auth/presentation/bloc/user_login_bloc.dart`
- `lib/core/auth/data/user_auth_repo_impl.dart`
- `lib/core/auth/presentation/login.dart`