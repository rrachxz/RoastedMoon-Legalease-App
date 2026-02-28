![legalease_banner](https://github.com/user-attachments/assets/26191472-5a1e-40b7-88c7-b2adc3ddd374)

# Legalease
Bridging the Legal Literacy Gap. Legalease is an AI-powered application designed to protect elderly communities and vulnerable groups from digital contract scams and predatory terms.

## 1. Repository Overview & Team
This repository contains the source code for Legalease, an application developed for GDGoC KitaHack 2026.

The Team (RoastedMoon):
1. Rara (_Leader_)
2. Keisha
3. Najwa

## 2. Project Overview
### Problem Statement
Over 90% of users accept Terms of Service without reading them, largely because they are too long and overly complex. This "information poverty" disproportionately affects the elderly, who are frequent targets for digital scams due to limited technological familiarity and declining cognitive accessibility. Legalease aims to fix this by democratizing access to legal comprehension.

### SDG Alignment
- **Goal 16.3**: Promoting the rule of law and ensuring equal access to justice.

- **Goal 10.2**: Promoting social, economic, and political inclusion for all, irrespective of age.

- **Goal 4**: Promoting inclusive and equitable quality education and lifelong learning.

### Description
Legalease uses multimodal AI to instantly scan documents, identify predatory clauses, and translate complex legal jargon into simple, actionable insights.

## 3. Key Features
- **Smart AI Document Scanning**: Utilizes advanced OCR and multimodal reasoning to process images and PDFs.

- **Risk Assessment**: Instantly flags high-risk clauses (e.g., hidden fees, auto-renewals).

- **Jargon Decoder**: Provides contextual, plain-language translations for complex legal terms.

- **Chat/document History**: Securely saved chat history and document analysis for future review.

- **Accessibility-First UI**: High-contrast, scalable text presets for users with visual impairments.

## 4. Overview of Technologies
### Google Technologies
- **Flutter**: Cross-platform framework for the mobile interface.

- **Firebase Cloud Functions**: Serverless backend orchestrator to handle logic and secure API calls.

- **Cloud Firestore**: Real-time NoSQL database for syncing analysis results.

- **Firebase Storage**: Secure storage for uploaded document attachments.

- **Google Gemini API**: Multimodal AI engine for document reasoning and risk analysis.

### Other Supporting Tools
- **NewsAPI**: Used to fetch real-time updates on active scam trends.

- **Dart/Flutter Libraries**: For PDF rendering and accessibility widget management.

## 5. Implementation Details & Innovation
### System Architecture
Legalease operates on a Serverless, Event-Driven Architecture. By decoupling the Flutter frontend from the backend logic, we ensure privacy and high availability.

### Workflow
- **Input**: User uploads a document via the Flutter interface.

- **Orchestration**: Cloud Functions detects the upload and routes the file to the Gemini API.

- **Reasoning**: Gemini performs multimodal analysis, identifying risks and simplifying jargon.

- **Sync**: Results are pushed to Firestore, which updates the Flutter UI in real-time.

## 6. Challenges Faced
### Multimodal AI Integration:

**Problem**: Standard OCR libraries destroyed the structural context of contracts.

**Solution**: We implemented Byte-Stream Serialization to pass raw file data directly to Gemini, allowing the AI to "see" the document layout.

**Impact**: Significant increase in accuracy for doucment layout and clause detection.

### Accessibility UI:

**Problem**: Dynamic font sliders caused layout "jank" (stuttering) and breakage.

**Solution**: Replaced with Static Accessibility Presets (Small/Medium/Large).

**Impact**: A stable, predictable UI that is more user-friendly for elderly demographics.

## 7. Installation & Setup
1. Clone the repository:
git clone [https://github.com/rrachxz/RoastedMoon-Legalease-App.git]

2. Configure Firebase:

3. Add your google-services.json (Android) and GoogleService-Info.plist (iOS).

4. Enable Firebase Authentication, Firestore, and Cloud Functions in the console.

5. Environment Variables:
Set your GEMINI_API_KEY in the Cloud Functions configuration.

6. Run the app:

- flutter pub get

- flutter run

## 8. Future Roadmap
- Introducing interactive modules to teach users how to spot common scams through repetition and rewards.

- Expanding accessibility features to allow the app to "read aloud" the risk analysis to users with severe visual impairments.
