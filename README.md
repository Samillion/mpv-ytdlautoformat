# mpv-ytdlautoformat
A simple mpv script to automatically change `ytdl-format` (for youtube-dl), specifically if the URL is Youtube or Twitch.

This script supports and works with multi-purpose playlists. For example, if you have a playlist that includes Youtube URLs, Vimeo URLs and local files.

If the URL is Youtube or Twitch, `ytdl-format` is set to: 480p, 30 FPS and no VP9.

Otherwise, `ytdl-format` is set to: Best video quality, 30 FPS and no VP9

# Adding More Domains & Adjusting Video Quality
If you would like to add more domains to have `ytdl-format` automatiaclly changed for them, simply add them to the `StreamSource` set.

To adjust quality or FPS for either low quality or best/default quality, change the values of `ytdlChange` and `ytdlDefault`.

The `ytdlChange` value will be used for matched domains in the `StreamSource` set, otherwise `ytdlDefault` will be used. So in essence, `ytdlDefault` acts as the default `ytdl-format` you would normally set in `mpv.conf`

# Changes to mpv configuration made by the script
The script will override any `ytdl-format` you have set in `mpv.conf` or in commandline. To set the default value, please change `ytdlDefault` within the script to the value you desire.

While `ytdlChange` is set for matched domains, for lower or changed quailty.

# How to install
Simply place `ytdlautoformat.lua` in the corresponding mpv scripts location of your operating system:

- Windows: `%APPDATA%\mpv\scripts\` or `C:\users\USERNAME\AppData\Roaming\mpv\scripts\`
- Linux: `~/.config/mpv/scripts/` or `/home/USERNAME/.config/mpv/scripts/`
- Mac: `~/.config/mpv/scripts/` or `/Users/USERNAME/.config/mpv/scripts/`

# Preview/Demo
A screenshot of the script running and showing process and changes in a playlist.

![mpv-ytdlautoformat preview](https://raw.githubusercontent.com/Samillion/mpv-ytdlautoformat/master/mpv-ytdlautoformat-demo.png)
