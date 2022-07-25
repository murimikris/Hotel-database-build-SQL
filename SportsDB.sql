
create table members(
id varchar(255),
password varchar(255) NOT NULL,
email varchar(255) NOT NULL,
member_since timestamp NOT NULL default now(),
payment_due decimal (6,2) not null default 0
);

alter table members
add primary key (id);

create table pending_terminations(
id varchar(255),
email varchar(255) not null,
request_date timestamp not null default now(),
payment_due decimal (6,2) not null default 0
);
use sports_bookings;

create table rooms(
id varchar(255) unique primary key,
room_type varchar(255) not null,
price decimal (6,2) not null
);

alter table pending_terminations
add primary key (id);

create table bookings(
id int auto_increment primary key,
room_id varchar(255) not null,
booked_date date not null,
booked_time time not null,
member_id varchar(255) not null,
datetime_of_booking timestamp not null default now(),
payment_status varchar(255) not null default 'Unpaid',
constraint uc1 unique (room_id, booked_date, booked_time)
);

alter table bookings
add constraint fk1
foreign key (member_id) references members(id)
on delete cascade on update cascade;

alter table bookings
add constraint fk2
foreign key (room_id) references rooms(id) on delete cascade on update cascade;

use sports_bookings;


insert into members (id, password, email, member_since, payment_due)
values 
('afeil', 'feil1998<3','abdulfeil@hotmail.com', '2017-04-15 12:10:13', '0.00'),
('amely_18','ameliyouyn','amely.bauch91@yahoo.com', '2018-02-06 16:48:43', '0.00'),
('bba_hringer', 'iambeauhringer','bealuha@yahoo.com','2017-12-28 05:36:50','0.00'),
('little31','whocares','anthony_little31@yahoo.com','2017-06-01 21:12:11','10.00'),
('macejkovic73','jkovic73maces','jadamace73@gmail.com','27-05-30 17:30:22','0.00'),
('marvin1','snadnaksn','marvin_schulist@gmail.com','2017-09-09 02:30:49','0.00'),
('ritsche3','brett77@#','bret_nitsche77@gmail.com','2018-01-09 17:36:49','0.00'),
('noah51','wpod4^j68','noah51@gmail.com','2017-12-16 22:59:46','0.00'),
('oriellys','reallycool#1','Martine_orielly@yahoo.com','2017-10-12 05:39:20','0.00'),
('wyattgreat1','wyatt1111','wyat_yzowszk2@gmail.com','2017-07-18 16:28:35','0.00');

insert into rooms(id, room_type, price)
values
('AR','Archery Range','120.00'),
('B1','Badminton Court','8.00'),
('B2','Badminton Court','8.00'),
('MPF1','Multi Purpose Field','50.00'),
('MPF2','Multi Purpose Field','50.00'),
('T1','Tennis Court','10.00'),
('T2','Tennis Court','10.00');

insert into bookings(id, room_id, booked_date,  booked_time, member_id, datetime_of_booking, payment_status)
values
(1, 'AR', '2017-12-26', '13:00:00', 'oriellys', '2017-12-20 20:31:27', 'Paid'),
(2, 'MPF1', '2017-12-30', '17:00:00', 'noah51', '2017-12-22 05:22:10', 'Paid'),
(3, 'T2', '2017-12-31', '16:00:00', 'macejkovic73', '2017-12-28 18:14:23', 'Paid'),
(4, 'T1', '2018-03-05', '08:00:00', 'little31', '2018-02-22 20:19:17', 'Unpaid'),
(5, 'MPF2', '2018-03-02', '11:00:00', 'marvin1', '2018-03-01 16:13:45', 'Paid'),
(6, 'B1', '2018-03-28', '16:00:00', 'marvin1', '2018-03-23 22:46:36', 'Paid'),
(7, 'B1', '2018-04-15', '14:00:00', 'macejkovic73', '2018-04-12 22:23:20', 'Cancelled'),
(8, 'T2', '2018-04-23', '13:00:00', 'macejkovic73', '2018-04-19 10:49:00', 'Cancelled'),
(9, 'T1', '2018-05-25', '10:00:00', 'marvin1', '2018-05-21 11:20:46', 'Unpaid'),
(10, 'B2', '2018-06-12', '15:00:00', 'bba_hringer', '2018-05-30 14:40:23', 'Paid');


#create a view that shows booking details of a booking
create view member_bookings as
select bookings.id, room_id, room_type, booked_date, booked_time, member_id, datetime_of_booking, price, payment_status
from bookings join rooms
on bookings.room_id = rooms.id
order by bookings.id;

use sports_bookings;

#create procedures for the database.
DELIMITER $$
#INSERT NEW NUMBER
create procedure insert_new_number (in p_id varchar(255),in p_password varchar(255), in p_email varchar(255))
begin 
	insert into members(id, password, email) values (p_id, p_password, p_email);
end $$

#delete number
create procedure delete_number (in p_id varchar(255))
begin
	delete from members where id = p_id;
end $$

#update passwords
create procedure update_member_password (in p_id varchar(255), in p_password varchar(255))
begin
	update members set password = p_password where id = p_id;
end$$

#update emails
create procedure update_member_email (in p_id varchar(255), in p_email varchar(255))
begin
	update members set email = p_email where id = p_id;
end $$

# boooking procedure
create procedure make_booking (in p_room_id varchar(255), in p_booked_date date, in p_booked_time timestamp, p_member_id varchar(255))
begin
	declare v_price decimal(6, 2);
    declare v_payment_due decimal(6, 2);
    select price into v_price from rooms where id = p_room_id;
    insert into bookings(room_id, booked_date, booked_time, member_id) values(p_room_id, p_booked_date, p_booked_time, p_member_id);
    select payment_due into v_payment_due from members where id = p_member_id;
    update members set payment_due = payment_due + v_payment_due where id = p_member_id;
    end$$

#update payments
create procedure update_payments (in p_id varchar(255))
begin
	declare v_member_id varchar(255);
    declare v_payment_due decimal(6, 2);
    declare v_price decimal(6,2);
    update bookings set payment_status = 'Paid' where id = p_id;
    select member_id, price into v_member_id, v_price from member_bookings where id = p_id;
    select payment_due into v_payment_due from members where id = v_member_id;
    update members set payment_due = v_payment_due - v_price where id = v_member_id;
end $$

# view bookings
create procedure view_bookings (in p_id varchar(255))
begin
	select * from member_bookings where id = p_id;
end $$

use sports_bookings

# search room
delimiter $$

create procedure search_room (in p_room_type varchar(255), p_booked_date date, p_booked_time time)
begin
	select *
    from rooms
    where id not in (select room_id from bookings where booked_date = p_booked_date and booked_time= p_booked_time and payment_status != 'Cancelled') and room_type = p_room_type;
    end $$
    
#cancel booking
create procedure cancel_booking (in p_booking_id int, out p_message varchar(255))
begin
	DECLARE v_cancellation INT;
	DECLARE v_member_id VARCHAR(255);
	DECLARE v_payment_status VARCHAR(255);
	DECLARE v_booked_date DATE;
	DECLARE v_price DECIMAL(6, 2);
	DECLARE v_payment_due VARCHAR(255);
    
    SET v_cancellation= 0;
    
    SELECT member_id, booked_date, price, payment_status 
    INTO v_member_id, v_booked_date, v_price, v_payment_status 
    FROM member_bookings 
    WHERE id = p_booking_id;

	SELECT payment_due 
    INTO v_payment_due 
    FROM members 
    WHERE id= v_member_id;
    
    IF curdate() >= v_booked_date 
    THEN SELECT 'Cancellation cannot be done on/after the booked date' INTO p_message;
    ELSEIF v_payment_status = 'Cancelled' OR v_payment_status = 'Paid'
    THEN
	SELECT 'Booking has already been cancelled or paid' INTO p_message;
    ELSE
		UPDATE bookings SET payment_status = 'Cancelled' WHERE id = p_booking_id;
        SET v_payment_due = v_payment_due - v_price;
        SET v_cancellation = check_cancellation(p_booking_id);
			IF v_cancellation >= 2 THEN SET v_payment_due = v_payment_due + 10;
            END IF;
		UPDATE members SET payment_due = v_payment_due WHERE id = v_member_id;
        SELECT 'Booking Cancelled' INTO p_message;
        END IF;
end $$


# Triggers
# payment check

create trigger payment_check before delete on members for each row
begin
	DECLARE v_payment_due DECIMAL(6, 2);
    SELECT payment_due INTO v_payment_due FROM members WHERE id = OLD.id;
    IF v_payment_due > 0 THEN
		INSERT INTO pending_terminations (id, email, payment_due)
        VALUES (OLD.id, OLD.email, OLD.payment_due);
	END IF;
end $$

# create a function that checks cancellations against member id

create function check_cancellation (p_booking_id int) returns int deterministic
begin
	DECLARE v_done INT;
    DECLARE v_cancellation INT;
    DECLARE v_current_payment_status VARCHAR(255);
    DECLARE cur CURSOR FOR
		SELECT payment_status FROM bookings 
        WHERE member_id= (select member_id from bookings where id = p_booking_id)
        ORDER BY datetime_of_booking DESC;
		DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done = 1;
	SET v_done = 0;
	SET v_cancellation = 0;
    OPEN cur;
    
    cancellation_loop : LOOP
    FETCH cur INTO v_current_payment_status;
    IF v_current_payment_status != 'Cancelled' OR v_done = 1
		THEN LEAVE cancellation_loop;
    ELSE SET v_cancellation = v_cancellation + 1;
    END IF;
    END LOOP;
    CLOSE cur;
    RETURN v_cancellation;
end $$

DELIMITER ;

        
        
        


    


	