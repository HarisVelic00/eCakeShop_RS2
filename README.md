# eCakeShop_RS2
The eCakeShop project is a comprehensive software solution that caters to both clients and administrators in a cake shop setting. The project encompasses a mobile app for clients and a Windows forms application for administration.
## Login Credentials - Desktop App
- Administrator Login
```
Username: admin
Password: admin
```
- Employee Login
```
Username: uposlenik
Password: uposlenik

Username: uposlenik2
Password: uposlenik2
```
## Login Credentials - Mobile App
- User Login
```
Username: user
Password: user

Username: user2
Password: user2
```
- Payment Card Number
```
4242 4242 4242 4242
CVC: 123
```
## Running the Applications
1.  Clone the repository
```
  https://github.com/HarisVelic00/eCakeShop_RS2.git
```
2. Open the cloned repository in the console
3. Start the Dockerized API and DB
```
  docker-compose build
  docker-compose up
```
4. Running the desktop application through Visual Studio Code

- Open the eCakeShop folder

- Open the UI folder

- Choose the ecakeshop_admin folder
f
- Fetch dependencies
```
  flutter pub get
```
 Run the desktop application with the command 
```
 flutter run -d windows
```
 
5. Running the mobile application through Visual Studio Code

- Open the eCakeShop folder

-  Open the UI folder
  
- Choose the ecakeshop_mobile folder
 
- Fetch dependencies
```
  flutter pub get
```
- Start the mobile emulator

- Run the mobile application without debugging CTRL + F5

6. Running RabbitMQ through Visual Studio
- Choose eCakeShop.Subscriber as the startup project and run it.