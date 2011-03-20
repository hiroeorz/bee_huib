var maxChars = 140;

$(function() {
    $("#input1").focus();
    $("#txt").focus().keypress(function(e) {
	if (e.which == 13) { //enter
	    send();
	    return false;
	}
	var length = val().length+1;
	$("#chars").text("" + (maxChars - length));
	
    });
    $("#language_select").change(function(e) {
	var select = $("#language_select")[0];
	var lang = select.options[select.selectedIndex].value;
	document.cookie =
	    'lang=' + lang + '; expires=Wed, 1 Jan 2020 00:00:00 UTC; path=/';
	location.href = location.href;
    });
	
});

function val() {
    return $("#txt")[0].value;
}

function send() {
    var msg = val();
    if (msg.length > 0) {
	$("#txt")[0].value = "";
	$("#chars").text("" + maxChars);
	$.post("/api/send", {"msg": msg, "get_html": "true"},
	       function(html) {
		   $("#placeholder").prepend(html);
		   $("#txt").focus();
	       });
    }
}

function update(msg, func) {
    if (msg.length > 0) {
	$("#txt")[0].value = "";
	$("#chars").text("" + maxChars);
	$.post("/statuses/update", {"status": msg, "get_html": "false"},
	       function(html) {
		   func();
	       });
    }
}

function follow(username, val) {
    $.post("/api/follow",
	   {"username": username,
	    "value": val},
	   function(res) {
	       if (val == "1") {
		   $("#follow").hide();
		   $("#unfollow").show();
	       } else {
		   $("#follow").show();
		   $("#unfollow").hide();
	       }
	   });
	   
}

function toggle_twitter(input) {
    $.post("/api/toggle_twitter",
	   {"value": input.value == "on"},
	   function(res) {
	       if (res != "ok") {
		   alert("Toggle Twitter failed");
	       }
	   });
}

function twoorl_status(facility, since_id, count, call_back) {
    var url = "http://localhost/statuses/" + facility;
    var params_added = false;

    if (since_id != undefined) {
	url += "?since_id=" + since_id;
	params_added = true;
    }

    if (count != undefined) {
	if (params_added) {
	    url += "&count=" + count;
	} else {
	    url += "?count=" + count;
	    params_added = true
	}
    }

    alert("nyaooho");
    $.get("/statuses/home_timeline", {},
	  function(html) {
	      alert("helo");
	  });

    $.ajax({
	url: "/statuses/home_timeline",
	cache: false,
	success: function(html) {
	    alert(html)
	}
    })

}