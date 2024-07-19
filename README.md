# Hotel Database Build: Sports Facility Booking System

## Project Overview
This project implements an SQL database system for managing bookings at a sports complex. The complex features 2 tennis courts, 2 badminton courts, 2 multi-purpose fields, and 1 archery range. Each facility can be booked for one hour, and only registered users are allowed to make bookings.

The system handles the entire booking process, including member management, room booking, payment tracking, and a cancellation policy with potential penalties.

## Key Features
- Member registration and management
- Facility booking system
- Payment tracking
- Booking cancellation with a penalty system for frequent cancellations
- Automated member termination handling for outstanding payments

## Cancellation Policy
Users can cancel their bookings up to the day before the booked date without charge. However, if it's the third (or more) consecutive cancellation, the complex imposes a $10 fine.

## Database Structure

### Tables
1. `members`: Stores member information
2. `pending_terminations`: Tracks members with outstanding payments during termination
3. `rooms`: Contains information about available facilities
4. `bookings`: Manages booking details

### Views
- `member_bookings`: Provides a sanitized view of booking details, excluding sensitive information

### Stored Procedures
1. `insert_new_member`: Register a new member
2. `delete_member`: Remove a member
3. `update_member_password`: Change a member's password
4. `update_member_email`: Update a member's email
5. `make_booking`: Create a new booking
6. `update_payment`: Process payments for bookings
7. `view_bookings`: Retrieve booking details
8. `search_room`: Find available rooms
9. `cancel_booking`: Cancel a booking with potential penalties

### Triggers
- `payment_check`: Handles member deletion and outstanding payments

### Stored Functions
- `check_cancellation`: Tracks repeated cancellations by a member

## Usage
To use this system:
1. Set up the database using the provided SQL scripts
2. Use the stored procedures to interact with the system (e.g., `CALL insert_new_member('john_doe', 'password123', 'john@example.com');`)
3. Queries can be run directly on the tables or through the `member_bookings` view for safer access

## Security Considerations
- Passwords are stored in plaintext in this example. In a production environment, implement proper password hashing.
- The `member_bookings` view helps protect sensitive information by excluding password data.

## Future Enhancements
- Implement more robust error handling
- Add reporting features for facility usage and revenue
- Integrate with a front-end application for user-friendly access
- Implement proper password hashing for improved security
- Create a simple front-end interface to interact with the database
- Include performance optimization techniques, like indexing strategies
- Add unit tests for the stored procedures
