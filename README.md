# Flutter Task Management Application

## Overview
This application provides user authentication and task management functionalities. It leverages the DummyJSON API for both user authentication and task management, ensuring a seamless experience.

## Features
1. **User Authentication**: Users can securely log in with their Username and Password using the DummyJSON API.
2. **Task Management**: Users can view, add, edit, and delete tasks.
3. **Pagination**: Efficiently fetches a large number of tasks with pagination.
4. **State Management**: Manages state efficiently across the app using Provider, Bloc, or Redux.
5. **Local Storage**: Persist tasks locally using shared preferences or SQLite.
6. **Unit Tests**: Comprehensive unit tests cover critical functionalities.

## Setup

### Prerequisites
- Flutter SDK: [Install Flutter](https://flutter.dev/docs/get-started/install)
- An IDE like VSCode or Android Studio

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/arsarsars1/task_manager.git
   cd flutter-task-app
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```

## Usage

### User Authentication
- Implement authentication using [DummyJSON Auth](https://dummyjson.com/docs/auth).
- Users can log in with their Username and Password.

### Task Management
- Manage tasks using [DummyJSON Todos](https://dummyjson.com/docs/todos).
- Implement functionalities to view, add, edit, and delete tasks.

### Pagination
- Fetch tasks with pagination using the endpoint:
  ```bash
  https://dummyjson.com/todos?limit=10&skip=10
  ```

### State Management
- Choose and implement one of the following state management patterns: Provider, Bloc, or Redux.

### Local Storage
- Persist tasks locally using Flutter's shared preferences or SQLite.

### Unit Tests
- Write unit tests covering task CRUD operations, input validation, state management, and network requests.
- Use mock responses for testing against reqres.in endpoints.

## Running the App
1. Run the app:
   ```bash
   flutter run
   ```

2. To run tests:
   ```bash
   flutter test
   ```

## Contributing
Contributions are welcome! Please fork the repository and submit a pull request.

## License
This project is licensed under the MIT License.

## Contact
For any queries or suggestions, feel free to reach out at [arsarsars1@gmail.com].
