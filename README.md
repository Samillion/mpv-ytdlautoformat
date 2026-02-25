## mpv-ytdlAutoFormat
![Terminal](https://github.com/user-attachments/assets/e79c8c91-ca09-437f-93a4-1a2bfe01dbf0)

A simple mpv script that automatically adjusts `ytdl-format` (yt-dlp) for specified domains.

If a domain match is found, the script sets `ytdl-format` based on predefined options. It also has a fallback mode, in case the custom `ytdl-format` was not found.

## How is this script useful?
Some streaming websites lack multi-format options, meaning if `ytdl-format` in `mpv.conf` is set to 480p or 720p only, mpv/yt-dlp may fail to play videos without matching formats.

This script allows you to set video quality and codec for specific websites while keeping the default setting for others, ensuring smooth playback without constantly editing `mpv.conf`.

## Options
To adjust options, simply change the values inside `ytdlautoformat.conf` (recommended) or adjust `local options` within the script.

```EditorConfig
# which domains should ytdl-format change on?
# separate each domain with a comma
domains=youtu.be, youtube.com, www.youtube.com, twitch.tv, www.twitch.tv

# set maximum video quality (on load/start)
# 240, 360, 480, 720, 1080, 1440, 2160, 4320
# use 0 to ignore quality
quality=720

# prefered codec. avc, hevc, vp9, av1 or novp9
# novp9: accept any codec except vp9
codec=avc

# rare: to avoid mpv shutting down if nothing is found with the specified format
# if true, and format not found, it'll use fallback_format
fallback=yes
fallback_format=bv+ba/b

# regex to detect urls
# a simpler pattern: ^%a+://
url_pattern=^[%a][%a%d+.-]*://
```

> [!NOTE]
> The options only affect matched URLs from the `domains` list.

> [!TIP]
> You can set a default value in `mpv.conf` for non-matched domains. You don't have to, but this gives you more control on all streams you play.
>
> Examples for `mpv.conf`:
>
> - `ytdl-format=bv[vcodec!~='^(vp0?9)']+ba/b`
>
> - `ytdl-format=bv[height<=1080][vcodec!~='^(vp0?9)']+ba/b[height<=1080]`

## How to install
Simply place `ytdlautoformat.lua` in the corresponding mpv scripts folder of your operating system:

- Windows: `%APPDATA%\mpv\scripts\` or `C:\users\USERNAME\AppData\Roaming\mpv\scripts\`
- Linux: `~/.config/mpv/scripts/` or `/home/USERNAME/.config/mpv/scripts/`
- Mac: `~/.config/mpv/scripts/` or `/Users/USERNAME/.config/mpv/scripts/`

> [!NOTE]
> More information about files locations can be found  [here](https://mpv.io/manual/master/#files)

   ```
   📁 mpv/
   ├── 📁 script-opts/
   │   └── 📄 ytdlautoformat.conf
   └── 📁 scripts/
       └── 📄 ytdlautoformat.lua
   ```

## Alternatives
I prefer a simple [mpv configuration](https://github.com/Samillion/mpv-conf), so I created this script to fit my basic use case.

However, there are excellent alternatives offering more dynamic options, such as:
- [mpv-quality-menu](https://github.com/christoph-heinrich/mpv-quality-menu): Lets you change streamed video and audio quality (ytdl-format) on the fly.
- [mpv-selectformat](https://github.com/koonix/mpv-selectformat): Plugin for selecting the format of internet videos.

These can be used alongside `ytdlautoformat.lua` without conflicts.
