--[[

    A simple mpv script to automatically change ytdl-format (yt-dlp)
    for specified domains/streams.

    Info: https://github.com/Samillion/mpv-ytdlautoformat

--]]

local options = {
    -- Which domains should ytdl-format change on?
    domains = {
        "youtu.be", "youtube.com", "www.youtube.com",
        "twitch.tv", "www.twitch.tv",
    },

    -- Set maximum video quality (on load/start)
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
}

-- Do not edit beyond this point
local msg = require "mp.msg"

local function create_set(list)
    local set = {}
    for _, v in pairs(list) do
        set[type(v) == "string" and v:lower() or v] = true
    end
    return set
end

local function update_ytdl_format()
    local codec_list = {
        ["avc"] = "[vcodec~='^(avc|h264)']",
        ["hevc"] = "[vcodec~='^(hevc|h265)']",
        ["vp9"] = "[vcodec~='^(vp0?9)']",
        ["av1"] = "[vcodec~='^(av01)']",
        ["novp9"] = "[vcodec!~='^(vp0?9)']",
    }

    local format = {
        quality = options.quality > 0 and "[height<=?" .. options.quality .. "]" or "",
        codec = codec_list[options.codec:lower()] or "",
        fallback = options.fallback and " / " .. options.fallback_format or "",
    }

    local ytdl_custom = "bv" .. format.quality .. format.codec .. "+ba/b" .. format.quality .. format.fallback

    mp.set_property("file-local-options/ytdl-format", ytdl_custom)
    msg.info("Changed ytdl-format to: " .. ytdl_custom)
end

local list = create_set(options.domains)

mp.add_hook("on_load", 9, function()
    local path = mp.get_property("path", "")

    if path:match("^%a+://") then
        local hostname = path:lower():match("^%a+://([^/]+)/?") or ""
        local domain = hostname:match("([%w%-]+%.%w+%.%w+)$") or hostname:match("([%w%-]+%.%w+)$") or ""

        if list[domain] then
            msg.info("Domain match found: " .. domain)
            update_ytdl_format()
        end
    end
end)
