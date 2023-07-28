# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version
    ruby 2.7.1
* System dependencies
    Postgres
    Ruby on Rails setup

# App Overview
## Introduction
```
The app is a beer dispenser management system that allows users to create, manage, and monitor beer dispensers. It provides different roles, such as admin, attendee, and promoter, each with specific permissions and access to different functionalities.
```
## Roles
### Admin: 
```
Admin users have full access to the system. They can create, update, and delete dispensers, as well as manage user roles.
```
### Attendee: 
```
Attendee users have limited access.open and close taps by updating dispenser status, but cannot create or delete dispensers.
```
### Promoter: 
```
Promoter users can view total statistics, including total earnings and usage time, for all dispensers.
```
### API Endpoints
```
    /users: Allows users to register and manage their accounts.
    /dispensers: Allows users to view, create, update, and delete dispensers.
    /dispensers/:id: Allows users to view a specific dispenser by its ID.
    /dispensers/:id: Allows users to update the tap status of a dispenser.
    /dispensers/:id: Allows users to delete a dispenser.
    /dispensers/total_statistics: Allows promoters to view total statistics for all dispensers.
```
## Models
### User: 
```
Represents a user of the system. It has attributes such as name, email, password, and role.
```
### Dispenser:
```
Represents a beer dispenser. It has attributes like name, flow volume, status, and price per liter.
```
### DispenserEvent: 
```
Represents events related to a dispenser, such as tap open and tap close. It has attributes like start time, end time, event type, total liters, and total price.
```
### Services
```
DispenserService: Provides functionality to manage dispenser tap events. It includes methods to mark the tap as open and close, calculate total liters, and calculate total earnings.
```
### Controllers

#### UsersController: 
```
Handles user registration, login, and account management.
```
#### DispensersController: 
```
Handles dispenser-related operations, such as viewing, creating, updating, and deleting dispensers. It also provides methods to update dispenser tap status and view total statistics.
```
### Data Storage
```
The app uses a relational database (e.g., PostgreSQL) to store user and dispenser data. Data is stored in tables corresponding to the User, Dispenser, and DispenserEvent models.
```
### Authentication
```
The app uses JSON Web Tokens (JWT) for authentication. Users must include a valid JWT token in the request headers to access protected endpoints.
```

### Testing
```
The app includes test cases using RSpec to ensure the correctness of models, controllers, and services.
```