module("luci.controller.advanced",package.seeall)
function index()
if not nixio.fs.access("/etc/config/advanced")then
return
end
local e
e=entry({"admin","system","advanced"},cbi("advanced"),_("Advanced settings"),60)
e.dependent=true
end
