# Edu Hub - Unified National Education Platform

Edu Hub is a comprehensive front-end Flutter application designed to serve as the unified national education platform for Kenya. It integrates all Kenyan universities and higher education institutions through a Single Student ID system, providing seamless access to student records, courses, academic history, and more. The platform aims to simplify and streamline educational services across institutions while empowering students with AI-powered career guidance.

## Project Overview

Edu Hub is part of a larger ecosystem that includes a Django-based RESTful API backend managing various educational and career-related functionalities. The front-end Flutter app interacts with this backend to deliver a rich, user-friendly experience for students and educational institutions.

### Key Features

- **Single Student ID:** A centralized identifier linking students to their academic records and courses across institutions.
- **AI-Powered Career Guidance:** An intelligent chatbot module that provides personalized career advice based on students' strengths, academic profiles, and aspirations.
- **Course Search:** Enables students to search for courses offered by various universities and institutions.
- **Competency Tracking:** Allows students to track their competencies and academic progress.
- **Dashboard:** A personalized dashboard displaying recent activities, competencies, and academic status.
- **Exam Registration:** Facilitates exam registration and management.
- **User Authentication:** Secure login and registration system for students.
- **Academic History:** Access to detailed student academic history and records.
- **Program Search and Registration:** Search and register for academic programs offered by institutions.

## Front-End Application Structure

The Flutter app is organized into several modules, each responsible for a specific domain:

- **Chatbot:** AI-powered career guidance chatbot to assist students in making informed career decisions.
- **Competency:** Features related to tracking and visualizing student competencies.
- **Course Search:** Functionality to search and explore available courses.
- **Dashboard:** Main user interface displaying key information and recent activities.
- **History:** Displays student academic history and records.
- **Login:** User authentication screens including login and registration.
- **Main:** Core app navigation and main screens.
- **Programs:** Search and details of academic programs.
- **Registration:** Student registration and enrollment features.

## Backend

The backend is a Django-based RESTful API that manages data and business logic for the platform. It handles user authentication, academic records, course and program management, exam registration, and the AI-powered career guidance logic.

## Getting Started

### Prerequisites

- Flutter SDK installed. Follow the official guide: [Flutter Installation](https://docs.flutter.dev/get-started/install)
- An IDE such as VS Code or Android Studio configured for Flutter development.
- Access to the Edu Hub backend API (Django REST API).

### Running the App

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd UNEP_FRONT_END
   ```

2. Get Flutter dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app on an emulator or connected device:
   ```bash
   flutter run
   ```

## Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Django REST Framework](https://www.django-rest-framework.org/)

## Contributing

Contributions to Edu Hub are welcome. Please fork the repository and submit pull requests for any enhancements or bug fixes.

## License

This project is licensed under the MIT License.
