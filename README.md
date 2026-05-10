# PhotoGallery

A modern, high-performance photo gallery application built with SwiftUI, leveraging **Feature-First Clean Architecture**, **MVVM**, and **SOLID** principles.

## 🚀 Key Features
- **Premium UI/UX**: Stunning first impression with vibrant colors, dark mode support, glassmorphism, and smooth animations.
- **Offline-First Strategy**: Robust caching layer using **Core Data** for metadata and offline usage.
- **Infinite Scrolling**: Optimized pagination and heavy asset management using **Kingfisher**.
- **Search Functionality**: Efficient photo search with debouncing.
- **Favorites System**: Persistent favorites management.
- **Reactive Data Flows**: Implemented with **Combine** for consistent asynchronous data handling.
- **Dependency Injection**: Centralized DI using **Swinject**.

## 🛠 Architecture & Principles
The project follows **Clean Architecture** organized by **Features**, ensuring the codebase remains decoupled, testable, and scalable.

### Feature-First Structure
Each feature is self-contained with its own layers:
- **Domain**: Pure business logic (Entities, UseCases, Repository Protocols).
- **Data**: Repository implementations and Data Transfer Objects (DTOs).
- **Presentation**: MVVM (ViewModels and SwiftUI Views).

### Core Layers
- **Core/Networking**: Base API services using Combine.
- **Core/Persistence**: Core Data stack and persistence services.
- **Core/UIComponents**: Reusable premium UI components.

## 📦 Dependencies
- [Swinject](https://github.com/Swinject/Swinject): Dependency Injection.
- [Kingfisher](https://github.com/onevcat/Kingfisher): Image caching and management.
- [Combine](https://developer.apple.com/documentation/combine): Reactive programming.
- [Cuckoo](https://github.com/Brightify/Cuckoo): Protocol-based mocking for unit testing.

## ⚙️ Getting Started
1. Clone the repository.
2. Open `PhotoGallery.xcodeproj`.
3. Build and Run on your simulator or device.
