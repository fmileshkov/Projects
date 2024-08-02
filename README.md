MovieCave

MovieCave is an iOS application designed to provide a seamless and enjoyable experience for browsing and discovering movies. Utilizing The Movie Database (TMDb) API, this app delivers up-to-date information on the latest movies, popular films, and detailed movie data including cast, crew, and reviews.

Features:

Browse Movies: Explore the latest, popular, and top-rated movies with ease.
Movie Details: Get comprehensive information on any selected movie, including synopsis, ratings, cast, and crew.
Search Functionality: Find movies by title using the robust search feature.

Technical Details
Architecture

MVVM (Model-View-ViewModel): Ensures a clean separation of concerns, making the app more maintainable and testable.
Coordinators: Manages the navigation flow within the app, making it more modular and scalable.

Frameworks & Patterns
UIKit: All custom UI elements are created using UIKit to provide a native look and feel.
Combine Framework: Handles asynchronous events and data binding between the ViewModel and the View.
Protocol and Delegate Patterns: Facilitates communication between different parts of the app, ensuring a decoupled and flexible design.
