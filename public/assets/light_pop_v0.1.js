$(window).load(function(e) {
	
	$('.light_pop_trigger').click(function(e){
		
		$('body,html').animate({scrollTop:0}, 800);
		var current=$(this);
		e.preventDefault();
		$('.pop_close').fadeOut(500);
			$('.light_popup').fadeOut(500);
			$('.light_pop_overlay').remove();
		var popid=$(this).attr('href');
		$('body').append('<div class="light_pop_overlay"></div>');
		$('.light_pop_overlay').fadeIn(500);
		$('.pop_close').fadeIn(50);
		$('.pop_close').show();
		$(popid).fadeIn(500);	
		$("#user_signup_form").find("input[type=text], textarea").val("");
		$("#user_signup_form").find("select").val("").removeAttr('selected');
		$("label.error").hide();
		//$('.light_pop_container').height($(popid).height()-15)	
		//$('.light_pop_body').height($(popid).height()-30);
		
		if(current.attr('data-iframe'))
		{
			var popframe=current.attr('data-iframe');
			$(popid+' .light_pop_body').html('<iframe border="0" src="'+popframe+'"></iframe> ');
		}
		else
		{
			return false;
		}
	})

	
	$('.pop_close').click(function(){
			$('.pop_close').fadeOut(500);
			$('.light_popup').fadeOut(500);
			$('.light_pop_overlay').remove();
		})
		$(document).on('click','.light_pop_overlay',(function(){
			$('.pop_close').fadeOut(500);
			$('.light_popup').fadeOut(500);
			$('.light_pop_overlay').remove();
		}))
		
    
});

document.onkeydown = function(evt) {
    evt = evt || window.event;
    if (evt.keyCode == 27) {
        $('.pop_close').fadeOut(500);
			$('.light_popup').fadeOut(500);
			$('.light_pop_overlay').remove();
    }
};
	$(window).resize(function(){
		//$('.light_pop_container').height($('.light_popup').height()-15)	
		//$('.light_pop_body').height($('.light_popup').height()-30);
		})
		
		


	$(window).resize(function(){
		//$('.light_pop_container').height($('.light_popup').height()-15)	
		//$('.light_pop_body').height($('.light_popup').height()-30);
		})
		
		

