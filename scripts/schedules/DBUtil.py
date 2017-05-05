import peewee as pw

myDB = pw.MySQLDatabase("food_truck", host="localhost", port=3306, user="foodtruck", passwd="please")

class MySQLModel(pw.Model):
    """A base model that will use our MySQL database"""
    class Meta:
        database = myDB

class Truck(MySQLModel):
    truck_id = pw.IntegerField(primary_key=True)
    name = pw.FixedCharField()
    description = pw.TextField()
    logo = pw.CharField()

class Schedule(MySQLModel):    
    schedule_id = pw.IntegerField(primary_key=True)
    day = pw.IntegerField()
    truck_id = pw.IntegerField(Truck)
    address = pw.CharField()
    latitude = pw.FloatField()
    longitude = pw.FloatField()
    city = pw.FixedCharField()
    state = pw.FixedCharField()
    zip = pw.FixedCharField()
    start_time = pw.IntegerField()
    end_time = pw.IntegerField()

# when you're ready to start querying, remember to connect
myDB.connect()

def get_db():
	return myDB