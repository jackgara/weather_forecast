/* Place all the behaviors and hooks related to the matching controller here.
 All this logic will automatically be available in application.js.
 You can use CoffeeScript in this file: http://coffeescript.org/ */

$(function(){
	$('#forecast_date').datepicker({ dateFormat: "yy-mm-dd" })
});

var options, a;

$(function(){
    options = {
        serviceUrl:'http://autocomplete.wunderground.com/aq?',
        minChars: 2,
        dataType : "jsonp",
        params : {format: "jsonp"},
        transformResult: function(response) {
                console.log('response', response.RESULTS);
                return {
                    suggestions: $.map(response.RESULTS, function(dataItem,index) {
                    	if (dataItem.type == "city"){
                    		return { value: dataItem.name, data: dataItem.zmw };
                    	}
                })
            };
        }
    };
    a = $('#forecast_location').devbridgeAutocomplete(options); 
});

function clean_fields(){
	$('#forecast_location').val("");
}
$(document).ready(clean_fields);
//$(document).ready(function(){alert(hourly_data);});
