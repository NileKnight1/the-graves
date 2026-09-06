extends Node
var shift = 1
var player_name = "Player"
var loggedin = 0

var day2creature_found = 0
var day3creature_stayed = 0
var day4creature_stayed = 0
var day4crawl = 0 

var total_good_reports = 0
var total_fast_reports = 0
var total_no_generator_reports = 0
var total_wrong_reports = 0
var total_sabotages_fixed = 0

### Achievements
# go and down loadder 10 times in 1 second
# finish the game (1:7) + one complete
# Reporter (good reports 10:20:50)
# Perfect shifts (no wrong reports)
# don't leave anomalies
# finish shift with -1 max_bad_time
# fsat report (report at less than 2 sec)
# fast reporter (report 5:10:20) less than 5 sec
# reapirer (repair 5:10:20)
# repair each camera in one game
# report (5:10:20) with generator sabotaged
# door hand anomaly


func temp_reset():
	shift = 1
	day2creature_found = 0
	day3creature_stayed = 0
	day4creature_stayed = 0
	day4crawl = 0 
