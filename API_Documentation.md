

### **API Documentation - Cours & Formation Routes**

---

### **1. Cours Routes**

#### **GET `/cours/`**
- **Description**: Retrieve all courses from the database.
- **Method**: `GET`
- **Response**:
  - `200 OK`: Returns an array of all courses.
  - `500 Internal Server Error`: If the server encounters an error.
  
#### **GET `/cours/:id`**
- **Description**: Retrieve a single course by its ID.
- **Parameters**: 
  - `id` (Path Parameter): The ID of the course to be fetched.
- **Method**: `GET`
- **Response**:
  - `200 OK`: Returns the course data.
  - `404 Not Found`: If no course is found with the given ID.
  - `500 Internal Server Error`: If the server encounters an error.

#### **POST `/cours/create`**
- **Description**: Create a new course.
- **Request Body**:
  - `niveau` (String, required): The level of the course (e.g., 'Débutant', 'Intermédiaire', 'Avancé').
  - `format` (String, required): The format of the course (e.g., 'En ligne', 'Présentiel').
  - `domaine` (String, required): The domain of the course (e.g.,'IA', 'Données').
  - `prix` (Number, required): The price of the course.
- **Method**: `POST`
- **Response**:
  - `201 Created`: Returns the newly created course.
  - `400 Bad Request`: If any of the required fields are missing.
  - `500 Internal Server Error`: If the server encounters an error.

#### **PUT `/cours/update/:id`**
- **Description**: Update an existing course.
- **Parameters**: 
  - `id` (Path Parameter): The ID of the course to be updated.
- **Request Body**:
  - `niveau`, `format`, `domaine`, `prix` (Required): The fields to update.
- **Method**: `PUT`
- **Response**:
  - `200 OK`: Returns the updated course data.
  - `400 Bad Request`: If any required fields are missing.
  - `404 Not Found`: If no course is found with the given ID.
  - `500 Internal Server Error`: If the server encounters an error.

#### **DELETE `/cours/delete/:id`**
- **Description**: Delete a course by its ID.
- **Parameters**: 
  - `id` (Path Parameter): The ID of the course to be deleted.
- **Method**: `DELETE`
- **Response**:
  - `200 OK`: If the course was deleted successfully.
  - `404 Not Found`: If no course is found with the given ID.
  - `500 Internal Server Error`: If the server encounters an error.

---

### **2. Formations Routes**

#### **GET `/formations/`**
- **Description**: Retrieve all "formations".
- **Method**: `GET`
- **Response**:
  - `200 OK`: Returns an array of all "formations".
  - `500 Internal Server Error`: If the server encounters an error.

#### **GET `/formations/:idformation`**
- **Description**: Retrieve a single "formation" by its ID.
- **Parameters**:
  - `idformation` (Path Parameter): The ID of the "formation" to be fetched.
- **Method**: `GET`
- **Response**:
  - `200 OK`: Returns the "formation" data.
  - `404 Not Found`: If no "formation" is found with the given ID.
  - `500 Internal Server Error`: If the server encounters an error.

#### **POST `/formations/create`**
- **Description**: Create a new "formation".
- **Request Body**:
  - `idapprenant`, `idformateur`, `idcours`, `datedebut`, `datefin`, `montantpaye` (All required): The "formation" details to be created.
- **Method**: `POST`
- **Response**:
  - `201 Created`: Returns the newly created "formation".
  - `500 Internal Server Error`: If the server encounters an error.

#### **PUT `/formations/update/:idformation`**
- **Description**: Update an existing "formation".
- **Parameters**:
  - `idformation` (Path Parameter): The ID of the "formation" to be updated.
- **Request Body**:
  - `idapprenant`, `idformateur`, `idcours`, `datedebut`, `datefin`, `montantpaye` (All required): The fields to update.
- **Method**: `PUT`
- **Response**:
  - `200 OK`: Returns the updated "formation" data.
  - `404 Not Found`: If no "formation" is found with the given ID.
  - `500 Internal Server Error`: If the server encounters an error.

#### **DELETE `/formations/delete/:idformation`**
- **Description**: Delete a "formation" by its ID.
- **Parameters**:
  - `idformation` (Path Parameter): The ID of the "formation" to be deleted.
- **Method**: `DELETE`
- **Response**:
  - `200 OK`: If the "formation" was deleted successfully.
  - `404 Not Found`: If no "formation" is found with the given ID.
  - `500 Internal Server Error`: If the server encounters an error.

---

### **Additional Notes**:
- **Error Handling**: For all routes, the `500 Internal Server Error` is returned in case of server-side issues.
- **ID**: Ensure that the ID used in path parameters exists in the database for successful operations.
  
---