# BuzzzChat

BuzzzChat is a feature-rich chat application built using **Flutter** and **Firebase**. It supports user authentication, real-time messaging, profile customization, and an engaging UI with animations and gradient themes.

## 🤝 Screenshots


## 📌 Features
- **User Authentication** (Email & Password, Google, Phone OTP)
- **Profile Management** (Username, Bio, Profile Picture Upload)
- **Real-Time Chat** (One-on-One Messaging)
- **Friend System** (Add, Remove, Search Friends)
- **UI Enhancements** (Animated Profile Views, Themed UI, Dark Mode Support)
- **Push Notifications**

---
## 🏗️ Project Structure

```
BuzzzChat/
│-- lib/
│   ├── main.dart                # Entry point of the app,App themes and styles,Common constants
│   ├── splashscreen    
│   ├── features/
│   │   ├── auth/                # Authentication Module
│   │   │   ├── controller.dart  # Handles authentication logic
│   │   │   ├── screen/
│   │   │   │   ├── loginscreen.dart
│   │   │   │   ├── signupscreen.dart
│   │   │   ├── widget/
│   │   │   │   ├── phone.dart   # Phone authentication UI
│   │   │   │   ├── varificationbox.dart   # Varify OTP UI
│   │   ├── chat/                # Chat Feature
│   │   │   ├── chat_screen.dart  # Chat UI
│   │   │   ├── chat_widget.dart  # Chat Element
│   │   │   ├── chat_logic.dart  # Chat Logic(controller and Provider)
│   │   ├── post_comment/             # Profile Management
│   │   │   ├── post_screen.dart  # Chat UI
│   │   │   ├── post_widget.dart  # Chat Element
│   │   │   ├── post_logic.dart  # Chat Logic(controller and Provider)
│   │   ├── storage             # Handles file uploads & retrieval from Firebase Storage  
│   ├── models/                  # Data Models
│   │   ├── user.dart            # User Model
│   │   ├── call.dart            # Call Model
│   │   ├── chat_contact.dart    # Contact Model
│   │   ├── group.dart           # Group Model
│   │   ├── message.dart         # Message Model
│   │   ├── post.dart            # Post Model
│   │   ├── status.dart          # Status Model
│   ├── enrtypage/               # Riverpod State Management
│   ├── utils/                   # Utility Functions
│   │   ├── utils.dart           # Common utility functions
│   │   ├── image_picker.dart    # Image picker utility
│   ├── screens/                 # Reusable Widgets
│── /screens  
│   ├── /add_post_screen    --> Screen for adding new posts  
│   ├── /followpage         --> Screen for managing followers & following  
│   ├── /homescreen         --> Main home screen displaying content & navigation  
│   ├── /messagehome        --> Chat home screen for messaging functionality  
│   ├── /profilescreen      --> User profile screen (view & edit profile)  
│   ├── /reelsscreen        --> Screen for viewing and uploading reels/videos  
│   ├── /searchscreen  
│-- android/                     # Android-specific configuration
│-- ios/                         # iOS-specific configuration
│-- pubspec.yaml                 # Dependencies and project metadata
│-- README.md                    # Project Documentation
```

---
## 🔧 Installation & Setup

1. **Clone the repository**
   ```sh
   git clone https://github.com/yourusername/BuzzzChat.git
   cd BuzzzChat
   ```

2. **Install dependencies**
   ```sh
   flutter pub get
   ```

3. **Set up Firebase**
   - Create a Firebase project
   - Enable **Email/Password**, **Google Sign-In**, and **Phone Authentication**
   - Download and place `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) in the respective folders

4. **Run the app**
   ```sh
   flutter run
   ```

---
## 🚀 Future Enhancements
- Group Chat
- Voice & Video Calls
- Message Reactions & Emojis
- Chat Themes & Customizations
- End-to-End Encryption

---
## 🤝 Contributing
Pull requests are welcome! If you'd like to contribute, please fork the repo and submit a PR.

---
## 🛠 Tech Stack
- **Framework**: Flutter
- **State Management**: Riverpod
- **Backend**: Firebase (Auth, Firestore, Storage)

---
## 📜 License
This project is open-source and available under the [MIT License](LICENSE).

