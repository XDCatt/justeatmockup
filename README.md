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

## Improvements
- Add a text field for user-input postcodes.
- Enhance UI with colors or icons (e.g., star for rating).
- Handle edge cases like missing data more gracefully.
- Add GeoPoint for location, and ask and get user's location permission for calculating the distances.