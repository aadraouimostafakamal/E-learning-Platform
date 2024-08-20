# API Documentation - Utilisateur

## Introduction
This document provides an overview of the API endpoints available for managing users in the E-learning Platform. The API allows for user authentication, retrieval, creation, updating, and deletion.

## Authentication
All routes that modify user data require JWT token-based authentication. Users must include a valid JWT token in the `Authorization` header with the format `Bearer <token>`.
### Create a New User
**Endpoint:** `POST /utilisateurs`

**Description:** Creates a new user.

**Request:**
```json
{
  "login": "string",
  "passwd": "string",
  "age": 25,
  "sexe": "M",
  "pays": "Morocco",
  "adresse": "123 Rue Example",
  "photo": "base64_string"
}
```

**Response:**
- **Success (201):** User created successfully.
- **Error (400):** Invalid request body.
- **Error (500):** Server error.

### Login
**Endpoint:** `POST /login`

**Description:** Authenticates a user and returns a JWT token.

**Request:**
```json
{
  "login": "string",
  "passwd": "string"
}
```

**Response:**
- **Success (200):**
  ```json
  {
    "token": "jwt_token_string",
    "status": "success",
    "expiresIn": "1 hour"
  }
  ```
- **Error (400):** Invalid login or password.
- **Error (500):** Server error.

## Endpoints

### 1. Get All Users
**Endpoint:** `GET /utilisateurs`

**Description:** Retrieves a list of all users.

**Response:**
- **Success (200):**
  ```json
  [
    {
      "id": 1,
      "login": "mostafa",
      "age": 25,
      "sexe": "M",
      "pays": "Morocco",
      "adresse": "123 Rue Example",
      "photo": "base64_string"
    },
    ...
  ]
  ```
- **Error (500):** Server error.

### 2. Get User by ID
**Endpoint:** `GET /utilisateurs/:id`

**Description:** Retrieves the details of a specific user by ID.

**Parameters:**
- `id`: The ID of the user to retrieve.

**Response:**
- **Success (200):**
  ```json
  {
    "id": 1,
    "login": "user1",
    "age": 25,
    "sexe": "M",
    "pays": "Morocco",
    "adresse": "123 Rue Example",
    "photo": "base64_string"
  }
  ```
- **Error (404):** User not found.
- **Error (500):** Server error.

### 3. Update User by ID
**Endpoint:** `PUT /utilisateurs/:id`

**Description:** Updates the details of an existing user by ID.

**Parameters:**
- `id`: The ID of the user to update.

**Request:**
```json
{
  "login": "string",
  "passwd": "string",
  "age": 25,
  "sexe": "M",
  "pays": "Morocco",
  "adresse": "123 Rue Example",
  "photo": "base64_string"
}
```

**Response:**
- **Success (200):** User updated successfully.
- **Error (404):** User not found.
- **Error (500):** Server error.

### 4. Delete User by ID
**Endpoint:** `DELETE /utilisateurs/:id`

**Description:** Deletes an existing user by ID. The user must be authenticated and can only delete their own account.

**Parameters:**
- `id`: The ID of the user to delete.

**Response:**
- **Success (200):** 
  ```json
  {
    "message": "L'utilisateur avec l'ID 1 (mostafa) a été supprimé avec succès.",
    "details": {
      "adresse": "123 Rue Example",
      "pays": "Morocco",
      "age": 25,
      "sexe": "M"
    }
  }
  ```
- **Error (403):** Unauthorized to delete this user.
- **Error (404):** User not found.
- **Error (500):** Server error.

## Error Handling
All API responses include a status code that indicates the success or failure of the request. Common status codes used by this API include:
- **200:** OK (Success)
- **201:** Created (Success)
- **400:** Bad Request (Client Error)
- **401:** Unauthorized (Authentication Error)
- **403:** Forbidden (Authorization Error)
- **404:** Not Found (Client Error)
- **500:** Internal Server Error (Server Error)

## Security Considerations
- Passwords are hashed using bcrypt before being stored in the database.
- JWT tokens are used for user authentication, with tokens signed using a secret key stored in the environment variables.
- Ensure that the `ACCESS_TOKEN_SECRET` is kept secure and not exposed in version control.

## Future Improvements
- Implement pagination for the `GET /utilisateurs` endpoint to handle large datasets.
- Add rate limiting to prevent abuse of the login endpoint.
