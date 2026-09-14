# BookNest – Online Bookstore Mobile Application

BookNest is a Flutter-based online bookstore mobile application developed for the Mobile and Web Technologies module. The application demonstrates role-based functionality, Google Books API integration, shopping cart management, checkout, order processing, validation, and error handling.

## Features

### Customer
- Register a new customer account
- Login using customer credentials
- Browse books
- Search books by title or keyword
- View book details including title, author, category, description and price
- Add books to the shopping cart
- Remove books from the cart
- View total price
- Enter delivery information
- Place an order
- Receive order confirmation

### Store Staff
- Login using staff credentials
- View customer orders
- View order information
- Update order status to Pending, Processing or Completed

### Administrator
- Login using administrator credentials
- View system overview
- View registered users
- View customer orders
- View application role information

## Technologies Used

- Flutter
- Dart
- Android
- Google Books API
- HTTP package
- JSON
- Android Studio
- Git and GitHub

## Application Architecture

BookNest uses a frontend-focused Flutter architecture.

The Google Books API provides external book information through HTTP requests. JSON responses are converted into Book model objects and displayed in the Flutter user interface.

Customer accounts, shopping cart items and orders are stored temporarily using in-memory application state for prototype demonstration purposes. No custom backend or persistent database is used.

## Demo Accounts

### Customer
Email: `customer@booknest.com`  
Password: `123456`

### Store Staff
Email: `staff@booknest.com`  
Password: `123456`

### Administrator
Email: `admin@booknest.com`  
Password: `123456`

## Google Books API Configuration

A Google Books API key is required to retrieve book information.

For security reasons, the API key is not stored in this repository.

Run the application using:

```bash
flutter run --dart-define=GOOGLE_BOOKS_API_KEY=YOUR_API_KEY
