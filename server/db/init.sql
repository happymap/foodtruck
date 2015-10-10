use food_truck;
create table truck (
	truck_id int not null auto_increment,
    name char(50) not null,
    description varchar(255) null,
    primary key (truck_id)
);

create table schedule (
	schedule_id int not null auto_increment,
    start_time datetime not null,
    end_time datetime not null,
    address text null,
    city char(50),
    state char(50),
    zip char(50),
    display_address varchar(255),
    longitude float not null,
    latitude float not null,
    truck_id int not null,
    primary key (schedule_id)
);
