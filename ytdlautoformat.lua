--[[

    A simple mpv script to automatically change ytdl-format (yt-dlp)
    for specified domains/streams.

    Info: https://github.com/Samillion/mpv-ytdlautoformat

--]]

local options = {
    -- which domains should ytdl-format change on?
    -- separate each domain with a comma
    domains = "youtu.be, youtube.com, twitch.tv",

    -- set maximum video quality (on load/start)
    -- 240, 360, 480, 720, 1080, 1440, 2160, 4320
    -- use 0 to ignore quality
    quality = 720,

    -- prefered codec. avc, hevc, vp9, av1, novp9, none
    -- novp9: accept any codec except vp9
    -- none: no codec preference
    codec = "avc",

    -- maximum video fps
    -- set 0 to ignore
    fps = 0,

    -- force a specific extension
    force_extension = false,
    extension_type = "mp4",

    -- rare: to avoid mpv shutting down if nothing is found with the specified format
    -- if true, and format not found, it'll use fallback_format
    fallback = true,
    -- an alternative: bv+ba/b
    fallback_format = "b",

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
        ["avc"]   = "[vcodec~='^(avc|h264)']",
        ["hevc"]  = "[vcodec~='^(hevc|h265)']",
        ["vp9"]   = "[vcodec~='^(vp0?9)']",
        ["av1"]   = "[vcodec~='^(av01)']",
        ["novp9"] = "[vcodec!~='^(vp0?9)']",
        ["none"]  = "",
    }

    -- codec validation. not the most important
    -- but to inform user of unknown or misconfiguration
    local key = type(options.codec) == "string" and options.codec:lower() or ""
    local selected_codec = codec_list[key] or ""
    if key ~= "" and not codec_list[key] then
        msg.warn("Unknown codec: " .. tostring(options.codec) .. ". Using AVC instead")
        selected_codec = codec_list["avc"]
    end

    -- why not just place them directly instead of making a list?
    -- because it's fancy and looks cool!
    local format = {
        quality  = options.quality > 0 and "[height<=?" .. options.quality .. "]" or "",
        codec    = selected_codec,
        fps      = options.fps > 0 and "[fps<=?" .. options.fps .. "]" or "",
        ext      = options.force_extension and "[ext=" .. options.extension_type .. "]" or "",
        fallback = options.fallback and " / " .. options.fallback_format or "",
    }

    local ytdl_custom = "bv" .. format.quality .. format.codec .. format.fps .. format.ext .. "+ba/b" .. format.fallback

    mp.set_property("file-local-options/ytdl-format", ytdl_custom)
    msg.info("ytdl-format => " .. ytdl_custom)
end

mp.add_hook("on_load", 9, function()
    local path = mp.get_property("path", "")

    if path:match(options.url_pattern) then
        local hostname = path:lower():match("^%a+://([^/:]+)") or ""

        if domain_matches(hostname, options.domains) then
            msg.info("Domain match found: " .. hostname)
            update_ytdl_format()
        end
    end
end)
