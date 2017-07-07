// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap-datepicker/core
//= require bootstrap-datepicker/locales/bootstrap-datepicker.ru.js
//= require turbolinks
//= require_tree .
$('.carousel').on('mouseenter',function(){ $( this ).carousel();})

$(document).ready(function(e) {
    $('#menu_icon').click(function(){
        if($("#content_details").hasClass('drop_menu'))
		{
        $("#content_details").addClass('drop_menu1').removeClass('drop_menu');
    }
		else{
			$("#content_details").addClass('drop_menu').removeClass('drop_menu1');
			}
	
	
	});
	
});
