$( document ).ready(function() {
	$("#notification-dropdown").bind("click", function() {
		if (!$("#notification-dropdown").parent().hasClass("dropdown open")) {
 			$.ajax({
 				url: '/notifications/update',
 				type: 'PATCH',
      	success: function(response) {
      		$('#notification-dropdown span').text('0');
      	}
 			});
 		}
  });
});
