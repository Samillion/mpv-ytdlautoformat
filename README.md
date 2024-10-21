# mpv-ytdlautoformat
A simple mpv script to automatically change `ytdl-format` (yt-dlp) for specified domains/streams.

If a domain match is found, `ytdl-format` is set according to the options within the script. Otherwise, `ytdl-format` is set as you have it in `mpv.conf` or uses defaults from `mpv` or `yt-dlp`.

# Options
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

# How is this script useful?
Some streaming websites do not offer multi-quality per video. So if you have `ytdl-format` in `mpv.conf` set to only play 480p or 720p videos, mpv/yt-dlp will not run it because it cannot find a video with the specified format.

This script helps you set a lower or a specific quality for some websites, while leaving the rest as default. That way all video streams will play and you won't have to keep editing `mpv.conf` each time to make it work.

# Changes to mpv configuration made by the script
If a domain match is found, the script will change `ytdl-format` to the values you have set within the script, only for the current playing stream.

No files are edited or changed in any way.

# How to install
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

# How to uninstall
The script doesn't change or alter configuration in other files, so removing the `ytdlautoformat.lua` script from the mpv scripts folder is all that is needed to uninstall.

# Preview
Screenshot showing steps the script goes through for a matched domain with a changed quality to `720p` and to not use VP9 codec.

![Terminal](https://github.com/user-attachments/assets/ee71a77a-3c0b-43f4-a16d-0de8909669d4)

# Alternatives
I like to keep my [mpv configuration](https://github.com/Samillion/mpv-conf) simple, that is why I created this script to match my simple usecase.

However, there are solid alternatives that provide more on demand options, such as:
- [mpv-selectformat](https://github.com/koonix/mpv-selectformat): mpv plugin for selecting the format of internet videos.
- [mpv-quality-menu](https://github.com/christoph-heinrich/mpv-quality-menu): Allows you to change the streamed video and audio quality (ytdl-format) on the fly. 

They can be added alongside `ytdlautoformat.lua` as there are no conflicts between them.
