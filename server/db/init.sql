CREATE DATABASE food_truck;

CREATE USER 'foodtruck'@'localhost' IDENTIFIED BY 'please';
GRANT ALL PRIVILEGES ON *.* TO 'foodtruck'@'please';

use food_truck;

create table IF NOT EXISTS truck (
	truck_id int not null auto_increment,
    name char(50) not null,
    description text null,
    logo varchar(255) null,
    primary key (truck_id)
);

create table IF NOT EXISTS schedule (
	schedule_id int not null auto_increment,
    start_time datetime not null,
    end_time datetime not null,
    address varchar(255),
    city char(50),
    state char(50),
    zip char(50),
    display_address varchar(255),
    longitude float not null,
    latitude float not null,
    truck_id int not null,
    primary key (schedule_id)
);
