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

    -- preferred codec: avc, hevc, vp9, av1, novp9, noav1, none
    -- novp9/av1: accept any codec except vp9/av1
    -- none: no codec preference
    codec = "none",

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

    -- respect manual format changes (ie: by a quality selector script)
    respect_manual_changes = true,

    -- regex to detect urls
    -- a simpler pattern: "^%a+://"
    url_pattern = "^[%a][%a%d+.-]*://",
}

-- do not edit beyond this point
local msg = require "mp.msg"
require 'mp.options'.read_options(options, "ytdlautoformat")

local codec_list = {
    ["avc"]   = "[vcodec~='^(avc|h264)']",
    ["hevc"]  = "[vcodec~='^(hevc|h265)']",
    ["vp9"]   = "[vcodec~='^(vp0?9)']",
    ["av1"]   = "[vcodec~='^(av01)']",
    ["novp9"] = "[vcodec!~='^(vp0?9)']",
    ["noav1"] = "[vcodec!~='^(av01)']",
    ["none"]  = "",
}

local codec_key = options.codec:lower()
if codec_key ~= "" and not codec_list[codec_key] then
    msg.warn("Unknown codec: " .. options.codec .. ". No codec filter applied.")
end

local valid_qualities = {0, 240, 360, 480, 720, 1080, 1440, 2160, 4320}
local function is_valid_quality(q)
    for _, v in ipairs(valid_qualities) do
        if v == q then return true end
    end
    return false
end

if not is_valid_quality(options.quality) then
    msg.warn("Unusual quality value: " .. options.quality .. ". Ignoring.")
    options.quality = 0
end

if options.fps < 0 then
    msg.warn("fps cannot be negative, ignoring")
    options.fps = 0
end

local domain_list = {}
for domain in string.gmatch(options.domains, '([^,]+)') do
    domain_list[#domain_list + 1] = domain:match("^%s*(.-)%s*$"):lower()
end

-- manual change detection states
local state = {
    last_url           = nil,   -- the url last used
    last_format        = nil,   -- the format last applied
    external_override  = false, -- ytdl-format changed externally
}

local function domain_matches(hostname)
    hostname = hostname:lower()

    for _, domain in ipairs(domain_list) do
        if hostname == domain or
           hostname:sub(-(#domain + 1)) == "." .. domain then
            return true
        end
    end
    return false
end

local function update_ytdl_format()
    local selected_codec = codec_list[codec_key] or ""

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
    state.last_format = ytdl_custom

    mp.set_property("file-local-options/ytdl-format", ytdl_custom)
    msg.info("ytdl-format => " .. ytdl_custom)
end

-- observe ytdl-format property for manual changes
mp.observe_property("ytdl-format", "string", function(_, value)
    if not options.respect_manual_changes then return end

    if state.last_format == nil then return end

    -- did a manual change occur
    state.external_override = value ~= state.last_format
end)

mp.add_hook("on_load", 9, function()
    local path = mp.get_property("path", "")

    if path:match(options.url_pattern) then
        local hostname = path:lower():match("^%a+://([^/:]+)") or ""

        if hostname == "" then return end

        if domain_matches(hostname) then
            msg.info("Domain match: " .. hostname)

            if options.respect_manual_changes then
                if path == state.last_url and state.external_override then
                    -- same url and format manually changed, stop ytdlautoformat
                    msg.info("Manual format override active, skipping")
                    return
                end

                -- new url, reset override state
                if path ~= state.last_url then
                    state.external_override = false
                end
            end

            state.last_url = path
            update_ytdl_format()
        end
    end
end)
