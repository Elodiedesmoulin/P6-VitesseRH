# 🚗 Vitesse RH – Candidate Management App (Project P6)

<img width="300" alt="Vitesse RH App" src="./Screenshots/vitesse-preview.png">

## Table of Contents

- [Introduction](#introduction)
- [Features](#features)
- [Architecture](#architecture)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
- [Usage](#usage)

---

### Introduction

**Vitesse RH** is a candidate management app developed in SwiftUI using the MVVM architecture.  
It was created as part of the final hands-on project of the **OpenClassrooms iOS Developer Path**.  
The app allows HR teams to browse, add, edit, and favorite candidates with a smooth user experience and reliable data flow from a REST API.

---

### Features

- **List of candidates** loaded from an external API
- **Add, edit and delete candidate** information
- **Mark candidates as favorites**
- **Search and filter candidates**
- **Structured app architecture with MVVM**
- **Responsive and clean UI built with SwiftUI**
- **Proper error handling and loading states**

---

### Architecture

This project follows the **MVVM (Model-View-ViewModel)** design pattern for better maintainability and testability.

#### View
Built using SwiftUI – reacts to data changes and provides dynamic interface components.

#### ViewModel
Handles business logic, API calls, and formatting of data for the views. Decouples UI from the data layer.

#### Model
Defines the data structures for candidates, API endpoints, and decoding logic (conforming to `Codable`).

---

## Getting Started

### Prerequisites

- Xcode 15 or later
- iOS 17 or later
- Internet connection for API access

---

### Installation

1. Clone the repository:
```bash
git clone https://github.com/your-username/VitesseRH.git
