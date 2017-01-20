# Photostream

A photo sharing app that uses Firebase.

## How To Make It Work?

1. Clone this repo or download source code.
2. Do `$ pod install`. (_install cocoapods first if not installed_)
3. Create a new project in your Firebase console.
4. Set the database rules to: 
```
{
    "rules": {
        ".read": "auth != null",
        ".write": "auth != null",
        "users": {
          "$user_id": {
            ".indexOn": ["username", "id", "email"]
          },
          ".indexOn": ["username", "id", "email"]
        }
    }
}
```
5. Enable `Email/Password` sign-in method.
6. Download the `GoogleService-Info.plist` file.
7. Put the file into the root of the project folder.
8. Open `Photostream.xcworkspace` and add the file into the `Photostream` project.
9. Modify the bundle identifier and display name.
10. There you go, build and run the app. :)
