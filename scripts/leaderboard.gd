extends Node

const SUPABASE_URL = "https://jsznfeuhuijfkbcvlcnn.supabase.co"
const SUPABASE_KEY = "sb_publishable_VsOPzQ1oYS4256Jt8tFULQ_Di3hHPOG"



func submit_scores(user_id, player, shift, max_danger, anomalies_reported, sabotages_fixed, wrong_reports, anomalies_left):
	var http = HTTPRequest.new()
	add_child(http)

	var url = SUPABASE_URL + "/rest/v1/player_data"

	var headers = [
		"apikey: " + SUPABASE_KEY,
		"Authorization: Bearer " + SUPABASE_KEY,
		"Content-Type: application/json",
		"Prefer: return=minimal"
	]

	var data = {
		"id": user_id,
		"player": player,
		"shift": shift,
		"max_danger": max_danger,
		"anomalies_reported": anomalies_reported,
		"sabotages_fixed": sabotages_fixed,
		"wrong_reports": wrong_reports,
		"anomalies_left": anomalies_left
	}

	http.request(
		url,
		headers,
		HTTPClient.METHOD_POST,
		JSON.stringify(data)
	)
