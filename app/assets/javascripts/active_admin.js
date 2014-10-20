//= require active_admin/base


$(document).ready(function(){
  $("select#product_category_id").change(function(){
      var id_value_string = $(this).val();
      if (id_value_string == "") {
          // if the id is empty remove all the sub_selection options from being selectable and do not do any ajax
          $("select#product_quality_rating_id option").remove();
          var row = "<option value=\"" + "" + "\">" + "" + "</option>";
          $(row).appendTo("select#product_quality_rating_id");

      }
      else {
          // Send the request and update sub category dropdown
          $.ajax({
              url: '/admin/products/list_ratings',
              dataType: "json",
              data: "category_id=" + id_value_string,
              timeout: 2000,
              error: function(XMLHttpRequest, errorTextStatus, error){
                  alert("Failed to submit : "+ errorTextStatus+" ;"+error);
              },
              success: function(data){
                  // Clear all options from sub category select
                  $("select#product_quality_rating_id option").remove();
                  //put in a empty default line
                  var row = "<option value=\"" + "" + "\">" + "" + "</option>";
                  $(row).appendTo("select#product_quality_rating_id");
                  $.each(data, function(i, j){
                      row = "<option value=\"" + j[0] + "\">" + j[1] + "</option>";
                      $(row).appendTo("select#product_quality_rating_id");
                  });
               }
          });
      };
    });
});

var CKEDITOR_BASEPATH = '/assets/ckeditor/';