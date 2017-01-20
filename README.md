# Photostream

A photo sharing app that uses Firebase.

## How To Make It Work?

- Clone this repo or download source code.
- Do `$ pod install`. (_install cocoapods first if not installed_)
- Create a new project in your Firebase console.
- Set the database rules to: 
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
- Enable `Email/Password` sign-in method.
- Download the `GoogleService-Info.plist` file.
- Put the file into the root of the project folder.
- Open `Photostream.xcworkspace` and add the file into the `Photostream` project.
- Modify the bundle identifier and display name.
- There you go, build and run the app. :)
