# Restaurant Finder
A Flutter mobile app mockup for the Just Eat Takeaway.com coding assignment.

## How to Run
1. Install Flutter (see [official docs](https://flutter.dev/docs/get-started/install)).
2. Clone this repo: `git clone <your-repo-url>`.
3. Navigate to the folder: `cd restaurant_finder`.
4. Install dependencies: `flutter pub get`.
5. Launch an emulator: `flutter emulators --launch <emulator-id>`.
6. Run the app: `flutter run`.

## Assumptions
- Hardcoded postcode "SW1A1AA" for simplicity.
- Used `address.firstLine` for the address field; Next step: expand to include city/postcode.
- Assumed `cuisines` contains relevant names despite some being tags (e.g., "Deals").

## Implementations
This Flutter app fetches restaurant data from the Just Eat Takeaway.com API and displays the first 10 restaurants in a mobile-friendly interface. Below are the key implementation details:

### Project Structure
- **`lib/main.dart`**: Entry point, sets up the app with a Material theme and launches `HomeScreen`.
- **`lib/models/restaurant.dart`**: Defines the `Restaurant` class to model the API data.
- **`lib/models/address.dart`**: Models the `address` object with `city`, `firstLine`, `postalCode`, and `location`.
- **`lib/models/location.dart`**: Models the nested `location` with `type` and `coordinates`.
- **`lib/models/rating.dart`**: Models the `rating` object with `count`, `starRating`, and `userRating`.
- **`lib/services/api_service.dart`**: Handles API requests and returns a list of `Restaurant` objects.
- **`lib/screens/home_screen.dart`**: Renders the UI using a `ListView` of `Card` widgets.

### API Integration
- **Endpoint**: The app uses `https://uk.api.just-eat.io/discovery/uk/restaurants/enriched/bypostcode/EC4M7RF` to fetch data.
- **HTTP Client**: The `http` package (version 0.13.5) is used to make GET requests.
- **Parsing**: The JSON response is decoded, and the `restaurants` array is limited to the first 10 entries using `.take(10)`.

### Data Parsing in `Restaurant` Model
The `Restaurant` class uses `json_annotation` and `json_serializable`:
- **Dependencies**: `json_annotation: ^4.8.1`, `json_serializable: ^6.7.1`, `build_runner: ^2.4.6`.
- **Code Generation**: Run `flutter pub run build_runner build --delete-conflicting-outputs`.
- **Fields**:
  - `name`: Direct mapping with a default.
  - `cuisines`: Custom parsing extracts `name` from each cuisine object.
  - `rating`: Nested `Rating` object parsed automatically.
  - `address`: Nested `Address` object parsed automatically.

- **Rating**
**Model**: `Rating` class with `count` (int), `starRating` (double), and `userRating` (nullable double).
**Parsing**: Handled by `json_serializable` via `Rating.fromJson`.
**Display**: Uses `starRating` in the UI as the numeric rating required by the assignment.

- **Address**:  Taken from `json['address']['firstLine']` (e.g., "62 Upper Street"). Defaults to "No address available" if absent.
  ```dart
  address: json['address']?['firstLine'] ?? 'No address available',
  ```
1. Create Location model strong the coordinates fetched from API, and toGeoPoint() function which returns the cloud_firestore GeoPoint type from Firebase
2. Added a GeoUtil file to calculate the distance  between two geographical points using the Haversine formula

### UI Design
- Widget Choice: A FutureBuilder manages the asynchronous API call, displaying a loading spinner, error message, or the restaurant list based on the state.
- Restaurant Display: Each restaurant is shown in a Card widget with:
name in bold as the title.
address, rating, and cuisines listed vertically below.
cuisines joined into a comma-separated string (e.g., "Burgers, Chicken, Halal").
- Styling: Basic padding and font adjustments ensure a clean, readable layout.

### Error Handling
- Checks for HTTP status codes (e.g., 200 OK) and throws exceptions for failures.
- Uses null-safe operators (?., ??) to handle missing or null fields gracefully.

### Key Decisions
- Nested Models: Added `Address`, `Location`, and `Rating` models for better structure and reusability.
- Hardcoded Postcode: Chose "SW1A1AA" to focus on displaying data rather than building an input system, per the assignment’s emphasis on presentation.
- Minimal Dependencies: Only added http to keep the app lightweight.
- Card Layout: Opted for Card over ListTile for a more modern, mobile-app aesthetic.

## Improvements
- [x] Add a text field for user-input postcodes and fetch the corresponding location.
- [ ] Enhance UI with colors or icons (e.g., star for rating).
- Handle edge cases like missing data more gracefully.
- Add GeoPoint for location, and ask and get user's location permission for calculating the distances.
- Add an avatar
- Create features branch and go through pull-request procedures.
- 