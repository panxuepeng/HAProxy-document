
# varnishd -f /usr/local/etc/varnish/default.vcl -s malloc,64m -T 127.0.0.1:2000 -a 0.0.0.0:8080

backend default {
	.host = "127.0.0.1";
	.port = "5001";
	.connect_timeout = 1s;
}

backend node5002 {
	.host = "127.0.0.1";
	.port = "5002";
	.connect_timeout = 1s;
}

backend node5003 {
	.host = "127.0.0.1";
	.port = "5003";
	.connect_timeout = 1s;
}

backend node5004 {
	.host = "127.0.0.1";
	.port = "5004";
	.connect_timeout = 1s;
}

acl purge {
	"127.0.0.1";
}


if (req.http.Accept-Encoding) {

	if (req.url ~ "\.(jpg|png|gif|gz|tgz|bz2|tbz|mp3|ogg)$") {
		# No point in compressing these
		remove req.http.Accept-Encoding;
		
	} elsif (req.http.Accept-Encoding ~ "gzip") {
		set req.http.Accept-Encoding = "gzip";
		
	} elsif (req.http.Accept-Encoding ~ "deflate") {
		set req.http.Accept-Encoding = "deflate";
		
	} else {
		# unkown algorithm
		remove req.http.Accept-Encoding;
	}
}


sub vcl_recv {
	if (req.request == "PURGE") {
		if (!client.ip ~ purge) {
			error 405 "Not allowed.";
		}
		lookup;
	}
}

