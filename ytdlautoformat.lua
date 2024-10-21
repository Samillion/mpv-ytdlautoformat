--[[

    A simple mpv script to automatically change ytdl-format (yt-dlp)
    for specified domains/streams.

    Info: https://github.com/Samillion/mpv-ytdlautoformat

--]]

local options = {
    -- Which domains should ytdl-format change on?
    domains = {
        "youtu.be", "youtube.com", "www.youtube.com", 
        "twitch.tv", "www.twitch.tv"
    },

    -- Set video quality for auto ytdl-format (on load/start)
    -- 240, 360, 480, 720, 1080, 1440, 2160, 4320
    quality = 720,

    -- Prefered codec. avc, vp9 or novp9
    -- novp9: accept any codec except vp9
    codec = "avc"
}

-- Do not edit beyond this point
local function Set(t)
    local set = {}
    for _, v in pairs(t) do
        set[type(v) == "string" and v:lower() or v] = true
    end
    return set
end

local function update_ytdl_format()
    local codec_list = {
        ["avc"] = "[vcodec^='avc']",
        ["vp9"] = "[vcodec^='vp0?9']",
        ["novp9"] = "[vcodec!~='vp0?9']"
    }
    local codec = codec_list[options.codec:lower()] or ""
    local ytdlCustom = "bv[height<=?" .. options.quality .. "]" .. codec .. "+ba/b[height<=" .. options.quality .. "]"
    mp.set_property("file-local-options/ytdl-format", ytdlCustom)
    mp.msg.info("Changed ytdl-format to: " .. ytdlCustom)
end

local msg = require "mp.msg"
local list = Set(options.domains)

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
