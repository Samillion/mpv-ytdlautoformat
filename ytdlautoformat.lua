--[[

A simple mpv script to automatically change ytdl-format (yt-dlp)
specifically if the URL is Youtube or Twitch, by default.

For more details:
https://github.com/Samillion/mpv-ytdlautoformat

--]]

-- Domains list for auto custom quality
local domains = {
	'youtu.be', 'youtube.com', 'www.youtube.com', 
	'twitch.tv', 'www.twitch.tv'
}

-- Accepts: 240, 360, 480, 720, 1080, 1440, 2160, 4320
local setQuality = 720

-- Should Google's VP9 codec be used if found?
local enableVP9 = false

-- Do not edit beyond this point
local function Set (t)
	local set = {}
	for _, v in pairs(t) do
		set[type(v) == "string" and v:lower() or v] = true
	end
	return set
end

local msg = require 'mp.msg'

mp.add_hook('on_load', 9, function()
	local path = mp.get_property("path", "")

	if path:match('^%a+://') then
		local hostname = path:lower():match '^%a+://([^/]+)/?' or ''
		local domain = hostname:match('([%w%-]+%.%w+%.%w+)$') or hostname:match('([%w%-]+%.%w+)$') or ''

		if Set(domains)[domain] then
			local VP9 = enableVP9 and "" or "[vcodec!~='vp0?9']"
			local ytdlCustom = "bv[height<=?" .. setQuality .. "]" .. VP9 .. "+ba/b[height<=" .. setQuality .. "]"
			
			msg.info("Domain match found: " .. domain)
			mp.set_property('file-local-options/ytdl-format', ytdlCustom)
			msg.info("Changed ytdl-format to: " .. mp.get_property("ytdl-format"))
		end
	end
end)
