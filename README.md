<h1 align="center"><strong>🌌 APOD – Astronomy Picture of the Day (iOS)</strong></h1>

An iOS application built using SwiftUI that displays NASA’s Astronomy Picture of the Day (APOD), with a strong focus on performance, clean architecture, and native iOS UX.

<br/>
## 📸 Screenshots
<div align="center">
  <img width="1359" src="https://github.com/user-attachments/assets/fb886754-9c9f-4fc3-80fe-b96e48c77c6d" />
  <img width="1359" src="https://github.com/user-attachments/assets/67a09c22-1fd5-48de-8cb1-238763833cc6" />
  <img width="1359" src="https://github.com/user-attachments/assets/90f7afdd-cc99-4632-9feb-5e239a74256d" />
</div>

<br/>
## 📱 Features
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
## 🎨 UI / UX Design

Built entirely with SwiftUI

Apple Glass UI using ultraThinMaterial

Immersive fullscreen viewing experience

Subtle animations and gesture feedback

Follows Apple Human Interface Guidelines

Minimal and distraction-free design

<br/>
## 🧠 Architecture

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
## 🌐 Networking

Uses NASA APOD API

Implemented using async / await

Prevents duplicate API calls by tracking selected date

Graceful handling of:

Network failures

Invalid responses

Unsupported media types

<br/>
## 🚀 Performance Optimizations

Progressive image loading

Low-resolution image loads immediately

High-resolution image upgrades silently when available

ViewModel remains agnostic of image resolution

Smooth perceived performance even on slow networks

<br/>
## 🔐 Security & Configuration

Sensitive configuration is not committed to source control.

API Key Handling

Uses an .xcconfig file for secrets

Secrets.xcconfig is ignored by Git

A template file is provided for setup

<br/>
## ⚙️ Setup Instructions
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
## 🧪 Permissions Required

The app requests:

Photo Library (Add Only) – for saving images

Ensure the following keys exist in Info.plist:

Privacy - Photo Library Additions Usage Description

Privacy - Photo Library Usage Description

<br/>
## 🧭 Gesture Guide
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
## 🧑‍💻 Tech Stack

Swift

SwiftUI

Combine

Async / Await

URLSession

Photos Framework

<br/>
## 📸 Credits

Images and data provided by NASA APOD API

<br/>
## ✅ Final Note

This project focuses on engineering judgment, code quality, and user experience, rather than maximizing feature count.
