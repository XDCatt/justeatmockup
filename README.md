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
- **`lib/services/api_service.dart`**: Handles API requests and returns a list of `Restaurant` objects.
- **`lib/screens/home_screen.dart`**: Renders the UI using a `ListView` of `Card` widgets.

### API Integration
- **Endpoint**: The app uses `https://uk.api.just-eat.io/discovery/uk/restaurants/enriched/bypostcode/EC4M7RF` to fetch data.
- **HTTP Client**: The `http` package (version 0.13.5) is used to make GET requests.
- **Parsing**: The JSON response is decoded, and the `restaurants` array is limited to the first 10 entries using `.take(10)`.

### Data Parsing in `Restaurant` Model
The `Restaurant` class parses the required fields from the API response into a structured Dart object:
- **Name**: Extracted from `json['name']` (e.g., "Chicken Shop - Upper Street"). Defaults to "Unknown Restaurant" if missing.
- **Cuisines**: Parsed from `json['cuisines']`, an array of objects. Each object's `name` field (e.g., "Burgers", "Chicken") is mapped to a `List<String>`. Defaults to an empty list if null.
  ```dart
  cuisines: (json['cuisines'] as List<dynamic>?)
      ?.map((cuisine) => cuisine['name'] as String)
      .toList() ?? [],

- **Rating**: Source: Retrieved from `json['rating']['starRating']` (e.g., 4.2) as a number, cast to `double`.
Parsing: Uses null-safe access and defaults to 0.0 if missing.
Display: Shown as "Rating: 4.2" in the UI, meeting the assignment’s requirement for a numeric value.
  ```dart
  rating: (json['rating']?['starRating'] as num?)?.toDouble() ?? 0.0,
  ```

- **Address**:  Taken from `json['address']['firstLine']` (e.g., "62 Upper Street"). Defaults to "No address available" if absent.
  ```dart
  address: json['address']?['firstLine'] ?? 'No address available',
  ```

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