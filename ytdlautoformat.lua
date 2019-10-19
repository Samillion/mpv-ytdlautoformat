-- A simple script to automatically change ytdl-format 
-- for specific Stream sources, in this case to lower
-- video quality down to 480p and no VP9 only if it's
-- Youtube or Twitch.

-- issues: Pattern match fails with youtu.be

local msg = require 'mp.msg'
local utils = require 'mp.utils'

function Set (t)
	local set = {}
	for _, v in pairs(t) do set[v] = true end
	return set
end

-- List domains that need ytdl-format change
VSTREAMS = Set {
	'youtu.be', 'youtube.com', 'twitch.tv'
}

-- Extract domain from URL
function get_streamsource(path)
	match = string.match(path, "[%w%.]*%.(%w+%.%w+)")
	if match == nil then
		return "nomatch"
	else
		return match
	end
end


function ytdlAutoChange()
	local path = mp.get_property("path", "")
	
	-- First make sure that it's a URL, otherwise don't run script
	if string.match(string.lower(path), "^(https?://)") then
		-- If there is a match, change ytdl-format, otherwise no change.
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
