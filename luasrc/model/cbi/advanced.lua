local e=require"nixio.fs"
local t=require"luci.sys"
local t=luci.model.uci.cursor()
m=Map("advanced",translate("Advanced Funtion"),translate("<font color=\"Red\"><strong>Configuration documents are directly edited. Unless you know what you are doing, please do not easily modify these configuration documents. Incorrect configuration may cause errors such as unable to turn on.</strong></font><br/>"))
m.apply_on_parse=true
s=m:section(TypedSection,"advanced")
s.anonymous=true

local description_template = translate("This page is the document content of configuring %s. It will take effect after Save & Apply")
local option_description = translate("Each line (;) of the numerical symbol (#) or semicon at the beginning is regarded as a comment; delete (;) to enable the specified option.")

local file_path_dnsmasq = "/etc/dnsmasq.conf"
if nixio.fs.access(file_path_dnsmasq)then
s:tab("dnsmasqconf",translate("dnsmasq"),string.format(description_template, file_path_dnsmasq))
conf=s:taboption("dnsmasqconf",Value,"dnsmasqconf",nil,option_description)
conf.template="cbi/tvalue"
conf.rows=20
conf.wrap="off"
conf.cfgvalue=function(t,t)
return e.readfile(file_path_dnsmasq)or""
end
conf.write=function(a,a,t)
if t then
t=t:gsub("\r\n?","\n")
local tmp_path = "/tmp/dnsmasq.conf"
e.writefile(tmp_path, t)
if (luci.sys.call("cmp -s %q %q" %{ tmp_path, file_path_dnsmasq }) == 1) then
e.writefile(file_path_dnsmasq,t)
luci.sys.call("/etc/init.d/dnsmasq restart >/dev/null")
end
e.remove(tmp_path)
end
end
end

local file_path_network = "/etc/config/network"
if nixio.fs.access(file_path_network)then
s:tab("networkconf",translate("Network"),string.format(description_template, file_path_network))
conf=s:taboption("networkconf",Value,"networkconf",nil,option_description)
conf.template="cbi/tvalue"
conf.rows=20
conf.wrap="off"
conf.cfgvalue=function(t,t)
return e.readfile(file_path_network)or""
end
conf.write=function(a,a,t)
if t then
t=t:gsub("\r\n?","\n")
local tmp_path = "/tmp/network"
e.writefile(tmp_path,t)
if (luci.sys.call("cmp -s %q %q" %{ tmp_path, file_path_network }) == 1) then
e.writefile(file_path_network,t)
luci.sys.call("/etc/init.d/network restart >/dev/null")
end
e.remove(tmp_path)
end
end
end

local file_path_wireless = "/etc/config/wireless"
if nixio.fs.access(file_path_wireless)then
s:tab("wirelessconf",translate("Wireless"),string.format(description_template, file_path_wireless))
conf=s:taboption("wirelessconf",Value,"wirelessconf",nil,option_description)
conf.template="cbi/tvalue"
conf.rows=20
conf.wrap="off"
conf.cfgvalue=function(t,t)
return e.readfile(file_path_wireless)or""
end
conf.write=function(a,a,t)
if t then
t=t:gsub("\r\n?","\n")
local tmp_path = "/tmp/wireless.tmp"
e.writefile(tmp_path,t)
if (luci.sys.call("cmp -s %q %q" %{ tmp_path, file_path_wireless }) == 1) then
e.writefile(file_path_wireless,t)
luci.sys.call("wifi reload >/dev/null &")
end
e.remove(tmp_path)
end
end
end

local file_path_hosts = "/etc/hosts"
if nixio.fs.access(file_path_hosts)then
s:tab("hostsconf",translate("hosts"),string.format(description_template, file_path_hosts))
conf=s:taboption("hostsconf",Value,"hostsconf",nil,option_description)
conf.template="cbi/tvalue"
conf.rows=20
conf.wrap="off"
conf.cfgvalue=function(t,t)
return e.readfile(file_path_hosts)or""
end
conf.write=function(a,a,t)
if t then
t=t:gsub("\r\n?","\n")
local tmp_path = "/tmp/hosts.tmp"
e.writefile(tmp_path,t)
if (luci.sys.call("cmp -s %q %q" %{ tmp_path, file_path_hosts }) == 1) then
e.writefile(file_path_hosts,t)
luci.sys.call("/etc/init.d/dnsmasq restart >/dev/null")
end
e.remove(tmp_path)
end
end
end

local file_path_arpbind = "/etc/config/arpbind"
if nixio.fs.access(file_path_arpbind)then
s:tab("arpbindconf",translate("ARP binding"),string.format(description_template, file_path_arpbind))
conf=s:taboption("arpbindconf",Value,"arpbindconf",nil,option_description)
conf.template="cbi/tvalue"
conf.rows=20
conf.wrap="off"
conf.cfgvalue=function(t,t)
return e.readfile(file_path_arpbind)or""
end
conf.write=function(a,a,t)
if t then
t=t:gsub("\r\n?","\n")
local tmp_path = "/tmp/arpbind.tmp"
e.writefile(tmp_path,t)
if (luci.sys.call("cmp -s %q %q" %{ tmp_path, file_path_arpbind }) == 1) then
e.writefile(file_path_arpbind,t)
luci.sys.call("/etc/init.d/arpbind restart >/dev/null")
end
e.remove(tmp_path)
end
end
end

local file_path_firewall = "/etc/config/firewall"
if nixio.fs.access(file_path_firewall)then
s:tab("firewallconf",translate("Firewall"),string.format(description_template, file_path_firewall))
conf=s:taboption("firewallconf",Value,"firewallconf",nil,option_description)
conf.template="cbi/tvalue"
conf.rows=20
conf.wrap="off"
conf.cfgvalue=function(t,t)
return e.readfile(file_path_firewall)or""
end
conf.write=function(a,a,t)
if t then
t=t:gsub("\r\n?","\n")
local tmp_path = "/tmp/firewall.tmp"
e.writefile(tmp_path,t)
if (luci.sys.call("cmp -s %q %q" %{ tmp_path, file_path_firewall }) == 1) then
e.writefile(file_path_firewall,t)
luci.sys.call("/etc/init.d/firewall restart >/dev/null")
end
e.remove(tmp_path)
end
end
end

local file_path_mwan3 = "/etc/config/mwan3"
if nixio.fs.access(file_path_mwan3)then
s:tab("mwan3conf",translate("Load balancing"),string.format(description_template, file_path_mwan3))
conf=s:taboption("mwan3conf",Value,"mwan3conf",nil,option_description)
conf.template="cbi/tvalue"
conf.rows=20
conf.wrap="off"
conf.cfgvalue=function(t,t)
return e.readfile(file_path_mwan3)or""
end
conf.write=function(a,a,t)
if t then
t=t:gsub("\r\n?","\n")
local tmp_path = "/tmp/mwan3.tmp"
e.writefile(tmp_path,t)
if (luci.sys.call("cmp -s %q %q" %{ tmp_path, file_path_mwan3 }) == 1) then
e.writefile(file_path_mwan3,t)
luci.sys.call("/etc/init.d/mwan3 restart >/dev/null")
end
e.remove(tmp_path)
end
end
end

local file_path_dhcp = "/etc/config/dhcp"
if nixio.fs.access(file_path_dhcp)then
s:tab("dhcpconf",translate("DHCP"),string.format(description_template, file_path_dhcp))
conf=s:taboption("dhcpconf",Value,"dhcpconf",nil,option_description)
conf.template="cbi/tvalue"
conf.rows=20
conf.wrap="off"
conf.cfgvalue=function(t,t)
return e.readfile(file_path_dhcp)or""
end
conf.write=function(a,a,t)
if t then
t=t:gsub("\r\n?","\n")
local tmp_path = "/tmp/dhcp.tmp"
e.writefile(tmp_path,t)
if (luci.sys.call("cmp -s %q %q" %{ tmp_path, file_path_dhcp }) == 1) then
e.writefile(file_path_dhcp,t)
luci.sys.call("/etc/init.d/dnsmasq restart >/dev/null")
end
e.remove(tmp_path)
end
end
end

local file_path_ddns = "/etc/config/ddns"
if nixio.fs.access(file_path_ddns)then
s:tab("ddnsconf",translate("DDNS"),string.format(description_template, file_path_ddns))
conf=s:taboption("ddnsconf",Value,"ddnsconf",nil,option_description)
conf.template="cbi/tvalue"
conf.rows=20
conf.wrap="off"
conf.cfgvalue=function(t,t)
return e.readfile(file_path_ddns)or""
end
conf.write=function(a,a,t)
if t then
t=t:gsub("\r\n?","\n")
local tmp_path = "/tmp/ddns.tmp"
e.writefile(tmp_path,t)
if (luci.sys.call("cmp -s %q %q" %{ tmp_path, file_path_ddns }) == 1) then
e.writefile(file_path_ddns,t)
luci.sys.call("/etc/init.d/ddns restart >/dev/null")
end
e.remove(tmp_path)
end
end
end

local file_path_parentcontrol = "/etc/config/parentcontrol"
if nixio.fs.access(file_path_parentcontrol)then
s:tab("parentcontrolconf",translate("Parental control"),string.format(description_template, file_path_parentcontrol))
conf=s:taboption("parentcontrolconf",Value,"parentcontrolconf",nil,option_description)
conf.template="cbi/tvalue"
conf.rows=20
conf.wrap="off"
conf.cfgvalue=function(t,t)
return e.readfile(file_path_parentcontrol)or""
end
conf.write=function(a,a,t)
if t then
t=t:gsub("\r\n?","\n")
local tmp_path = "/tmp/parentcontrol.tmp"
e.writefile(tmp_path,t)
if (luci.sys.call("cmp -s %q %q" %{ tmp_path, file_path_parentcontrol }) == 1) then
e.writefile(file_path_parentcontrol,t)
luci.sys.call("/etc/init.d/parentcontrol restart >/dev/null")
end
e.remove(tmp_path)
end
end
end

local file_path_autotimeset = "/etc/config/autotimeset"
if nixio.fs.access(file_path_autotimeset)then
s:tab("autotimesetconf",translate("Timed setting"),string.format(description_template, file_path_autotimeset))
conf=s:taboption("autotimesetconf",Value,"autotimesetconf",nil,option_description)
conf.template="cbi/tvalue"
conf.rows=20
conf.wrap="off"
conf.cfgvalue=function(t,t)
return e.readfile(file_path_autotimeset)or""
end
conf.write=function(a,a,t)
if t then
t=t:gsub("\r\n?","\n")
local tmp_path = "/tmp/autotimeset.tmp"
e.writefile(tmp_path,t)
if (luci.sys.call("cmp -s %q %q" %{ tmp_path, file_path_autotimeset }) == 1) then
e.writefile(file_path_autotimeset,t)
luci.sys.call("/etc/init.d/autotimeset restart >/dev/null")
end
e.remove(tmp_path)
end
end
end

local file_path_wolplus = "/etc/config/wolplus"
if nixio.fs.access(file_path_wolplus)then
s:tab("wolplusconf",translate("Wake-on-LAN"),string.format(description_template, file_path_wolplus))
conf=s:taboption("wolplusconf",Value,"wolplusconf",nil,option_description)
conf.template="cbi/tvalue"
conf.rows=20
conf.wrap="off"
conf.cfgvalue=function(t,t)
return e.readfile(file_path_wolplus)or""
end
conf.write=function(a,a,t)
if t then
t=t:gsub("\r\n?","\n")
local tmp_path = "/tmp/wolplus.tmp"
e.writefile(tmp_path,t)
if (luci.sys.call("cmp -s %q %q" %{ tmp_path, file_path_wolplus }) == 1) then
e.writefile(file_path_wolplus,t)
luci.sys.call("/etc/init.d/wolplus restart >/dev/null")
end
e.remove(tmp_path)
end
end
end

local file_path_smartdns = "/etc/config/smartdns"
if nixio.fs.access(file_path_smartdns)then
s:tab("smartdnsconf",translate("SMARTDNS"),string.format(description_template, file_path_smartdns))
conf=s:taboption("smartdnsconf",Value,"smartdnsconf",nil,option_description)
conf.template="cbi/tvalue"
conf.rows=20
conf.wrap="off"
conf.cfgvalue=function(t,t)
return e.readfile(file_path_smartdns)or""
end
conf.write=function(a,a,t)
if t then
t=t:gsub("\r\n?","\n")
local tmp_path = "/tmp/smartdns.tmp"
e.writefile(tmp_path,t)
if (luci.sys.call("cmp -s %q %q" %{ tmp_path, file_path_smartdns }) == 1) then
e.writefile(file_path_smartdns,t)
luci.sys.call("/etc/init.d/smartdns restart >/dev/null")
end
e.remove(tmp_path)
end
end
end

local file_path_bypass = "/etc/config/bypass"
if nixio.fs.access(file_path_bypass)then
s:tab("bypassconf",translate("BYPASS"),string.format(description_template, file_path_bypass))
conf=s:taboption("bypassconf",Value,"bypassconf",nil,option_description)
conf.template="cbi/tvalue"
conf.rows=20
conf.wrap="off"
conf.cfgvalue=function(t,t)
return e.readfile(file_path_bypass)or""
end
conf.write=function(a,a,t)
if t then
t=t:gsub("\r\n?","\n")
local tmp_path = "/tmp/bypass.tmp"
e.writefile(tmp_path,t)
if (luci.sys.call("cmp -s %q %q" %{ tmp_path, file_path_bypass }) == 1) then
e.writefile(file_path_bypass,t)
luci.sys.call("/etc/init.d/bypass restart >/dev/null")
end
e.remove(tmp_path)
end
end
end

local file_path_openclash = "/etc/config/openclash"
if nixio.fs.access(file_path_openclash)then
s:tab("openclashconf",translate("openclash"),string.format(description_template, file_path_openclash))
conf=s:taboption("openclashconf",Value,"openclashconf",nil,option_description)
conf.template="cbi/tvalue"
conf.rows=20
conf.wrap="off"
conf.cfgvalue=function(t,t)
return e.readfile(file_path_openclash)or""
end
conf.write=function(a,a,t)
if t then
t=t:gsub("\r\n?","\n")
local tmp_path = "/tmp/openclash.tmp"
e.writefile(tmp_path,t)
if (luci.sys.call("cmp -s %q %q" %{ tmp_path, file_path_openclash }) == 1) then
e.writefile(file_path_openclash,t)
luci.sys.call("/etc/init.d/openclash restart >/dev/null")
end
e.remove(tmp_path)
end
end
end

local file_path_agh = "/etc/config/AdGuardHome"
if nixio.fs.access(file_path_agh)then
s:tab("aghconf",translate("AdGuard Home"),string.format(description_template, file_path_agh))
conf=s:taboption("aghconf",Value,"aghconf",nil,option_description)
conf.template="cbi/tvalue"
conf.rows=20
conf.wrap="off"
conf.cfgvalue=function(t,t)
return e.readfile(file_path_agh)or""
end
conf.write=function(a,a,t)
if t then
t=t:gsub("\r\n?","\n")
local tmp_path = "/tmp/AdGuardHome.tmp"
e.writefile(tmp_path,t)
if (luci.sys.call("cmp -s %q %q" %{ tmp_path, file_path_agh }) == 1) then
e.writefile(file_path_agh,t)
luci.sys.call("/etc/init.d/AdGuardHome restart >/dev/null")
end
e.remove(tmp_path)
end
end
end

s:tab("filemanager", translate("File Assistant"),translate("Integrated upload, deletion and installation, non-professionals, please operate carefully."))
local fm_view = s:taboption("filemanager", Value, "_file_manager_view")
fm_view.template = "fileassistant"

return m
