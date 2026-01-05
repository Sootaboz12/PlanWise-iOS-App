# PlanWise

A beautiful and intuitive note-taking iOS application built with SwiftUI that helps you organize your thoughts with visual imagery.

## Features

### 📝 Core Functionality
- **Create Notes**: Easily create notes with custom titles and accompanying images
- **Image Integration**: Search for images via Pixabay API or upload from your photo library
- **Rich Text Editing**: Write and edit note content with a clean text editor
- **Recent Notes**: Quick access to your most recently opened note
- **User Profiles**: Personalized experience with user profiles and custom profile pictures

### 🎨 User Experience
- **Modern Dark Theme**: Sleek purple and dark-themed interface
- **Smooth Animations**: Polished transitions and interactive elements
- **Welcome Animation**: First-time user greeting with personalized welcome message
- **Image Management**: Change note images anytime from the photo library
- **Persistent Storage**: All notes and images are saved locally using SwiftData

### 🖼️ Image Features
- **Pixabay Integration**: Automatically fetch relevant images based on note titles
- **Photo Library Access**: Upload custom images from your device
- **Smart Fallbacks**: Automatic fallback to random images if searches fail
- **Local Storage**: Efficient image caching and management

## Requirements

- **iOS**: 17.0 or later
- **Xcode**: 15.0 or later
- **Swift**: 5.9 or later

## Installation & Setup

### 1. Clone or Download the Project
Download the project files and open the project in Xcode.

### 2. Open in Xcode
```bash
# Navigate to the project directory
cd PlanWise

# Open the project
open PlanWise.xcodeproj
```

### 3. Configure Pixabay API (Optional)
The app includes a Pixabay API key for image searches. If you want to use your own key:

1. Get a free API key from [Pixabay](https://pixabay.com/api/docs/)
2. Open `PixabayResponse.swift`
3. Replace the API key in the `PixabayService` class:
   ```swift
   private let apiKey = "YOUR_API_KEY_HERE"
   ```

### 4. Build and Run
1. Select a target device or simulator (iPhone running iOS 17.0+)
2. Press `⌘ + R` or click the Run button
3. The app will build and launch

## First Launch

On first launch, you'll be greeted with an onboarding screen:

1. **Enter Your Name**: Provide your name for personalization
2. **Set Date of Birth**: Select your birthday
3. **Get Started**: Complete onboarding to access the app

After onboarding, you'll see a welcome animation with your name!

## How to Use

### Creating a Note
1. Tap the **+** button in the top-right corner
2. Enter a note title
3. (Optional) Enter an image search term
4. Choose from:
   - **Search Images**: Browse 6 relevant images from Pixabay
   - **Photo Library**: Upload an image from your device
   - **Create without search**: Auto-select an image based on title

### Editing a Note
1. Tap on any note card from the home screen
2. Edit the content in the text editor
3. Changes are automatically saved

### Changing Note Images
1. Open a note or tap the photo icon on a note card
2. Select **Change Image** (camera icon)
3. Choose a new image from your photo library

### Viewing Recent Notes
- Navigate to the **Recent** tab to quickly access your last opened note

### Managing Your Profile
1. Go to the **Profile** tab
2. Tap the camera icon to change your profile picture
3. View your name, birthday, and total note count

## Project Structure

```
PlanWise/
├── PlanWiseApp.swift          # App entry point
├── Models/
│   ├── NoteItem.swift         # Note data model
│   └── UserManager.swift      # User state management
├── Views/
│   ├── OnboardingView.swift   # First-launch onboarding
│   ├── MainTabView.swift      # Tab navigation
│   ├── HomeView.swift         # Main notes list
│   ├── NoteDetailView.swift   # Note editing view
│   ├── RecentNoteView.swift   # Recent note display
│   ├── ProfileView.swift      # User profile
│   ├── NoteCardView.swift     # Note card component
│   └── ImagePickerView.swift  # Image selection UI
├── Services/
│   ├── PixabayResponse.swift  # Pixabay API integration
│   ├── PhotoLibraryPicker.swift   # Photo library access
│   └── ProfileImagePicker.swift   # Profile image picker
└── Utilities/
    └── Extensions.swift       # Color and UI extensions
```

## Permissions Required

The app requires the following permissions:
- **Photo Library Access**: To upload custom images for notes and profile pictures

These permissions will be requested automatically when needed.

## Data Storage

- **Notes**: Stored locally using SwiftData
- **Images**: Saved in the app's documents directory
- **User Data**: Stored in UserDefaults (name, date of birth, preferences)

## Troubleshooting

### Images Not Loading
- Check your internet connection for Pixabay images
- Verify photo library permissions are granted

### Build Errors
- Ensure you're using Xcode 15.0 or later
- Clean build folder: `⌘ + Shift + K`
- Rebuild: `⌘ + B`

### App Crashes on Launch
- Delete the app from your device/simulator
- Clean build folder and rebuild
- Check that iOS version is 17.0 or later

## Future Enhancements

Potential features for future versions:
- iCloud sync across devices
- Note categories and tags
- Search functionality
- Export notes as PDF
- Dark/light theme toggle
- Note sharing capabilities

## Credits

- **Images**: Powered by [Pixabay API](https://pixabay.com/)
- **Framework**: Built with SwiftUI and SwiftData
- **Icons**: SF Symbols by Apple

## License

This project is for educational and personal use.

---

**Enjoy using PlanWise! 📝✨**
