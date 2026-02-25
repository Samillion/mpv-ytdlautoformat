--[[

    A simple mpv script to automatically change ytdl-format (yt-dlp)
    for specified domains/streams.

    Info: https://github.com/Samillion/mpv-ytdlautoformat

--]]

local options = {
    -- which domains should ytdl-format change on?
    -- separate each domain with a comma
    domains = "youtu.be, youtube.com, www.youtube.com, twitch.tv, www.twitch.tv",

    -- set maximum video quality (on load/start)
    -- 240, 360, 480, 720, 1080, 1440, 2160, 4320
    -- use 0 to ignore quality
    quality = 720,

    -- Prefered codec. avc, hevc, vp9, av1 or novp9
    -- novp9: accept any codec except vp9
    codec = "avc",

    -- rare: to avoid mpv shutting down if nothing is found with the specified format
    -- if true, and format not found, it'll use fallback_format
    fallback = true,
    fallback_format = "bv+ba/b",

    -- regex to detect urls
    -- a simpler pattern: "^%a+://"
    url_pattern = "^[%a][%a%d+.-]*://",
}

-- do not edit beyond this point
local msg = require "mp.msg"
require 'mp.options'.read_options(options, "ytdlautoformat")

local function domain_matches(hostname, domains)
    hostname = hostname:lower()

    for domain in string.gmatch(domains, '([^,]+)') do
        domain = domain:match("^%s*(.-)%s*$"):lower()

        if hostname == domain or
           hostname:sub(-( #domain + 1 )) == "." .. domain then
            return true
        end
    end
    return false
end

local function update_ytdl_format()
    local codec_list = {
        ["avc"] = "[vcodec~='^(avc|h264)']",
        ["hevc"] = "[vcodec~='^(hevc|h265)']",
        ["vp9"] = "[vcodec~='^(vp0?9)']",
        ["av1"] = "[vcodec~='^(av01)']",
        ["novp9"] = "[vcodec!~='^(vp0?9)']",
    }

    -- codec validation. not the most important
    -- but to inform user of unknown or misconfiguration
    local selected_codec = ""
    if type(options.codec) == "string" then
        local key = options.codec:lower()
        selected_codec = codec_list[key] or ""
        if codec_list[key] == nil and options.codec ~= "" then
            msg.warn("Unknown codec: " .. options.codec)
        end
    end

    -- why not just place them directly instead of making a list?
    -- because it's fancy and looks cool!
    local format = {
        quality = options.quality > 0 and "[height<=?" .. options.quality .. "]" or "",
        codec = selected_codec,
        fallback = options.fallback and " / " .. options.fallback_format or "",
    }

    local ytdl_custom = "bv" .. format.quality .. format.codec .. "+ba/b" .. format.quality .. format.fallback

    mp.set_property("file-local-options/ytdl-format", ytdl_custom)
    msg.info("Changed ytdl-format to: " .. ytdl_custom)
end

mp.add_hook("on_load", 9, function()
    local path = mp.get_property("path", "")

    if path:match(options.url_pattern) then
        local hostname = path:lower():match("^%a+://([^/]+)/?") or ""

        if domain_matches(hostname, options.domains) then
            msg.info("Domain match found: " .. hostname)
            update_ytdl_format()
        end
    end
end)
