## POST /contact

### Description
This endpoint allows users to submit a contact form. The form data is validated, stored in the database, and an email notification is sent to the enterprise.

### Request
- **Method**: POST
- **URL**: `/contact`
- **Headers**: 
  - `Content-Type: application/json`
- **Body**:
  ```json
  {
    "name": "string",
    "email": "string",
    "subject": "string",
    "message": "string"
  }
  ```

### Response
- **Success**: 
  - **Status**: 200 OK
  - **Body**:
    ```json
    {
      "message": "Message sent successfully"
    }
    ```
- **Error**:
  - **Status**: 400 Bad Request
  - **Body**:
    ```json
    {
      "error": "All fields are required"
    }
    ```
  - **Status**: 500 Internal Server Error
  - **Body**:
    ```json
    {
      "error": "Error processing contact form"
    }
    ```

### Example
#### Request
```bash
curl -X POST http://localhost:3000/contact \
-H "Content-Type: application/json" \
-d '{
  "name": "John Doe",
  "email": "john.doe@example.com",
  "subject": "Inquiry",
  "message": "I would like to know more about your services."
}'
```

#### Response
```json
{
  "message": "Message sent successfully"
}
```

### Notes
- Ensure that the environment variables `ENTERPRISE_EMAIL` and `ENTERPRISE_EMAIL_PASSWORD` are set correctly for the email notification to work.
- The `supabase` client should be properly configured to interact with your database.

