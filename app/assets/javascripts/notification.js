$( document ).ready(function() {
  $("#notification-dropdown").bind("click", function() {
    $.ajax({
      url: '/notifications/update',
      type: 'PATCH',
      success: function(response) {
	    $('#notification-dropdown span').text('0');
      }
    });
  });
});
