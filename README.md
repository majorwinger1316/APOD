🌌 APOD – Astronomy Picture of the Day (iOS)

An iOS application built using SwiftUI that displays NASA’s Astronomy Picture of the Day (APOD), with a strong focus on performance, clean architecture, and native iOS UX.

This project was developed as part of a time-bound company technical assignment.

<br/>
📸 Screenshots

(Add screenshots / screen recordings here)

📷 Home Screen
📷 Date Picker
📷 Fullscreen Image Viewer
📷 Zoom + Share / Save

<br/>
📱 Features
Core Functionality

📅 Displays today’s APOD on launch

🕰 Select any date using a wheel-style date picker

⬅️➡️ Swipe horizontally to navigate between days

🖼 Progressive image loading (low-res → HD)

🔍 Fullscreen Photos-style image viewer

🤏 Pinch & double-tap zoom (cannot zoom out smaller than screen)

⬇️ Pull-down gesture to dismiss fullscreen view

💾 Save image to Photos

📤 Share image via native iOS share sheet

📖 Expandable explanation text

<br/>
🎨 UI / UX Design

Built entirely with SwiftUI

Glass-like UI using ultraThinMaterial

Immersive fullscreen viewing experience

Subtle animations and gesture feedback

Follows Apple Human Interface Guidelines

Minimal and distraction-free design

<br/>
🧠 Architecture

MVVM (Model–View–ViewModel)

HomeViewModel is responsible for:

API calls

State management

Error handling

Views are declarative and lightweight

Clear separation between:

Networking

UI

Presentation logic

<br/>
🌐 Networking

Uses NASA APOD API

Implemented using async / await

Prevents duplicate API calls by tracking selected date

Graceful handling of:

Network failures

Invalid responses

Unsupported media types

<br/>
🚀 Performance Optimizations

Progressive image loading

Low-resolution image loads immediately

High-resolution image upgrades silently when available

ViewModel remains agnostic of image resolution

Smooth perceived performance even on slow networks

<br/>
🔐 Security & Configuration

Sensitive configuration is not committed to source control.

API Key Handling

Uses an .xcconfig file for secrets

Secrets.xcconfig is ignored by Git

A template file is provided for setup

<br/>
⚙️ Setup Instructions
1️⃣ Clone the repository
git clone <repository-url>

<br/>
2️⃣ Create Secrets file

Copy Secrets.xcconfig.example

Rename it to Secrets.xcconfig

<br/>
3️⃣ Add your NASA API key
API_KEY = YOUR_NASA_API_KEY


You can obtain a free API key from:
https://api.nasa.gov

<br/>
4️⃣ Open in Xcode

Open the project

Select simulator or real device

Build & run

<br/>
🧪 Permissions Required

The app requests:

Photo Library (Add Only) – for saving images

Ensure the following keys exist in Info.plist:

NSPhotoLibraryAddUsageDescription

NSPhotoLibraryUsageDescription

<br/>
🧭 Gesture Guide
Gesture	Action
Swipe Left	Go to next day
Swipe Right	Go to previous day
Pinch	Zoom in
Double Tap	Toggle zoom
Pull Down	Dismiss fullscreen image
<br/>
🛠 Trade-offs & Decisions

Given the limited time:

Focused on stability and UX over feature quantity

Persistent favourites were not implemented

Video APOD playback was intentionally skipped

These were conscious decisions to prioritize clean execution.

<br/>
🔮 Possible Improvements

Persistent favourites (Core Data)

Offline caching

APOD video support

Accessibility improvements

Background prefetching

Unit tests

<br/>
🧑‍💻 Tech Stack

Swift

SwiftUI

Combine

Async / Await

URLSession

Photos Framework

<br/>
📸 Credits

Images and data provided by NASA APOD API

<br/>
✅ Final Note

This project focuses on engineering judgment, code quality, and user experience, rather than maximizing feature count.
