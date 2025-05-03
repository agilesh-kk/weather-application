# 🌤️ Flutter Weather Forecast App

A modern and beginner-friendly weather app built using Flutter and Dart. It fetches current weather and forecast data using the OpenWeatherMap API and displays it with a clean, dark-themed UI.

---

## 📂 Project Structure

lib/
├── main.dart # Main app file\n
├── key.dart # Your API key goes here\n
├── widgets/\n
│ ├── weather_card.dart # Reusable widget for hourly forecast\n
│ └── info_card.dart # Widget for additional info (humidity, wind)\n

---

## 🔧 Getting Started

Follow these steps to set up and run the project locally.
1. Clone the Repository
git clone https://github.com/your-username/flutter-weather-app.git
cd flutter-weather-app
2. Install Flutter Packages
flutter pub get
3. Add Your API Key
This app uses the OpenWeatherMap API. You must get your own API key to use the app.

## 🔑 How to get your API key:
Visit https://openweathermap.org/api
Sign up for a free account
Go to your profile → API Keys → copy your key

## 🔧 Add your key:
Create or open this file:
lib/key.dart
Paste the following and replace the placeholder:
const String apiKey = "YOUR_API_KEY_HERE";
⚠️ Important: Do not share this API key publicly.

## 📱 Run the App
To run the app on your device or emulator:
flutter run

## 📦 Build APK
To generate a release APK to install on Android phones:
flutter build apk --release
The APK will be generated at:
build/app/outputs/flutter-apk/app-release.apk

## 🧹 .gitignore
Ensure your .gitignore includes the following to protect sensitive files:
build/
.dart_tool/
.packages
.flutter-plugins
.idea/
android/key.properties
lib/key.dart

## 🪪 License
This project is licensed under the MIT License.

## 👤 Author
GitHub: agilesh-kk

## 🌟 Support
If you found this project helpful, feel free to give it a ⭐ on GitHub and share it!
