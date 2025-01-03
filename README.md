Below is an **updated README** that includes **Dark/Light Mode** toggling information and the steps to run your project. Feel free to adjust any wording or sections to suit your needs.

---

# Flutter Song Search & Lyrics App

This repository contains a **Flutter** application that lets you **search for songs** via the **Spotify Web API** and **display their lyrics** using the **Lyrics.ovh** API. Additionally, the app now supports **Dark/Light Mode** toggling from the AppBar.

---

## Table of Contents

1. [Features](#features)  
2. [Tech Stack](#tech-stack)  
3. [Project Structure](#project-structure)  
4. [Prerequisites](#prerequisites)  
5. [Setup Instructions](#setup-instructions)  
6. [Running the App](#running-the-app)  
7. [Usage Guide](#usage-guide)  
   - [Searching Tracks](#searching-tracks)  
   - [Viewing Lyrics](#viewing-lyrics)  
   - [Dark/Light Mode Toggling](#darklight-mode-toggling)  
8. [Troubleshooting](#troubleshooting)  
9. [Contributing](#contributing)  
10. [License](#license)

---

## Features

- **Search for songs** by keyword (song title, artist name).
- **View track details** (title, artist name, album art).
- **Fetch and display lyrics** from [Lyrics.ovh](https://lyricsovh.docs.apiary.io/).
- **Dark/Light Mode** toggle button in the AppBar.
- **Auto-detect** and handle RTL lyrics (e.g., Arabic).
- **Colorful UI** thanks to the `palette_generator` for dynamic gradients.

---

## Tech Stack

- **Flutter** (Dart) as the main framework.
- **Spotify Web API** for searching tracks.
- **Lyrics.ovh** for lyrics.
- **palette_generator** for generating dynamic colors from album art.
- **http** for networking.
- **flutter_dotenv** for environment variables (e.g., Spotify credentials).

---

## Project Structure

```
lib/
 ┣ models/
 ┃  ┗ track.dart                 # Data model for a track
 ┣ screens/
 ┃  ┣ home_screen.dart           # Main screen for searching + theme toggle
 ┃  ┗ detail_screen.dart         # Screen for displaying selected track + lyrics
 ┣ services/
 ┃  ┣ spotify_service.dart       # Handles calls to Spotify
 ┃  ┗ lyrics_service.dart        # Handles calls to Lyrics.ovh
 ┣ widgets/
 ┃  ┣ search_bar.dart            # Custom search bar widget
 ┃  ┗ track_tile.dart            # Widget displaying a single track item
 ┗ main.dart                     # Entry point of the Flutter app
```

---

## Prerequisites

1. **Flutter SDK** (v3.x or newer recommended).
2. **Android Studio** or **Visual Studio Code** (optional, but recommended).
3. **Spotify Developer Account** to obtain **Client ID** and **Client Secret** if you plan to use Spotify search.
4. (Optional) **.env File** using [flutter_dotenv](https://pub.dev/packages/flutter_dotenv).

---

## Setup Instructions

1. **Clone the Repository**  
   ```bash
   git clone https://github.com/<your-username>/<repo-name>.git
   cd <repo-name>
   ```

2. **Create/Update the `.env` File (Optional)**  
   - In the project root, create a new `.env` file:
     ```dotenv
     SPOTIFY_CLIENT_ID=YOUR_SPOTIFY_CLIENT_ID
     SPOTIFY_CLIENT_SECRET=YOUR_SPOTIFY_CLIENT_SECRET
     ```
   - Ensure `.env` is ignored in your `.gitignore` if you don’t want to commit your secrets.

3. **Install Packages**  
   ```bash
   flutter pub get
   ```

4. **Configure SpotifyService**  
   - In `lib/services/spotify_service.dart`, confirm your environment variables or update the client ID/secret directly.

---

## Running the App

1. **Connect a Device/Emulator**  
   - Ensure at least one device is available:
     ```bash
     flutter devices
     ```
2. **Run the App**  
   ```bash
   flutter run
   ```
   - Or specify a device:
     ```bash
     flutter run -d <deviceId>
     ```
   - This will launch the **Home Screen** of the app.

---

## Usage Guide

### Searching Tracks

1. On the **Home Screen**, enter a **song title** or **artist name** in the search field.
2. Tap the **search icon** or press **Enter**.  
3. The app shows a list of matching tracks from Spotify:
   - Each list item displays the track name, artist name, and album art thumbnail.

### Viewing Lyrics

1. Tap on any track to go to the **Detail Screen**.
2. The app automatically fetches lyrics from **Lyrics.ovh**.
3. If found, lyrics are displayed line-by-line in a scrollable view.
   - If lyrics appear to be mostly in a right-to-left script (e.g., Arabic), they are displayed in RTL alignment automatically.
4. If lyrics are unavailable, an error message is shown.

### Dark/Light Mode Toggling

- In the **AppBar** on the Home Screen, you’ll see an icon (`moon` or `sun`).
- Tapping this icon **toggles** between **dark mode** and **light mode** across the entire app.
- The current theme mode is retained for the duration of the session. (To persist across restarts, you’d need additional logic.)

---

## Troubleshooting

- **No Results** when searching:
  - Verify your Spotify credentials.
  - Check your internet connection.
  - Double-check your search query.
- **Lyrics Not Found**:
  - Lyrics.ovh may not have every track. Try another song.
- **App Build Errors**:
  - Ensure you’ve run `flutter pub get` after cloning.
  - Make sure your Flutter SDK is installed correctly.
- **Dark Mode Not Toggling**:
  - Confirm you’re running the updated `home_screen.dart` with the icon button in the AppBar.
  - Verify your calls to `MyApp.of(context)?.toggleTheme(...)` in `home_screen.dart`.

---

## Contributing

Contributions are welcome! To contribute:

1. **Fork** the repo.
2. Create a **feature branch**.
3. Commit your changes.
4. Push to your fork.
5. Submit a **Pull Request**.

---

## License

This project is open source under the [MIT License](LICENSE). You can freely modify and redistribute the code.

---
