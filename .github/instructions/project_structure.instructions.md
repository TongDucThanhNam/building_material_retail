---
applyTo: '**'
---
# Technology used
- Flutter
- Dart
- Supabase (Authentication, Database Postgres, Storage)
- Riverpod

# Project Structure
- `lib/`
  - `main.dart`: Entry point of the application.
  - `app`: Contains pages and widgets.
    - `pages/`: Contains individual pages of the application.
    - `widgets/`: Contains reusable widgets.
    - `providers/`: Contains Riverpod providers for state management.
    - `utils/`: Contains utility functions and extensions.
  - `domain/`: Contains entities and repositories.
    - `entities/`: Contains domain entities.
    - `repositories/`: Contains repository interfaces and implementations.
  - `services/`: Contains services for interacting with external APIs or databases (Supabase).
    - `supabase_service.dart`: Service for interacting with Supabase.
    - `*_service.dart`: Other services as needed.
# Target Audience:
- Android, iOS, and web users who need a building material retail application.
- Users who prefer a modern, responsive, and user-friendly interface.
- Users who require real-time data synchronization and offline capabilities.
- Users who value security and privacy in their applications.

# Features & Roadmap:
## Authentication
- [ ] User registration and login