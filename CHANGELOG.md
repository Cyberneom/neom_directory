### 1.3.0 - Code Quality & Linter Compliance

This release focuses on code quality improvements and alignment with latest linting standards.

**Key Changes:**

**Code Quality:**
- Fixed import ordering across all files (directives_ordering)
- Updated to flutter_lints ^6.0.0 for latest lint rules
- SDK constraint updated to >=3.8.0 <4.0.0

**Architecture:**
- `DirectoryService` interface prepared for future repository pattern
- `DirectoryController` implements clean separation of concerns
- Profile type filtering with local cache optimization

**Documentation:**
- Comprehensive README.md with ROADMAP 2026
- Added architecture overview and component documentation

---

### 1.2.0 - Profile Type Filtering & Admin Center

**Features:**
- Added profile type filter modal
- Multi-select filtering (artist, host, band, facilitator, etc.)
- Admin Center mode for user management
- Improved caching strategy with date-based invalidation

**UI Improvements:**
- Filter toggle button in AppBar
- Checkbox list for profile type selection
- Applied filters counter display

---

### 1.1.0 - Geolocation & Pagination

**Features:**
- Geolocation-based profile sorting
- Infinite scroll pagination
- Distance display in profile cards
- Smart caching with Hive

**Technical:**
- ScrollController listener for pagination
- Position-based Firestore queries
- Local cache with JSON serialization

---

### 1.0.0 - Initial Release

**Core Features:**
- Business directory page
- Profile card with image gallery
- WhatsApp contact integration
- Basic Firestore integration

**Architecture:**
- DirectoryController with Sint state management
- DirectoryProfileCard widget
- Route configuration for navigation
