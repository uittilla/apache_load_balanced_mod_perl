jQuery.article = {
	
    init: function () {
    	jQuery('#editable').focus(function(){
    		console.log(this);
    		jQuery('#save').toggle();
    	});
    	
    	jQuery('#editable').blur(function(){
            console.log(this);
            jQuery('#save').toggle();
        });
    },
    
    save: function() {
    	var title = jQuery('#title').html();
    	var page  = jQuery('#page').html();
    	var id    = jQuery('#aid').val();
    	var _id   = jQuery('#_id').val();
    	
    	var request = jQuery.ajax({
    	  type: "POST",
		  url: "/article/",
		  data: {"rt" : "article", "mode": "save", "title": title, "page": page, "aid": id, "_id": _id},
		  dataType: "text/json",
		  success: function() {
		  	jQuery('#has_saved').html("Saved");
		  	jQuery('#has_saved').fadeOut(3000, function(){
		  		jQuery('#has_saved').html("");
		  	});		  	
		  	jQuery('#has_saved').fadeIn();
		  }
		});		
		
    }	
};