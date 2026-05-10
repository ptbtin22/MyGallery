# MyGallery

A modern, high-performance photo gallery application built with SwiftUI, leveraging **Feature-First Clean Architecture**, **MVVM**, and **SOLID** principles.

## 🚀 Key Features
- **AI Image Classification**: Integrated Apple's **Vision Framework** to automatically categorize photos (e.g., Nature, Architecture, Computer) directly on-device.
- **Collections (Albums)**: Create custom albums and organize your photos with a persistent many-to-many relationship in Core Data.
- **Premium UI/UX**: Stunning first impression with vibrant colors, dark mode support, glassmorphism, and smooth animations.
- **Offline-First Strategy**: Robust caching layer using **Core Data** for metadata and offline usage.
- **Infinite Scrolling**: Optimized pagination and heavy asset management using **Kingfisher**.
- **Search Functionality**: Efficient photo search by author or **AI-detected categories** with debouncing.
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
- **Core/AI**: On-device machine learning services using Vision.
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
3. Build and Run on a **real iOS device** to experience the full AI capabilities.

## 📸 Screenshots

| Photo Details & AI | Favorites | Collections |
| :---: | :---: | :---: |
| <img src="https://github.com/user-attachments/assets/a1c093dc-473c-4db3-bab4-c210056e7d04" width="250" /> | <img src="https://github.com/user-attachments/assets/4305f353-df7b-4f75-89e6-7753b4a78702" width="250" /> | <img src="https://github.com/user-attachments/assets/6586297b-f6ba-4c05-ab36-69dc87c3f69e" width="250" /> |
