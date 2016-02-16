$( document ).ready(function() {
	$("#notification-dropdown").bind("click", function() {
		if (!$("#notification-dropdown").parent().hasClass("dropdown open")) {
 			$.ajax({
 				url: '/notifications/update',
 				type: 'PATCH',
      	success: function(data, status, xhr) {
      		$('#notification-dropdown span').text(data.notification_count);
//      		alert(data.notification_count);
      	},
        error: function(xhr, status, error) {
          alert(error);
        }
 			});
 		}
  });
});
