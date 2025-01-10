(function(x){
    x.indexOf("internal") !== -1; // $ MISSING: Alert
    x.indexOf("localhost") !== -1; // $ MISSING: Alert
    x.indexOf("secure.com") !== -1; // $ Alert
    x.indexOf("secure.net") !== -1; // $ Alert
    x.indexOf(".secure.com") !== -1; // $ Alert
    x.indexOf("sub.secure.") !== -1; // $ MISSING: Alert
    x.indexOf(".sub.secure.") !== -1; // $ MISSING: Alert

    x.indexOf("secure.com") === -1; // $ Alert
    x.indexOf("secure.com") === 0; // $ Alert
    x.indexOf("secure.com") >= 0; // $ Alert

    x.startsWith("https://secure.com"); // $ Alert
    x.endsWith("secure.com"); // $ Alert
    x.endsWith(".secure.com"); // OK
    x.startsWith("secure.com/"); // OK
    x.indexOf("secure.com/") === 0; // OK

    x.includes("secure.com"); // $ Alert

    x.indexOf("#") !== -1; // OK
    x.indexOf(":") !== -1; // OK
    x.indexOf(":/") !== -1; // OK
    x.indexOf("://") !== -1; // OK
    x.indexOf("//") !== -1; // OK
    x.indexOf(":443") !== -1; // OK
    x.indexOf("/some/path/") !== -1; // OK
    x.indexOf("some/path") !== -1; // OK
    x.indexOf("/index.html") !== -1; // OK
    x.indexOf(":template:") !== -1; // OK
    x.indexOf("https://secure.com") !== -1; // $ Alert
    x.indexOf("https://secure.com:443") !== -1; // $ Alert
    x.indexOf("https://secure.com/") !== -1; // $ Alert

    x.indexOf(".cn") !== -1; // $ MISSING: Alert
    x.indexOf(".jpg") !== -1; // OK
    x.indexOf("index.html") !== -1; // OK
    x.indexOf("index.js") !== -1; // OK
    x.indexOf("index.php") !== -1; // OK
    x.indexOf("index.css") !== -1; // OK

    x.indexOf("secure=true") !== -1; // OK (query param)
    x.indexOf("&auth=") !== -1; // OK (query param)

    x.indexOf(getCurrentDomain()) !== -1; // $ MISSING: Alert
    x.indexOf(location.origin) !== -1; // $ MISSING: Alert

	x.indexOf("tar.gz") + offset; // OK
	x.indexOf("tar.gz") - offset; // OK

    x.indexOf("https://example.internal") !== -1; // $ Alert
    x.indexOf("https://") !== -1; // OK

    x.startsWith("https://example.internal"); // $ Alert
    x.indexOf('https://example.internal.org') !== 0; // $ Alert
    x.indexOf('https://example.internal.org') === 0; // $ Alert
    x.endsWith("internal.com"); // $ Alert
    x.startsWith("https://example.internal:80"); // OK

	x.indexOf("secure.com") !== -1; // $ Alert
	x.indexOf("secure.com") === -1; // OK
	!(x.indexOf("secure.com") !== -1); // OK
	!x.includes("secure.com"); // OK

	if(!x.includes("secure.com")) { // $ Alert

	} else {
		doSomeThingWithTrustedURL(x);
    }

    x.startsWith("https://secure.com/foo/bar"); // OK - a forward slash after the domain makes prefix checks safe.
    x.indexOf("https://secure.com/foo/bar") >= 0 // $ Alert - the url can be anywhere in the string.
    x.indexOf("https://secure.com") >= 0 // $ Alert
    x.indexOf("https://secure.com/foo/bar-baz") >= 0 // $ Alert - the url can be anywhere in the string.
});
