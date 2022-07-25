# Hotel-database-build-SQL

This project requires us to build a simple database to help us manage the
booking process of a sports complex. The sports complex has the following
facilities: 2 tennis courts, 2 badminton courts, 2 multi-purpose fields and 1
archery range.

Each facility can be booked for a duration of one hour.
Only registered users are allowed to make a booking. After booking, the
complex allows users to cancel their bookings latest by the day prior to the
booked date. Cancellation is free. However, if this is the third (or more)
consecutive cancellations, the complex imposes a $10 fine.


The database that we build should have the following elements:

### Tables

1. members

2. pending_terminations

3. rooms

4. bookings

### View

member_bookings

### Stored Procedures

1. insert_new_member

2. delete_member

3. update_member_password

4. update_member_email

5. make_booking

6. update_payment

7. view_bookings

8. search_room

9. cancel_booking

### Trigger

1. payment_check

### Stored Function

1. check_cancellation
