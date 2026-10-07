create database hotel_reservation_analytics;

USE hotel_reservation_analytics; 


SELECT DATABASE();
CREATE TABLE hotels (
    hotel_id VARCHAR(10) PRIMARY KEY,
    hotel_name VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    star_rating INT,
    total_rooms INT,
    opened_date DATE
);
select * from hotels;
show tables;
CREATE TABLE guests (
    guest_id VARCHAR(10) PRIMARY KEY,
    guest_name VARCHAR(100) NOT NULL,
    city VARCHAR(50),
    guest_type VARCHAR(30),
    preferred_room_type VARCHAR(50),
    loyalty_tier VARCHAR(30),
    account_since DATE
);
select * from guests;  
CREATE TABLE staff (
    staff_id VARCHAR(10) PRIMARY KEY,
    staff_name VARCHAR(100) NOT NULL,
    hire_date DATE,
    rating DECIMAL(3,2),
    department VARCHAR(50),
    is_active VARCHAR(10)
);

select * from staff;
CREATE TABLE rooms (
    room_id VARCHAR(10) PRIMARY KEY,
    hotel_id VARCHAR(10) NOT NULL,
    room_type VARCHAR(50),
    floor_number INT,
    max_occupancy INT,
    price_per_night DECIMAL(10,2),
    is_active VARCHAR(10),
    

    FOREIGN KEY (hotel_id)
        REFERENCES hotels(hotel_id)
);
select * from rooms;
CREATE TABLE bookings (
    booking_id VARCHAR(10) PRIMARY KEY,
    guest_id VARCHAR(10) NOT NULL,
    hotel_id VARCHAR(10) NOT NULL,
    booking_date DATE,
    room_type_requested VARCHAR(50),
    booking_channel VARCHAR(50),
    nights_booked INT,
    total_amount DECIMAL(12,2),

    FOREIGN KEY (guest_id)
        REFERENCES guests(guest_id),

    FOREIGN KEY (hotel_id)
        REFERENCES hotels(hotel_id)
);

select * from bookings;

CREATE TABLE stays (
    stay_id VARCHAR(10) PRIMARY KEY,
    booking_id VARCHAR(10) NOT NULL,
    room_id VARCHAR(10) NOT NULL,
    staff_id VARCHAR(10) NOT NULL,
    check_in_date DATE,
    check_out_date DATE,
    status VARCHAR(30),
    nights_stayed INT,
    service_requests INT,
    stay_duration_hrs INT,

    FOREIGN KEY (booking_id)
        REFERENCES bookings(booking_id),

    FOREIGN KEY (room_id)
        REFERENCES rooms(room_id),

    FOREIGN KEY (staff_id)
        REFERENCES staff(staff_id)
);
select* from stays;

describe bookings;
describe guests;
describe hotels;
describe rooms;
describe staff;
describe stays;

-- //-----------------------------------------------------------------------------------------------------------------------------------------------------------------/

-- Sprint 3 -- Basic Data Analysis

-- Total number of guests
SELECT COUNT(*) AS total_guests FROM guests;

-- Total number of booking
SELECT COUNT(*) AS total_booking FROM bookings;

-- Total number of stays
SELECT COUNT(*) AS total_stays FROM stays;

-- Different rooms types
SELECT * from rooms;
SELECT DISTINCT Room_Type FROM rooms;

-- Number of active staff
SELECT * from staff;
SELECT COUNT(*) as active_staff FROM staff where is_active="yes";

-- Total booking count
SELECT * from bookingS;
SELECT SUM(total_amount) as total_booking_count from bookings;

-- Average nights booked
SELECT *from bookings;
SELECT avg(nights_booked) as average_nights_booked from bookings;

-- // --------------------------------------------------------------------------------------------------------------------------------------------------------// 

-- Sprint 4 -- Objective 1

-- Which hotels receive the most bookings
select * from bookings;
select 
h.hotel_id,
h.hotel_name,
count(b.booking_id) as total_bookings from hotels h 
join bookings b 
on h.hotel_id = b.hotel_id
group by h.hotel_id , h.hotel_name order by total_bookings desc;

-- Which booking channels generate the most bookings
select * from bookings;
select 
booking_channel, count(*) as total_bookings
from bookings group by booking_channel order by total_bookings desc;

-- Which booking channel generate the highest revenue
select * from bookings;
select booking_channel, sum(total_amount) as total_revenue
from bookings group by booking_channel order by total_revenue desc;

-- Which room types are requested most frequently
select * from bookings;
select room_type_requested, count(*) as total_requests from bookings
group by room_type_requested order by total_requests desc; 

-- What is the averge booking amount by room type
select * from bookings;
select room_type_requested, avg (total_amount) as average_booking_amount from bookings
group by room_type_requested order by average_booking_amount desc;

-- What is the average number of nights by booking channel
select * from bookings;
select booking_channel, avg(nights_booked) as average_nights from bookings
group by booking_channel order by average_nights desc;

-- How does booking valume change by year
select * from bookings;
select year(booking_date) as booking_year, count(*) as total_bookings from bookings 
group by year(booking_date) order by total_bookings desc;

-- which hotels generate the highest booking revenue
select * from hotels;
select h.hotel_name, sum(b.total_amount) as total_revenue from hotels h
join bookings b on h.hotel_id=b.hotel_id group by hotel_name order by total_revenue desc;

-- / --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------/

-- OBJECTIVE 2- Guest Booking Behaviour

-- Which guests have made multiple bookings?
select g.guest_id,g.guest_name,count(b.booking_id) as total_booking from guests g
join bookings b on g.guest_id=b.guest_id
group by g.guest_id,g.guest_name
having count(b.booking_id)>1
order by total_booking desc;

-- Which guest have the highest total booking amount?
select * from guests;
select g.guest_id, g.guest_name, sum(b.total_amount) as total_spent from guests g
join bookings b on g.guest_id=b.guest_id group by g.guest_id,g.guest_name order by total_spent desc;

-- Compare individual vs Corporate guests
select * from guests;
select g.guest_type,count(distinct g.guest_id) as total_guests,
count(b.booking_id) as total_bookings,
sum(b.total_amount) as total_booking_amount,
avg(b.total_amount) as average_booking_amount from guests g 
left join bookings b on g.guest_id = b.guest_id group by g.guest_type;

-- Which hotels do guests book most frequently
select 
h.hotel_name, count(b.booking_id) as total_bookings from bookings b 
join hotels h on b.hotel_id = h.hotel_id group by h.hotel_name order by total_bookings desc;

-- How many bookings does each guest type make
select * from guests;
select 
g.guest_type, count(b.booking_id) as total_bookings from guests g 
join bookings b on g.guest_id = b.guest_id group by g.guest_type;

-- How many bookings does each guest type make
select g.guest_type, count(b.booking_id) as total_bookings from guests g 
join bookings b on g.guest_id = boguest_id group by g.guest_type;

--  What is the average number of nights by guest type
select g.guest_type, avg(b.nights_booked) as average_nights from guests g
join bookings b on g.guest_id = b.guest_id group by g.guest_type;

-- //------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\


-- OBJECTIVE 3 - Evaluate Stay Performance

-- How many stays are there for each staus
select * from stays;
select status, count(*) as total_stays from stays group by status order by total_stays desc;

-- What percentage of stays fail into each staus?
select * from stays;
select status, count(*) as total_stays, round(count(*) *100.0/(select count(*) from stays),2 ) as percentage from stays 
group by status order by percentage desc;

-- Compare stay outcomes across hotels
select h.hotel_name,s.status,count(*) as total_stays from stays s join bookings b 
on s.booking_id = b.booking_id 
join hotels h on b.hotel_id = h.hotel_id group by h.hotel_name, s.status order by h.hotel_name, total_stays desc;

-- Which hotels have the most cancelled stays?
select h.hotel_name,count(*) as cancelled_stays from stays s  join bookings b
on s.booking_id = b.booking_id
join hotels h on b.hotel_id = h.hotel_id where s.status ="cancelled" 
group by h.hotel_name order by cancelled_stays desc;

-- Which hotels have the most no-shows
select h.hotel_name, count(*) as no_show_stays
from stays s 
join bookings b on s.booking_id = b.booking_id
join hotels h on b.hotel_id = h.hotel_id where s.status = "No-show" group by h.hotel_name 
order by no_show_stays desc;

-- Average stay duration by status 
select status, avg(nights_stayed) as average_nights_stayed,
avg(stay_duration_hrs) as average_duration_hours from stays group by status;

-- Stay performance by booking channel
select b.booking_channel, s.status,
count(*) as total_stays from bookings b join stays s 
on b.booking_id = s.booking_id
group by b.booking_channel, s.status order by b.booking_channel, total_stays desc;

-- //-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//

-- Objective 4 - Staff and Room Performance

-- Which staff members handle the most stays?
select * from staff;
select st.staff_id, st.staff_name, count(s.stay_id) as total_stays_handled from staff st
join stays s  on st.staff_id = s.staff_id group by st.staff_id, st.staff_name order by total_stays_handled desc;

-- What is the average rating of staff by department
select department,avg(rating) as average_rating from staff group by department order by average_rating desc;

-- compare staff ratings with number of stays handled 
select 
st.staff_id,
st.staff_name, 
st.department,
st.rating,
count(s.stay_id) as stays_handled from staff st 
left join stays s 
on st.staff_id = s.staff_id
group by 
st.staff_id,
st.staff_name,
st.department,
st.rating
order by stays_handled desc;

-- Average stay duration handled by staff
select
st.staff_name,
count(s.stay_id) as total_stays,
avg(s.nights_stayed) as average_nights,
avg(s.stay_duration_hrs) as average_hours
from staff st
join stays s 
on st.staff_id = s.staff_id group by st.staff_name order by total_stays desc;

-- Which room types are used most 
select 
r.room_type,
count(s.stay_id) as total_stays
from rooms r join stays s 
on r.room_id = s.room_id 
group by r.room_type order by total_stays desc;

-- Which rooms are used most frequently
select 
r.room_id,
r.room_type,
count(s.stay_id) as total_stays from rooms r join stays s 
on r.room_id = s.room_id group by r.room_id, r.room_type 
order by total_stays desc;

-- Compare room types by average stay duration
select
r.room_type,
avg(s.nights_stayed) as average_nights,
avg(s.stay_duration_hrs) as average_hours
from rooms r join stays s 
on r.room_id = s.room_id group by r.room_type order by average_nights desc;

-- Objective 5 -- Identify Booking and Stay Problems

-- How many cancellations are there
select 
count(*) as total_cancelled from stays where status = "Cancelled";

-- How many no-shows are there
select count(*) as total_no_shows from stays where status ="no-show";

-- Which booking channels have the most cancellations?
select
b.booking_channel,
count(*) as cancelled_stays
from bookings b
join stays s 
on b.booking_id = s.booking_id
where s.status = "cancelled"
group by b.booking_channel
order by cancelled_stays desc;

-- Which booking channels have the most no-shows
select 
b.booking_channel,
count(*) as no_show_stays 
from bookings b
join stays s 
on b.booking_id = s.booking_id
where s.status = 'No-show'
group by b.booking_channel order by no_show_stays desc;

-- Which hotels have the most booking problems
select 
h.hotel_name,
count(*) as problem_stays
from stays s 
join bookings b 
on s.booking_id = b.booking_id
join hotels h 
on b.hotel_id = h.hotel_id
where s.status in ("Cancelled","No-show")
group by h.hotel_name
order by problem_stays desc;

-- Do high service requests relate to stay outcomes
select
status, 
avg(service_requests) as average_service_requests,
max(service_requests) as maximum_service_requests
from stays group by status;

-- Which stays have unusally high service requests
select 
stay_id,
booking_id,
service_requests,
status from stays 
where service_requests >= 5 
order by service_requests desc;

-- Compare service requests with nights stayed 
select nights_stayed,
avg(service_requests) as average_service_requests,
count(*) as total_stays 
from stays 
group by nights_stayed
order by nights_stayed;

-- IMPORTANT JOIN QUERY
SELECT
    g.guest_name,
    g.guest_type,
    b.booking_id,
    h.hotel_name,
    b.booking_channel,
    b.room_type_requested,
    b.nights_booked,
    b.total_amount,
    s.stay_id,
    s.status,
    r.room_type,
    st.staff_name,
    s.service_requests
FROM guests g
JOIN bookings b
    ON g.guest_id = b.guest_id
JOIN stays s
    ON b.booking_id = s.booking_id
JOIN hotels h
    ON b.hotel_id = h.hotel_id
JOIN rooms r
    ON s.room_id = r.room_id
JOIN staff st
    ON s.staff_id = st.staff_id
LIMIT 20;
