$(document).ready(function() {
     $('.slider').bxSlider({
			  pager:false,
			  auto:true,
			  pause: 5000,
			  speed:1000
		});
		  var hfrheight=$('.caption_part h4').height();
		  var hfoheight=$('.caption_part h1').height();
		  var pheight=$('.caption_part p').height();
		  var totalheight=hfrheight+hfoheight;
		   var prdtotalheight=pheight+hfoheight;
		  $('.caption_part').height(totalheight);
		  //$('.inner_banner .caption_part').height(hfoheight);
		   $('.inner_banner .caption_part').height($('.caption_part .container').height());
		  $('.inner_banner .caption_part.like_home').height(prdtotalheight);
		  
		 
			  
			  var windHeight=parseInt($(window).height());
			  var navHeight=parseInt($('header').height());
			  var ulheight=windHeight-navHeight-40;
			  $('.menu_container ul').css('max-height',ulheight);
			  
			  $('.accrd_btn').click(function(){
				  $(".accrd_btn").next('div').slideToggle(300);
				  $(".accrd_btn").toggleClass('closed');
				  })
				
			$('.expand a').click(function(){
				$('.expand a').toggleClass('close');
				$('.prd_search .home_right').toggleClass('goback');
				$('.prd_search .home_left').toggleClass('fullwidth');
				$('.prd_search .home_right').toggleClass('nullwidth');
				$('.map_button.hide_for_mobile').toggleClass('expanded')
				})	  
				  
			  $('.etabs .tab a').click(function(evt){
				  evt.preventDefault();
				  $('.etabs .tab a').removeClass('active');
				  $(this).addClass('active');
				  var divId=$(this).attr('href');
				  $('.tab_div').fadeOut().removeClass('active');
				  $(divId).fadeIn().addClass('active');
				  })
				  
		$('.view_lct_btn').click(function() {
            $('.view_location_part_container').slideToggle(400);
        });
		$('.form_control input.photo').change(function() {
            $(this).next('ul.file_dup').children('li.file_result').html($(this).val());
        });
		/*var defaultcusval=$('.custom_select').val();
		$('.cus_select_rslt span').html(defaultcusval);*/
		$('.custom_select').change(function(){
			selectedValue=$(this).val();
			$(this).prev('span').html(selectedValue);
			})
			
			
			 /****************************Toggle Menu**************************/
		  $('.menu_toggle').click(function(){
			  $('.user_menu_list').not('.menu_container ul').slideUp(400);
			  $('.menu_container ul').slideToggle(400);
			  $(this).toggleClass('active');
			  $('.user_mn_link').removeClass('active');
			  	/*if ( $('.user_menu_list').is(':visible') ) 
				{
					$( '.user_mn_link' ).trigger( 'click' );
					
				} 
				else 
				{ 
					return false; 
				}*/
			  })
			/****************************Toggle Menu**************************/
			/****************************User Menu**************************/
			$('.user_mn_link').click(function(){
				$(this).toggleClass('active');
				$('.menu_toggle').removeClass('active');
				$('.user_menu_list').slideToggle(400);
				$('.menu_container ul').not('.user_menu_list').slideUp(400);
				/*if ( $('.menu_container ul').is(':visible') ) 
				{
					$( '.menu_toggle' ).trigger( 'click' );
				} 
				else 
				{ 
					return false; 
				}*/
			})
		/****************************User Menu**************************/
		
		/***************Share popup****************/
		$('.product_button_set .share, .side_share_li').click(function(){
			$('.prd_share_pop').fadeIn(400);
			})
		$('.prd_share_overlay').click(function(){
			$('.prd_share_pop').fadeOut(400);
			})	
			
		/*************Share popup End**************/
		/*****************FAQ******************/
		$('.question').click(function(){
			$(this).next('.ans').slideToggle(300);
			})
		/**************************************/

		$('.media_text .location a').click(function(){
			$(this).parent('.location').parent('.media_text').next('.location_list').slideToggle(400)
			})
});
$(window).resize(function(){
	var hfrheight=$('.caption_part h4').height();
			  var hfoheight=$('.caption_part h1').height();
			  var pheight=$('.caption_part p').height();
			  var totalheight=hfrheight+hfoheight;
			  var prdtotalheight=pheight+hfoheight;
			  $('.caption_part').height(totalheight);
			   //$('.inner_banner .caption_part').height(hfoheight);
			   $('.inner_banner .caption_part').height($('.caption_part .container').height());
			   $('.inner_banner .caption_part.like_home').height(prdtotalheight);
			  var windHeight=parseInt($(window).height());
			  var navHeight=parseInt($('header').height());
			  var ulheight=windHeight-navHeight-40;
			  $('.menu_container ul').css('max-height',ulheight);
})


/*$(window).load(function(){
	var portHeight=$('.bx-viewport').height();
	var captionHeigh=$('.caption_part').height();
	var remainSpace=parseInt(portHeight)-parseInt(captionHeigh);
	var porthalf=Math.round(remainSpace/2);
	$('.caption_part').css('top',porthalf+'px');
})
$(window).resize(function(){
	var portHeight=$('.bx-viewport').height();
	var captionHeigh=$('.caption_part').height();
	var remainSpace=parseInt(portHeight)-parseInt(captionHeigh);
	var porthalf=Math.round(remainSpace/2);
	$('.caption_part').css('top',porthalf+'px');
})*/






