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

## Screenshots
||||
|---|---|---|
|![Login] (https://raw.github.com/mownier/photostream/master/Screenshots/Login.png)|![Registration] (https://raw.github.com/mownier/photostream/master/Screenshots/Registration.png)|![News Feed] (https://raw.github.com/mownier/photostream/master/Screenshots/News%20Feed.png)|
|![Profile Edit] (https://raw.github.com/mownier/photostream/master/Screenshots/Edit%20Profile.png)|![Settings] (https://raw.github.com/mownier/photostream/master/Screenshots/Settings.png)|![Photo Picker] (https://raw.github.com/mownier/photostream/master/Screenshots/Photo%20Picker.png)|
|![Photo Share] (https://raw.github.com/mownier/photostream/master/Screenshots/Photo%20Share.png)|![Post Upload] (https://raw.github.com/mownier/photostream/master/Screenshots/Post%20Upload.png)|![Comment Controller] (https://raw.github.com/mownier/photostream/master/Screenshots/Comment%20Controller.png)|
