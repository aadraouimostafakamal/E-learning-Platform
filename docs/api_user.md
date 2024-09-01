# User API Documentation

## Table of Contents
- [User Signup](#user-signup)
- [User Signin](#user-signin)
- [Password Recovery](#password-recovery)
- [Password Reset](#password-reset)
- [User Logout](#user-logout)
- [Get All Users](#get-all-users)
- [Get User by ID](#get-user-by-id)
- [Update User](#update-user)
- [Delete User](#delete-user)
- [Verify User Credentials](#verify-user-credentials)

---

### User Signup

- **Endpoint**: `/signup`
- **Method**: `POST`
- **Description**: This route is used to sign up a new user.
- **Request Body**:
  ```json
  {
    "login": "user_login",
    "email": "user@example.com",
    "passwd": "password",
    "adresse": "123 Main St",
    "pays": "Country",
    "age": 25,
    "sexe": "M",
    "photo": "base64_photo_string"
  }
  ```
- **Response**:
  - `201 OK`: Signup successful. The user is prompted to verify their email.
  - `429 Too Many Requests`: Email rate limit exceeded.
  - `400 Bad Request`: Error occurred during signup.

### User Signin

- **Endpoint**: `/signin`
- **Method**: `POST`
- **Description**: This route is used to sign in a user.
- **Request Body**:
  ```json
  {
    "email": "user@example.com",
    "password": "password"
  }
  ```
- **Response**:
  - `200 OK`: Signin successful, returns user data and session information.
  - `400 Bad Request`: Invalid login credentials.

### Password Recovery

- **Endpoint**: `/recover`
- **Method**: `POST`
- **Description**: This route is used to initiate the password recovery process. It sends a password recovery email to the user.
- **Request Body**:
  ```json
  {
    "email": "user@example.com"
  }
  ```
- **Response**:
  - `200 OK`: Password recovery email sent.
  - `400 Bad Request`: Error occurred during password recovery.

### Password Reset

- **Endpoint**: `/reset_password`
- **Method**: `POST`
- **Description**: This route is used to reset a user's password after they have received a recovery email.
- **Request Body**:
  ```json
  {
    "email": "user@example.com",
    "access_token": "access_token_from_email",
    "new_password": "new_password"
  }
  ```
- **Response**:
  - `200 OK`: Password has been reset successfully.
  - `400 Bad Request`: Invalid or expired token, or failed to update password.

### User Logout

- **Endpoint**: `/logout`
- **Method**: `POST`
- **Description**: This route is used to log out a user.
- **Request Header**: Requires JWT token in the `Authorization` header.
- **Response**:
  - `200 OK`: User signed out successfully.
  - `400 Bad Request`: Error occurred during logout.

### Get All Users

- **Endpoint**: `/users_list`
- **Method**: `GET`
- **Description**: This route is used to retrieve a list of all users.
- **Response**:
  - `200 OK`: Returns a list of all users.
  - `500 Internal Server Error`: Error occurred while fetching users.

### Get User by ID

- **Endpoint**: `/user/:id`
- **Method**: `GET`
- **Description**: This route is used to retrieve a user by their ID.
- **Request Parameter**: `id` - The ID of the user.
- **Response**:
  - `200 OK`: Returns the user data.
  - `404 Not Found`: User not found.
  - `500 Internal Server Error`: Error occurred while fetching user data.

### Update User

- **Endpoint**: `/update_user/:id`
- **Method**: `PUT`
- **Description**: This route is used to update a user's information.
- **Request Header**: Requires JWT token in the `Authorization` header.
- **Request Parameter**: `id` - The ID of the user to update.
- **Request Body**:
  ```json
  {
    "login": "new_login",
    "passwd": "new_password",
    "adresse": "new_address",
    "pays": "new_country",
    "age": 30,
    "sexe": "F",
    "photo": "new_base64_photo_string"
  }
  ```
- **Response**:
  - `200 OK`: User updated successfully.
  - `403 Forbidden`: User is not authorized to update this account.
  - `400 Bad Request`: Invalid input or missing fields.
  - `500 Internal Server Error`: Error occurred during update.

### Delete User

- **Endpoint**: `/delete_user/:id`
- **Method**: `DELETE`
- **Description**: This route is used to delete a user.
- **Request Header**: Requires JWT token in the `Authorization` header.
- **Request Parameter**: `id` - The ID of the user to delete.
- **Response**:
  - `200 OK`: User deleted successfully.
  - `403 Forbidden`: User is not authorized to delete this account.
  - `404 Not Found`: User not found.
  - `500 Internal Server Error`: Error occurred during deletion.

### Verify User Credentials

- **Endpoint**: `/verify_user`
- **Method**: `POST`
- **Description**: This route is used to verify a user's credentials (login and password).
- **Request Body**:
  ```json
  {
    "login": "user_login",
    "passwd": "password"
  }
  ```
- **Response**:
  - `200 OK`: Returns user data without the password.
  - `400 Bad Request`: Missing login or password.
  - `401 Unauthorized`: Authentication failed.
