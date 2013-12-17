/* 
 * $Id:     jquery.manheimXMLAPI.js,v 1.7 2010-10-19 12:24:56 mibbotso Exp $
 * Name:    jquery.manheimXMLAPI.js
 * Author:  M Ibbotson
 * Email:   Mark.Ibbotson@manheimeurope.com
 * Purpose: Provide some magik to aid testing
 */
jQuery.manheimXMLAPI = {
    
    /*
     * Kick off 
     */ 
    initialize: function() {
    	jQuery(function() { jQuery("#date").datepicker({ dateFormat: 'yy-mm-dd'}); });	 
    },
    
    process: function() {
    	var action   = jQuery("#action").val();
    	var date     = jQuery("#date").val();
    	var sale_id  = jQuery("#saleID").val();
    	var auct_id  = jQuery("#auctionID").val();
    	var platform = "production";
    	var json     = ""; 
    	var sale_veh = "";
    	
     	jQuery("#pending").html('<center><img src="/images/pending.gif" alt="Wait" width="45px" height="10px" /></center>');
    	       
        if(jQuery('#staging').attr('checked')) {
            platform = "staging";          
        }
        
        if(jQuery('#json').attr('checked')) {
            json = 1;
        }
       
        if(jQuery('#sv').attr('checked')) {
            sale_veh = 1;
        }
    	
    	switch(action) {
    		case 'sales':
    		  jQuery.manheimXMLAPI.getSales(date, platform, json);
    		break;
    		
    		case 'vehicles':
    		  jQuery.manheimXMLAPI.getVehicles(sale_id, auct_id, platform, json, sale_veh);
    		break;
    		
    		case 'attendees':
    		  jQuery.manheimXMLAPI.getAttendees(sale_id, auct_id, platform, json);
    		break;
    		
    		case 'bidders':
    		  jQuery.manheimXMLAPI.getBidders(sale_id, auct_id, platform, json);
    		break;    		
    		
    		case 'orders':
    		  jQuery.manheimXMLAPI.getOrders(date, platform, json);
    		break;
    		
    		case 'proxy':
              jQuery.manheimXMLAPI.getProxy(platform, auct_id, sale_id, json);
            break;      		
    	}
    },
    
    getSales: function(date, platfm, json) {
    
       var url = "/sales/";
       jQuery('#url').html("http://" + document.domain + url + "startDT/" + date + "&platform=" + platfm + "&json=" + json);

       jQuery.ajax({ 
			type: "GET",
			url: url,
			data: { startDT: date, platform: platfm , json: json}, 
			dataType: "application/xml",
			success: function(xml) {
              jQuery("#view").text(xml);
              jQuery("#pending").html('');
			}	 
    	});   	
    },
 
    getOrders: function(date, platfm, json) {
       var url = "/order/";

       jQuery('#url').html("http://" + document.domain + url + "startDT/" + date + "&platform=" + platfm + "&json=" + json);
       
       jQuery.ajax({ 
			type: "GET",
			url: url,
			data: { startDT: date, platform: platfm , json: json}, 
			dataType: "application/xml",
			success: function(xml) {
              jQuery("#view").text(xml);
              jQuery("#pending").html('');
			}	 
    	});       	
    }, 
    
    getVehicles: function(sale_id, auction_id, platfm, json, sale_veh) {
       var path = "/vehicle/";
       var url  = "http://" + document.domain + path + "auctionID/" + auction_id + "/saleID/" + sale_id;
	       url += "&platform=" + platfm + "&json=" + json + "&saleVehicles=" + sale_veh;
		   
       jQuery('#url').html(url);
 
       jQuery.ajax({ 
			type: "GET",
			url: url,
			data: { auctionID: auction_id, saleID: sale_id, platform: platfm, json: json, saleVehicles: sale_veh}, 
			dataType: "application/xml",
			success: function(xml) {
              jQuery("#view").text(xml);
              jQuery("#pending").html('');
			}	 
    	});    	
    },
    
    getAttendees: function(sale_id, auction_id, platfm, json) {
       var url = "/attendee/";
       
       jQuery('#url').html("http://" + document.domain + url + "auctionID/" + auction_id + "/saleID/" + sale_id + "&platform=" + platfm + "&json=" + json);
              
       jQuery.ajax({ 
			type: "GET",
			url: url,
			data: { auctionID: auction_id, saleID: sale_id, platform: platfm, json: json + "&platform=" + platfm + "&json=" + json}, 
			dataType: "application/xml",
			success: function(xml) {
              jQuery("#view").text(xml);
              jQuery("#pending").html('');
			}	 
    	});    	
    },
    
    getBidders: function(sale_id, auction_id, platfm, json) {
       var url = "/bidder/";
       
       jQuery('#url').html("http://" + document.domain + url + "auctionID/" + auction_id + "/saleID/" + sale_id + "&platform=" + platfm + "&json=" + json);

       jQuery.ajax({ 
			type: "GET",
			url: url,
			data: { auctionID: auction_id, saleID: sale_id, platform: platfm, json: json}, 
			dataType: "application/xml",
			success: function(xml) {
              jQuery("#view").text(xml);
              jQuery("#pending").html('');
			}	 
    	});     	
    },
    
    getProxy: function(platfm, auction_id, sale_id, json) {
       var url = "/proxy/";
       
       console.log(url); 
       
       jQuery('#url').html("http://" + document.domain + url + "auctionID/" + auction_id + "/saleID/" + sale_id + "&platform=" + platfm + "&json=" + json);

       jQuery.ajax({ 
            type: "GET",
            url: url,
            data: { auctionID: auction_id, saleID: sale_id, platform: platfm, json: json}, 
            dataType: "application/xml",
            success: function(xml) {
              jQuery("#view").text(xml);
              jQuery("#pending").html('');
            }    
        });         
    }  
}
