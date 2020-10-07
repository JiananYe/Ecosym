extends HTTPRequest

var cloud_function_url = "https://us-central1-test-75d0d.cloudfunctions.net/" 

var get_credits_body = {
	"id":""
}
var add_owner_body = {
	"id":"",
	"x":"",
	"y":""
}

var add_building_body = {
	"id":"",
	"x":"",
	"y":"",
	"building":""
}

func getCredits():
	get_credits_body.id = Local.userdata.local_id
	request(cloud_function_url + "getCredits", ["Content-Type: application/json"], true, HTTPClient.METHOD_POST, JSON.print(get_credits_body))
	pass

func addOwner(coord):
	add_owner_body.id = Local.userdata.local_id
	add_owner_body.x = coord.x
	add_owner_body.y = coord.y
	request(cloud_function_url + "addOwner", ["Content-Type: application/json"], true, HTTPClient.METHOD_POST, JSON.print(add_owner_body))
	pass

func addBuilding(coord, cell):
	add_building_body.id = Local.userdata.local_id
	add_building_body.x = coord.x
	add_building_body.y = coord.y
	add_building_body.building = cell
	request(cloud_function_url + "addOwner", ["Content-Type: application/json"], true, HTTPClient.METHOD_POST, JSON.print(add_building_body))
	pass

func test(coord):
	add_owner_body.id = Local.userdata.local_id
	add_owner_body.x = coord.x
	add_owner_body.y = coord.y
	request(cloud_function_url + "addOwner", ["Content-Type: application/json"], true, HTTPClient.METHOD_POST, JSON.print(add_owner_body))
	pass

func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	var bod = body.get_string_from_utf8()
	var json_result = JSON.parse(bod)
	if json_result.error != OK:
		print_debug("Error while parsing body json")
		return
	
	var res = json_result.result
	if response_code == HTTPClient.RESPONSE_OK:
		print(res)
