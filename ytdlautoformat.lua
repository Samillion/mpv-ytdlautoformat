-- A simple script to automatically change ytdl-format 
-- for specific Stream sources, in this case to lower
-- video quality down to 480p, 30 FPS and no VP9 
-- only if it's Youtube or Twitch.

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


function ytdlAutoChange()
	local path = mp.get_property("path", "")

	if string.match(string.lower(path), "^(https?://)") then
		if VSTREAMS[string.lower(get_streamsource(path))] then
			mp.set_property("ytdl-format", "bestvideo[height<=?480][fps<=?30][vcodec!=?vp9]+bestaudio/best[height<=480]")
			msg.info("Match found, ytdl-format has been changed.")
			msg.info("ytdl-format: "..mp.get_property("ytdl-format"))
		else
			msg.info("No match, ytdl-format unchanged.")
		end
		
	else
		msg.info("Not a URL/Stream. Script did not run.")
	end
end

mp.register_event("start-file", ytdlAutoChange)
