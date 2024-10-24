## mpv-ytdlAutoFormat
![Terminal](https://github.com/user-attachments/assets/ee71a77a-3c0b-43f4-a16d-0de8909669d4)

A simple mpv script that automatically adjusts `ytdl-format` (yt-dlp) for specified domains.

If a domain match is found, the script sets `ytdl-format` based on predefined options. Otherwise, it defaults to the settings in `mpv.conf` or falls back to the default behavior of mpv or yt-dlp.

## How is this script useful?
Some streaming websites lack multi-quality video options, meaning if `ytdl-format` in `mpv.conf` is set to 480p or 720p only, mpv/yt-dlp may fail to play videos without matching formats.

This script allows you to define lower or specific video qualities for certain websites while keeping the default setting for others, ensuring smooth playback without constantly editing `mpv.conf`.

## Options
To adjust options, simply change the values inside `local options` within the script.

```lua
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
```

> [!NOTE]
> The options only affect matched URLs from the `domains` list.

> [!TIP]
> You can set a default value in `mpv.conf` for non-matched domains. You don't have to, but this gives you more control on all streams you play.
>
> Examples for `mpv.conf`:
>
> - `ytdl-format=bv[vcodec!~='vp0?9']+ba/b`
>
> - `ytdl-format=bv[height<=1080][vcodec!~='vp0?9']+ba/b[height<=1080]`

## How to install
Simply place `ytdlautoformat.lua` in the corresponding mpv scripts folder of your operating system:

- Windows: `%APPDATA%\mpv\scripts\` or `C:\users\USERNAME\AppData\Roaming\mpv\scripts\`
- Linux: `~/.config/mpv/scripts/` or `/home/USERNAME/.config/mpv/scripts/`
- Mac: `~/.config/mpv/scripts/` or `/Users/USERNAME/.config/mpv/scripts/`

> [!NOTE]
> More information about files locations can be found  [here](https://mpv.io/manual/master/#files)

```
config/mpv
│   input.conf
│   mpv.conf
│
└───scripts
        ytdlautoformat.lua
```

## Alternatives
I prefer a simple [mpv configuration](https://github.com/Samillion/mpv-conf), so I created this script to fit my basic use case.

However, there are excellent alternatives offering more dynamic options, such as:
- [mpv-quality-menu](https://github.com/christoph-heinrich/mpv-quality-menu): Lets you change streamed video and audio quality (ytdl-format) on the fly.
- [mpv-selectformat](https://github.com/koonix/mpv-selectformat): Plugin for selecting the format of internet videos.

These can be used alongside `ytdlautoformat.lua` without conflicts.
