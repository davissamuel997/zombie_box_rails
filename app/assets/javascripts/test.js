var addAll = function(e) {
	e.preventDefault();

	user_params = {user_id: 1, total_points: 1000, total_kills:3000, weapons: [{ weapon_id: 30, kill_count: 15, damage: 65, ammo: 99 }], skins: [{ skin_id: 64, kill_count: 345 }]}

	var ajaxRequest = $.ajax({
		url: '/update_all_user_details',
		type: "POST",
		data: { user_params: JSON.stringify(user_params) },
		dataType: 'json'
	});

	ajaxRequest.done(catchSuccess);
	ajaxRequest.fail(failedResponse);
};

var catchSuccess = function(data) {
	debugger
};

var failedResponse = function(data) {
	debugger
};

$(document).ready(function() {
	$('#button-click').on('click', addAll);
});	