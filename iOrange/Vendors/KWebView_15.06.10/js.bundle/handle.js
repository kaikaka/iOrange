var MyIPhoneApp_ModifyLinkTargets = function() {
    var allLinks = document.getElementsByTagName('a');
    if (allLinks) {
        var i;
        for (i=0; i<allLinks.length; i++) {
            var link = allLinks[i];
            var target = link.getAttribute('target');
            if (target && target == '_blank') {
                link.setAttribute('target','_self');
                link.href = 'newtab:'+escape(link.href);
            }
        }
    }
}


var MyIPhoneApp_ModifyWindowOpen = function() {
    window.open =
    function(url,target,param) {
        if (url && url.length > 0) {
            if (!target) target = "_blank";
            if (target == '_blank') {
                location.href = 'newtab:'+escape(url);
            } else {
                location.href = url;
            }
        }
    }
}

var MyIPhoneApp_Init = function(){
    MyIPhoneApp_ModifyLinkTargets();
    MyIPhoneApp_ModifyWindowOpen();
}

var div_hide_css_id = "koto_div_hide_css";

// ------------------- 有图/无图 ----

function JSHandleHideImage () {
    var i = 0;
    var allDiv = document.getElementsByTagName("DIV");
    for (i; i<allDiv.length; i++) {
        var e = allDiv[i];
        var bg_image = e.style.backgroundImage;
        e.style.backgroundImage = "none";
        e.setAttribute("bg_image", bg_image);
    }
    
    var newCss = document.getElementById(div_hide_css_id);
    
    if(newCss == undefined){
        document.documentElement.innerHTML= document.documentElement.innerHTML+"<style id='"+div_hide_css_id+"'>img{visibility:hidden;}</style>";
    }
    else {
        if(newCss.innerHTML == '') {
            
        }
        newCss.innerHTML = 'img{visibility:hidden;}';
    }
}

function JSHandleShowImage () {
    var i = 0;
    var allDiv = document.getElementsByTagName("DIV");
    for (i; i<allDiv.length; i++) {
        var e = allDiv[i];
        var bg_image = e.getAttribute("bg_image");
        e.style.backgroundImage = bg_image;
    }

    var newCss = document.getElementById(div_hide_css_id);
    if(newCss){
        newCss.innerHTML = 'img{visibility:visibility;}';
    }
}
