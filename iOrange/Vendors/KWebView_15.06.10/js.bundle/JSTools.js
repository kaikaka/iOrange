
function MyAppGetHTMLElementsAtPoint(x,y) {
    var tags = "";
    var e;
    var offset = 0;
    while ((tags.search(",(A|IMG),") < 0) && (offset < 20)) {
        tags = ",";
        e = document.elementFromPoint(x,y+offset);
        while (e) {
            if (e.tagName) {
                tags += e.tagName + ',';
            }
            e = e.parentNode;
        }
        if (tags.search(",(A|IMG),") < 0) {
            e = document.elementFromPoint(x,y-offset);
            while (e) {
                if (e.tagName) {
                    tags += e.tagName + ',';
                }
                e = e.parentNode;
            }
        }
        
        offset++;
    }
    return tags;
}

function MyAppGetLinkSRCAtPoint(x,y) {
    var tags = "";
    var title = "";
    var e = "";
    var offset = 0;
    while ((tags.length == 0) && (offset < 20)) {
        e = document.elementFromPoint(x,y+offset);
        while (e) {
            if (e.src) {
                tags += e.src;
                if (e.title) {
                    title += e.title;
                }
                else if (e.alt) {
                    title += e.alt;
                }
                else {
                    title += null
                }
                break;
            }
            e = e.parentNode;
        }
        if (tags.length == 0) {
            e = document.elementFromPoint(x,y-offset);
            while (e) {
                if (e.src) {
                    tags += e.src;
                    break;
                }
                e = e.parentNode;
            }
        }
        offset++;
    }
//    var ret = "{\"title\":\""+title+"\", \"link\":\""+tags+"\"}";
    var ret = title+","+tags;
    return ret;
}

function MyAppGetLinkHREFAtPoint(x,y) {
    var tags = "";
    var title = "";
    var e = "";
    var offset = 0;
    while ((tags.length == 0) && (offset < 20)) {
        e = document.elementFromPoint(x,y+offset);
        while (e) {
            if (e.href) {
                tags += e.href;
                if (e.innerText) {
                    title += e.innerText;
                }
                else {
                    title += null;
                }
                break;
            }
            e = e.parentNode;
        }
        if (tags.length == 0) {
            e = document.elementFromPoint(x,y-offset);
            while (e) {
                if (e.href) {
                    tags += e.href;
                    break;
                }
                e = e.parentNode;
            }
        }
        offset++;
    }
//    var ret = "{\"title\":\""+title+"\", \"link\":\""+tags+"\"}";
    var ret = title+","+tags;
    return ret;
}