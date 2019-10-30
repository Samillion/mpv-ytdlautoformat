# mpv-ytdlautoformat
A simple mpv script to automatically change `ytdl-format` (for youtube-dl), specifically if the URL is Youtube or Twitch.

If the URL is Youtube or Twitch, `ytdl-format` is set to:
480p, 30 FPS and no VP9.

Otherwise, `ytdl-format` is set to:
Best video quality, 30 FPS and no VP9

# Adding More Domains & Adjusting Video Quality
If you would like to add more domains to have `ytdl-format` automatiaclly changed for them, simply add them to the `VSTREAMS` set.

To adjust quality or FPS for either low quality or best/default quality, change the values of `ytdlLow` and `ytdlBest`.

The `ytdlLow` value will be used for matched domains in `VSTREAM`, otherwise `ytdlBest` will be used. So in essence, `ytdlBest` acts as the default `ytdl-format` you would normally set in `mpv.conf`

# Changes to mpv configuration made by the script
The script will override any `ytdl-format` you have set in `mpv.conf` or in terminal. To set the default value, please change `ytdlBest` within the script to the value you desire.

While `ytdlLow` is set for matched domains, for lower or changed quailty.

# How to install
Simply place `ytdlautoformat.lua` in the corresponding mpv scripts location of your operating system:

- Windows: `%APPDATA%\mpv\scripts\` or `C:\users\USERNAME\AppData\Roaming\mpv\scripts\`
- Linux: `~/.config/mpv/scripts/` or `/home/USERNAME/.config/mpv/scripts/`
- Mac: `~/.config/mpv/scripts/` or `/Users/USERNAME/.config/mpv/scripts/`

# Preview/Demo
A screenshot of the script running and showing process and changes in a playlist.

![mpv-ytdlautoformat preview](https://raw.githubusercontent.com/Samillion/mpv-ytdlautoformat/master/mpv-ytdlautoformat-demo.png)
