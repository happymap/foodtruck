CREATE DATABASE food_truck;

CREATE USER 'foodtruck'@'localhost' IDENTIFIED BY 'please';
GRANT ALL PRIVILEGES ON *.* TO 'foodtruck'@'please';

use food_truck;

create table IF NOT EXISTS truck (
	truck_id int not null auto_increment,
    name char(255) not null,
    description text null,
    logo varchar(255) null,
    application_id int not null,
    latitude float not null,
    longitude float not null,
    address varchar(255),
    city char(50),
    state char(50),
    zip char(50),
    primary key (truck_id)
);

create table IF NOT EXISTS schedule (
	schedule_id int not null auto_increment,
    day int not null,
    start_hour float not null,
    end_hour float not null,
    truck_id int not null,
    primary key (schedule_id)
);
