extends Node

var gunCapacity = {
	"blitz34":30,
	"zk2_gen3": 16
}
var gunAmmo = {
	"blitz34":20,
	"zk2_gen3":16
}
var guns = {
	"blitz34":"AUTO",
	"zk2_gen3":"SEMIAUTO"
}
var gunReloadTime = {
	"blitz34":2.5,
	"zk2_gen3":1.9
}
var gunROF = {
	"blitz34":20,
	"zk2_gen3":4
}
var currentWeapon = "blitz34"
var weapon:Node2D
var reload_progress:ProgressBar
