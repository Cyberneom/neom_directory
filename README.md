# neom_directory

A location-based business and professional directory module for Flutter applications, part of the Open Neom ecosystem.

## Current Version: 1.3.0

## Philosophy

**Connect locally, discover globally.** neom_directory helps users find professionals, artists, and businesses in their vicinity, fostering local connections within the Open Neom community.

## Features

### Current Capabilities (v1.3.0)
- **Geolocation-Based Discovery**: Find profiles sorted by distance from user
- **Profile Type Filtering**: Filter by artist, host, band, facilitator, etc.
- **Smart Caching**: Hive-based local cache for offline access and performance
- **Infinite Scroll Pagination**: Load more profiles as user scrolls
- **Business Directory**: View professional profiles with contact info
- **Admin Center Mode**: Special view for administrators to manage all users
- **WhatsApp Integration**: Direct contact via WhatsApp with pre-filled messages
- **Image Gallery Slider**: Browse facility photos with indicators

## Installation

```yaml
dependencies:
  neom_directory:
    git:
      url: git@github.com:Cyberneom/neom_directory.git
```

## Usage

```dart
import 'package:neom_directory/directory_routes.dart';

// Navigate to business directory
Navigator.pushNamed(context, AppRouteConstants.directory);

// Navigate to admin center (with arguments)
Navigator.pushNamed(
  context,
  AppRouteConstants.directory,
  arguments: [true], // isAdminCenter = true
);
```

---

## ROADMAP 2026: Local Discovery Platform

Our vision is to create a **comprehensive local discovery platform** that connects users with professionals, businesses, and services in their community.

### Q1 2026: Enhanced Discovery

#### Search & Filters
- [ ] **Full-Text Search** - Search profiles by name, skills, description
- [ ] **Advanced Filters** - Price range, availability, ratings
- [ ] **Category System** - Hierarchical service categories
- [ ] **Tag-Based Discovery** - Find by hashtags and keywords
- [ ] **Recent Searches** - Search history with quick access

#### Location Features
- [ ] **Map View** - Visual map with profile pins
- [ ] **Radius Control** - Adjustable search distance
- [ ] **Neighborhood Discovery** - Browse by area/zone
- [ ] **Route Integration** - Distance and travel time estimates
- [ ] **Favorite Locations** - Save frequent search areas

### Q2 2026: Profile Enhancement

#### Rich Profiles
- [ ] **Service Catalog** - List of offered services with prices
- [ ] **Portfolio Gallery** - Showcase work samples
- [ ] **Availability Calendar** - Show open time slots
- [ ] **Verified Badge** - Trust indicators for verified professionals
- [ ] **Response Time** - Average response metrics

#### Reviews & Ratings
- [ ] **Star Ratings** - 5-star rating system
- [ ] **Written Reviews** - Detailed user feedback
- [ ] **Photo Reviews** - Reviews with images
- [ ] **Review Responses** - Professional can respond
- [ ] **Rating Breakdown** - By category (quality, punctuality, etc.)

### Q3 2026: Booking & Communication

#### Appointment System
- [ ] **Request Quotes** - Send service inquiries
- [ ] **Booking Flow** - Schedule appointments in-app
- [ ] **Calendar Sync** - Integrate with device calendar
- [ ] **Reminders** - Push notifications for appointments
- [ ] **Cancellation Policy** - Configurable cancellation rules

#### Communication
- [ ] **In-App Chat** - Message professionals directly
- [ ] **Quick Replies** - Pre-defined response templates
- [ ] **File Sharing** - Send documents and images
- [ ] **Voice Notes** - Audio message support
- [ ] **Read Receipts** - Message delivery status

### Q4 2026: AI & Analytics

#### Smart Recommendations
- [ ] **Personalized Suggestions** - AI-based profile recommendations
- [ ] **Similar Profiles** - "You might also like" feature
- [ ] **Trending in Area** - Popular professionals nearby
- [ ] **Seasonal Recommendations** - Context-aware suggestions

#### Business Analytics (Pro)
- [ ] **Profile Views** - Track visibility metrics
- [ ] **Contact Rate** - Measure engagement
- [ ] **Peak Hours** - Best times for visibility
- [ ] **Competitor Analysis** - Market positioning insights
- [ ] **Revenue Tracking** - Business performance dashboard

---

## Architecture

```
lib/
├── domain/
│   └── use_cases/
│       └── directory_service.dart      # Service interface
├── ui/
│   ├── directory_controller.dart       # Business logic & state
│   ├── directory_page.dart             # Main directory view
│   └── widgets/
│       └── directory_profile_card.dart # Profile card component
├── utils/
│   └── constants/
│       └── directory_translation_constants.dart
└── directory_routes.dart               # Route definitions
```

## Dependencies

- `neom_core` - Core services, models, and Firestore integration
- `neom_commons` - Shared UI components and utilities
- `geolocator` - Device location services (via neom_core)
- `hive_flutter` - Local caching (via neom_core)

## Key Components

### DirectoryController
- Manages profile fetching with geolocation
- Handles infinite scroll pagination
- Implements local filtering by profile type
- Caches results in Hive for performance

### DirectoryProfileCard
- Displays profile with image gallery
- Shows distance from user
- WhatsApp contact integration
- Facility information display

## License

Apache License 2.0 - see [LICENSE](LICENSE) for details.

---

**Open Neom** - Connecting communities through local discovery.
