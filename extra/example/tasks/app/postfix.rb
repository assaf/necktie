# Have postfix send emails on behalf of our host, and start it. 
HOST = "example.com"
unless Services.status("postfix")
  box["/etc/postfix/main.cf"].replace_contents! /^myhostname\s*=.*$/, "myhostname = #{HOST}"
  box["/etc/mailname"].write HOST
  Services.start "postfix"
end
