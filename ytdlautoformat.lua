--[[

A simple mpv script to automatically change ytdl-format (for youtube-dl)
specifically if the URL is Youtube or Twitch.

If the URL is Youtube or Twitch, ytdl-format is set to:
480p, 30 FPS and no VP9.

Otherwise, ytdl-format is set to:
Best video quality, 30 FPS and no VP9

To add more domains, simply add them to the VSTREAMS set.

To adjust quality or FPS for either low quality or best/default quality
change the values of ytdlLow and ytdlBest

For example, ytdlLow will be used if URL is Youtube or Twitch, otherwise
ytdlBest will be used.

--]]

ytdlLow = "bestvideo[height<=?480][fps<=?30][vcodec!=?vp9]+bestaudio/best[height<=480]"
ytdlBest = "bestvideo[fps<=?30][vcodec!=?vp9]+bestaudio/best"

local msg = require 'mp.msg'
local utils = require 'mp.utils'

function Set (t)
	local set = {}
	for _, v in pairs(t) do set[v] = true end
	return set
end

VSTREAMS = Set {
	'youtu.be', 'youtube.com', 'www.youtube.com', 
	'twitch.tv', 'www.twitch.tv'
}

function get_streamsource(path)
	local hostname = path:match '^https?://([^/]+)/' or ''
	return hostname:match '(%w+%.%w+)$'
end


function ytdlAutoChange(name, value)
	local path = value

	if VSTREAMS[string.lower(get_streamsource(path))] then
		mp.set_property("ytdl-format", ytdlLow)
		msg.info("Domain match found, ytdl-format has been changed.")
		msg.info("Changed ytdl-format: "..mp.get_property("ytdl-format"))
	else
		msg.info("No domain match, ytdl-format unchanged.")
	end

	
	mp.unobserve_property(ytdlAutoChange)
	msg.info("Finished check, no longer observing ytdlAutoChange.")
end

function ytdlCheck()
	local path = mp.get_property("path", "")
	
	if string.match(string.lower(path), "^(https?://)") then
		mp.set_property("ytdl-format", ytdlBest)
		msg.info("Current ytdl-format: "..mp.get_property("ytdl-format"))
		
		mp.observe_property("path", "string", ytdlAutoChange)
		msg.info("Observing path to determine ytdlAutoChange status...")
	else
		msg.info("Not a URL/Stream. Script did not run.")
	end
end

mp.register_event("start-file", ytdlCheck)
