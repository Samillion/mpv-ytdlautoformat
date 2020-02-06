# mpv-ytdlautoformat
A simple mpv script to automatically change `ytdl-format`, specifically if the URL is Youtube or Twitch.

This script supports and works with multi-purpose playlists. For example, if you have a playlist that includes Youtube URLs, Vimeo URLs and local files.

If the URL is Youtube or Twitch, `ytdl-format` is set to: 480p, 30 FPS and no VP9 codec.

Otherwise, `ytdl-format` is set to: Best video quality, 30 FPS and no VP9 codec.

# Options
If you would like to add more domains to have `ytdl-format` automatiaclly changed for them, simply add them to the `StreamSource` set.

To adjust quality of matched domains, edit `changedQuality` value.

Affects matched and non-matched domains:
- To enable VP9 codec, change `enableVP9` to `true`.
- To change frame rate, adjust `FPSLimit`, default is `30`.

FPS can be more than 30, however it depends on some factors:
- Can the video stream run that limit?
- Can your hardware run that limit?

That is way frame rate is set to 30 by default, which is the default in most streaming and video websites.

# How is this script useful?
Some streaming websites do not offer multi-quality per video (Openload, for example). So if you have `ytdl-format` in `mpv.conf` set to only play 480p or 720p videos, mpv/youtube-dl will not run it because it cannot find a video with the specified format.

This script helps you set a lower or a specific quality for some websites, while leaving the rest as default. That way all video streams will play and you won't have to keep editing `mpv.conf` each time to make it work.

# Changes to mpv configuration made by the script
The script will override any `ytdl-format` you have set in `mpv.conf` or in commandline to the values you have set within the script.

No files are edited or changed in any way, the script simply changes `ytdl-format` value, so whatever is in `mpv.conf` or CLI is ignored.

# How to install
Simply place `ytdlautoformat.lua` in the corresponding mpv scripts location of your operating system:

- Windows: `%APPDATA%\mpv\scripts\` or `C:\users\USERNAME\AppData\Roaming\mpv\scripts\`
- Linux: `~/.config/mpv/scripts/` or `/home/USERNAME/.config/mpv/scripts/`
- Mac: `~/.config/mpv/scripts/` or `/Users/USERNAME/.config/mpv/scripts/`

# How to uninstall
The script doesn't change or alter configuration in other files, so removing the `ytdlautoformat.lua` script from the mpv scripts folder is all that is needed to uninstall/disable.

# Preview/Demo
A screenshot of the script running and showing process and changes in a playlist.

![mpv-ytdlautoformat preview](https://i.imgur.com/KizO1TW.jpg)
