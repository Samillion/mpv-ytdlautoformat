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
local setQuality = 480

-- Should Google's VP9 codec be used if found?
local enableVP9 = false

-- Do not edit beyond this point
local function Set (t)
	local set = {}
	for _, v in pairs(t) do set[v] = true end
	return set
end

local msg = require 'mp.msg'
local utils = require 'mp.utils'
local VP9value = ""

if enableVP9 == false then
	VP9value = "[vcodec!~='vp0?9']"
end

local ytdlCustom = "bv[height<=?"..setQuality.."]"..VP9value.."+ba/b[height<="..setQuality.."]"

local function ytdlAutoChange(name, value)
	local hostname = value:match '^%a+://([^/]+)/' or ''
	hostname = hostname:match '([%w%.]+%w+)$'
	local source = Set(domains)

	if source[string.lower(hostname)] then
		mp.set_property('file-local-options/ytdl-format', ytdlCustom)
		msg.info("Domain match found.")
		msg.info("Changed ytdl-format to: "..mp.get_property("ytdl-format"))
	end

	mp.unobserve_property(ytdlAutoChange)
end

local function ytdlCheck()
	local path = mp.get_property("path", "")
	
	if string.match(string.lower(path), "^(%a+://)") then	
		mp.observe_property("path", "string", ytdlAutoChange)
	end
end

mp.register_event("start-file", ytdlCheck)
