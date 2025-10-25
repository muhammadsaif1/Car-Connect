# 🚗 CarConnect

A **Flutter-based mobile application** for renting cars and hiring drivers — all in one place.  
Built to simplify car rentals by connecting **customers, car owners, and drivers** through a clean, modern mobile experience.

---

## 📱 Overview

**CarConnect** solves the real-world problem of people having to visit multiple rental shops to find a suitable car or driver.  
With this app, users can browse, book, and manage everything directly from their phone.  

Car owners can also list their cars for rent, and verified drivers can offer their services.  
The app functions **fully offline** using local Sqlilite storage for data management.

---

## 🧩 Key Features

### 👤 User Features
- Browse cars available for rent in your city  
- Choose car with or without a driver  
- Upload and verify NIC and license (stored locally)  
- Make and manage bookings  
- Works offline using Sqlilite  

### 🚘 Car Owner Features
- Add, edit, or delete car listings  
- Set rental price, city, and availability  
- Manage bookings and approvals  

### 🧍‍♂️ Driver Features
- Register and create driver profiles  
- Add experience and hourly rates  
- View booking requests and manage availability  

### 🛠️ Admin Features
- Approve or reject new user, driver, or car registrations  
- Oversee booking records and data integrity

---

The project follows a modular structure to maintain clarity and reusability.  
Each module is responsible for its specific task — such as models for data structure, services for logic, and screens for UI.

---

## 🗃️ Local Database – Sqlilite

The app uses **Sqlilite** — a fast, lightweight NoSQL database — for offline data storage.  
All data is stored locally on the user’s device in Sqlilite “boxes.”

| Box | Description |
|------|-------------|
| `usersBox` | Stores all user and admin profiles |
| `carsBox` | Stores all car listings |
| `driversBox` | Stores registered driver profiles |
| `bookingsBox` | Stores all rental and driver booking records |

### ✅ Why Sqlilite?
- Fully offline and lightweight  
- No complex setup or SQL queries  
- Instant read/write performance  
- Built with Dart for smooth Flutter integration  
- Secure (supports encryption)

---

## 🧰 Tech Stack

| Category | Tools / Frameworks |
|-----------|--------------------|
| **Frontend** | Flutter (Dart) |
| **Local Database** | Sqlilite |
| **State Management** | Provider |
| **UI Framework** | Material Design |
| **IDE** | Android Studio / VS Code |

---

## 🚀 Getting Started

### 1️⃣ Clone the Repository
```bash
git clone https://github.com/muhammadsaif1/Car-Connect.git
cd Car-Connect
2️⃣ Install Dependencies
flutter pub get
3️⃣ Run the App
flutter run
⚙️ Requirements

Flutter SDK (≥ 3.0)

Dart (≥ 2.17)

Android Studio or VS Code

🧾 License

This project is developed for academic and educational purposes as part of the Course-End Project (CEP).
You are free to modify or extend it for learning or personal projects.

👨‍💻 Author

Muhammad Saif
📍 Pakistan


## 🧠 App Structure

