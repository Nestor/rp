Vehicle = { }

Vehicle.ID = 1

Vehicle.Name = "Subaru Impreza"

Vehicle.Script = "impreza"

Vehicle.Model = "models/lonewolfie/subaru_22b.mdl"

Vehicle.Price = 150000

Vehicle.PassengerSeats = {	Vector(-15.80, -4.71, 16.57),
							Vector(-17.12, -39.16, 5),
							Vector(0.23, -39.16, 5)}

Vehicle.ExitPoint = { 	Vector(60, 2.44, 34.16),
						Vector(-65.29, -11.18, 39.22),
						Vector(-65.29, -11.18, 39.22),
						Vector(60, 2.44, 34.16),
						Vector(60, 2.44, 34.16),
						Vector(60, 2.44, 34.16)}


Vehicle.LookAt = Vector(33, 0, 0)

Vehicle.Seats = 5

Vehicle.MaxSpeed = 80

Vehicle.CamPos = Vector(-58, 150, 59)

Vehicle.FOV = 54

GM:LoadVehicle(Vehicle)