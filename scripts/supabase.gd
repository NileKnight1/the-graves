extends Node

const SUPABASE_URL = "https://jsznfeuhuijfkbcvlcnn.supabase.co"
const SUPABASE_KEY = "sb_publishable_VsOPzQ1oYS4256Jt8tFULQ_Di3hHPOG"

var access_token = ""
var user_id = ""

func sign_up(email, password):
	var http = HTTPRequest.new()
	add_child(http)
	
	var url = SUPABASE_URL + "/auth/v1/signup"
	
	var headers = [
		"apikey: " + SUPABASE_KEY,
		"Content-Type: application/json"
	]

	var data = {
		"email": email,
		"password": password
	}
	
	var error = http.request(
		url,
		headers,
		HTTPClient.METHOD_POST,
		JSON.stringify(data)
	)

	if error != OK:
		print("Request error: ", error)
		return -1

	var result = await http.request_completed
	var response_code = result[1]
	var body = result[3]

	print("Signup response: ", response_code)
	print("Signup data: ", body.get_string_from_utf8())

	return response_code

func login(email: String, password: String, player):
	if player == "":
		player = "Unknown"
	
	var http = HTTPRequest.new()
	add_child(http)

	var url = SUPABASE_URL + "/auth/v1/token?grant_type=password"

	var headers = [
		"apikey: " + SUPABASE_KEY,
		"Content-Type: application/json"
	]

	var data = {
		"email": email,
		"password": password
	}

	var error = http.request(
		url,
		headers,
		HTTPClient.METHOD_POST,
		JSON.stringify(data)
	)

	if error != OK:
		print("Request error: ", error)
		return -1

	var result = await http.request_completed
	var response_code = result[1]
	var body = result[3]

	print("Login response: ", response_code)
	print("Login data: ", body.get_string_from_utf8())

	if response_code == 200:
		var json = JSON.parse_string(body.get_string_from_utf8())

		access_token = json["access_token"]
		user_id = json["user"]["id"]

		print("LOGIN SUCCESS!")
		print("User ID: ", user_id)
		print("Access Token received: YES")

		await create_progress()

		var progress = await get_progress()

		if progress == null:
			print("NO PROGRESS FOUND")
		else:
			print("Player name: ", progress["player_name"])
			print("Last shift won: ", progress["last_shift_won"])
			global.shift = int(progress["last_shift_won"]) + 1

			global.loggedin = 1

	return response_code


func create_player_data(shift_number: int, player_name: String = "Player"):
	var http = HTTPRequest.new()
	add_child(http)

	var url = SUPABASE_URL + "/rest/v1/player_data"

	var headers = [
		"apikey: " + SUPABASE_KEY,
		"Authorization: Bearer " + access_token,
		"Content-Type: application/json",
		"Prefer: return=minimal"
	]

	var data = {
		"id": user_id,
		"shift": shift_number,
		"player": player_name
	}

	var error = http.request(
		url,
		headers,
		HTTPClient.METHOD_POST,
		JSON.stringify(data)
	)

	if error != OK:
		print("Create player data request error: ", error)
		return

	var result = await http.request_completed
	var response_code = result[1]

	print("Shift ", shift_number, " response: ", response_code)


func submit_shift_score(shift_number, player_name, max_danger, anomalies_reported, sabotages_fixed, wrong_reports, anomalies_left):
	var http = HTTPRequest.new()
	add_child(http)

	# First, check if this player already has a score for this shift
	var check_url = SUPABASE_URL + "/rest/v1/player_data?select=max_danger&id=eq." + user_id + "&shift=eq." + str(shift_number)

	var check_headers = [
		"apikey: " + SUPABASE_KEY,
		"Authorization: Bearer " + access_token
	]

	var error = http.request(
		check_url,
		check_headers,
		HTTPClient.METHOD_GET
	)

	if error != OK:
		print("Score check error: ", error)
		return

	var result = await http.request_completed
	var response_code = result[1]
	var body = result[3]

	if response_code != 200:
		print("Score check failed: ", body.get_string_from_utf8())
		return

	var old_data = JSON.parse_string(body.get_string_from_utf8())

	# Existing score
	if old_data.size() > 0:
		var old_max_danger = int(old_data[0]["max_danger"])

		print("Previous max danger: ", old_max_danger)
		print("New max danger: ", max_danger)

		# New score is NOT better
		if max_danger >= old_max_danger:
			print("Score not better. Nothing updated.")
			return

		# New score is better → update
		var update_url = SUPABASE_URL + "/rest/v1/player_data?id=eq." + user_id + "&shift=eq." + str(shift_number)

		var update_headers = [
			"apikey: " + SUPABASE_KEY,
			"Authorization: Bearer " + access_token,
			"Content-Type: application/json",
			"Prefer: return=minimal"
		]

		var update_data = {
			"player": player_name,
			"max_danger": max_danger,
			"anomalies_reported": anomalies_reported,
			"sabotages_fixed": sabotages_fixed,
			"wrong_reports": wrong_reports,
			"anomalies_left": anomalies_left
		}

		error = http.request(
			update_url,
			update_headers,
			HTTPClient.METHOD_PATCH,
			JSON.stringify(update_data)
		)

		if error != OK:
			print("Score update error: ", error)
			return

		result = await http.request_completed
		response_code = result[1]

		print("NEW BEST SCORE! Shift ", shift_number, ": ", response_code)
		return

	# No previous score → create it
	var url = SUPABASE_URL + "/rest/v1/player_data"

	var headers = [
		"apikey: " + SUPABASE_KEY,
		"Authorization: Bearer " + access_token,
		"Content-Type: application/json",
		"Prefer: return=minimal"
	]

	var data = {
		"id": user_id,
		"shift": shift_number,
		"player": player_name,
		"max_danger": max_danger,
		"anomalies_reported": anomalies_reported,
		"sabotages_fixed": sabotages_fixed,
		"wrong_reports": wrong_reports,
		"anomalies_left": anomalies_left
	}

	error = http.request(
		url,
		headers,
		HTTPClient.METHOD_POST,
		JSON.stringify(data)
	)

	if error != OK:
		print("Submit error: ", error)
		return

	result = await http.request_completed
	response_code = result[1]

	print("First score submitted! Shift ", shift_number, ": ", response_code)

func get_leaderboard(shift_number: int):
	var http = HTTPRequest.new()
	add_child(http)

	var url = SUPABASE_URL + "/rest/v1/player_data?select=player,shift,max_danger,anomalies_reported,sabotages_fixed&shift=eq." + str(shift_number) + "&order=max_danger.asc&limit=10"

	var headers = [
		"apikey: " + SUPABASE_KEY
	]

	var error = http.request(
		url,
		headers,
		HTTPClient.METHOD_GET
	)

	if error != OK:
		print("Leaderboard request error: ", error)
		return

	var result = await http.request_completed
	var response_code = result[1]
	var body = result[3]

	if response_code != 200:
		print("Leaderboard failed: ", body.get_string_from_utf8())
		return

	var data = JSON.parse_string(body.get_string_from_utf8())

	if data == null:
		print("Could not parse leaderboard")
		return

	return data

func get_my_score(shift_number: int):
	var http = HTTPRequest.new()
	add_child(http)

	if user_id == "" or access_token == "":
		print("No logged-in user.")
		return null

	var url = SUPABASE_URL + "/rest/v1/player_data?select=id,player,shift,max_danger,anomalies_reported,sabotages_fixed&shift=eq." + str(shift_number) + "&order=max_danger.asc"

	var headers = [
		"apikey: " + SUPABASE_KEY,
		"Authorization: Bearer " + access_token
	]

	var error = http.request(
		url,
		headers,
		HTTPClient.METHOD_GET
	)

	if error != OK:
		print("My score request error: ", error)
		return null

	var result = await http.request_completed
	var response_code = result[1]
	var body = result[3]

	if response_code != 200:
		print("My score failed: ", body.get_string_from_utf8())
		return null

	var data = JSON.parse_string(body.get_string_from_utf8())

	if data == null:
		return null

	for i in range(data.size()):
		if data[i]["id"] == user_id:
			return {
				"rank": i + 1,
				"player": data[i]["player"],
				"max_danger": int(data[i]["max_danger"]),
				"anomalies_reported": int(data[i]["anomalies_reported"]),
				"sabotages_fixed": int(data[i]["sabotages_fixed"])
			}

	return null



func create_progress():
	var http = HTTPRequest.new()
	add_child(http)

	var url = SUPABASE_URL + "/rest/v1/player_progress"

	var headers = [
		"apikey: " + SUPABASE_KEY,
		"Authorization: Bearer " + access_token,
		"Content-Type: application/json",
		"Prefer: return=minimal"
	]

	var data = {
		"id": user_id,
		"player_name": "Player",
		"last_shift_won": 0
	}

	var error = http.request(
		url,
		headers,
		HTTPClient.METHOD_POST,
		JSON.stringify(data)
	)

	if error != OK:
		print("Progress create error: ", error)
		return

	var result = await http.request_completed
	var response_code = result[1]

	print("Progress created: ", response_code)

func get_progress():
	var http = HTTPRequest.new()
	add_child(http)

	var url = SUPABASE_URL + "/rest/v1/player_progress?select=player_name,last_shift_won&id=eq." + user_id

	var headers = [
		"apikey: " + SUPABASE_KEY,
		"Authorization: Bearer " + access_token
	]

	var error = http.request(
		url,
		headers,
		HTTPClient.METHOD_GET
	)

	if error != OK:
		print("Progress request error: ", error)
		return

	var result = await http.request_completed
	var response_code = result[1]
	var body = result[3]

	print("Progress response: ", response_code)

	if response_code != 200:
		print(body.get_string_from_utf8())
		return

	var data = JSON.parse_string(body.get_string_from_utf8())

	if data.size() > 0:
		return data[0]

	return null

func save_progress(player_name: String, last_shift_won: int):
	var http = HTTPRequest.new()
	add_child(http)
	
	var progress_url = SUPABASE_URL + "/rest/v1/player_progress?id=eq." + user_id

	var headers = [
		"apikey: " + SUPABASE_KEY,
		"Authorization: Bearer " + access_token,
		"Content-Type: application/json",
		"Prefer: return=minimal"
	]

	var progress_data = {
		"player_name": player_name,
		"last_shift_won": last_shift_won
	}

	var error = http.request(
		progress_url,
		headers,
		HTTPClient.METHOD_PATCH,
		JSON.stringify(progress_data)
	)

	if error != OK:
		print("Progress save error: ", error)
		return

	var result = await http.request_completed
	var response_code = result[1]

	print("Progress saved: ", response_code)

	var leaderboard_url = SUPABASE_URL + "/rest/v1/player_data?id=eq." + user_id

	var leaderboard_data = {
		"player": player_name
	}

	error = http.request(
		leaderboard_url,
		headers,
		HTTPClient.METHOD_PATCH,
		JSON.stringify(leaderboard_data)
	)

	if error != OK:
		print("Leaderboard name update error: ", error)
		return

	result = await http.request_completed
	response_code = result[1]

	print("Leaderboard names updated: ", response_code)
