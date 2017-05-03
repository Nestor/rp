--include('shared.lua')

require("mysqloo")

db = mysqloo.connect( "localhost", "root", "", "rp")
db:connect()
 
function db:onConnectionFailed( err )
 
    print( "Connection to database failed!" )
    print( "Error:", err )
 
end

function Query( str )
	local d = db:query(str)
	d:start()
	function d:onSuccess(data)
		print('Success')
	end
	function d:onError(err)	
		print(err)
	end
end

function GetDataQuery( str, callback )
	local d = db:query(str)
	d:start()
	function d:onSuccess(data)
		callback(data)
	end
end

function CreatePlayerTable()
	Query("CREATE TABLE items (ID int(20) NOT NULL AUTO_INCREMENT, steamid varchar(32), itemid int(20), quantity int(20), PRIMARY KEY(ID))")
	Query("CREATE TABLE players (ID int(10) NOT NULL AUTO_INCREMENT, steamid varchar(32), steamname varchar(32), name varchar(40), money int(10), rank int(1), playtime int(20), inventory varchar(100), PRIMARY KEY(ID))")
	Query("CREATE TABLE bans (ID int(10) NOT NULL AUTO_INCREMENT, steamid varchar(32), steamname varchar(32), bantime int(30), banduration int(30),reason varchar(50), PRIMARY KEY(ID))")	
	Query("CREATE TABLE vehicles (ID int(10) NOT NULL AUTO_INCREMENT, steamid varchar(32), steamname varchar(32), vehicleid int(20), color varchar(50), PRIMARY KEY(ID))")
end

-----------------
----DEBUGGING----
-----------------

concommand.Add("sql_createtable", CreatePlayerTable)
concommand.Add('sql_dropthetable', function() 
	Query("DROP TABLE players, bans, items, vehicles")
end)