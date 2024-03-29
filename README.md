# mpv-ytdlautoformat
A simple mpv script to automatically change `ytdl-format`, for Youtube and Twitch by default, but more domains can be added as desired.

This script supports and works with multi-purpose playlists. For example, if you have a playlist that includes Youtube URLs, Vimeo URLs and local files.

If the URL is Youtube or Twitch, `ytdl-format` is set to: 480p, 30 FPS and no VP9 codec (By default, can be changed).

Otherwise, `ytdl-format` is set to: Best video quality, 30 FPS and no VP9 codec.

# Options
If you would like to add more domains to have `ytdl-format` automatiaclly changed for them, simply add them to the `StreamSource` set.

To adjust quality of matched domains, edit `changedQuality` value.

Affects matched and non-matched domains:
- To enable VP9 codec, change `enableVP9` to `true`.

# How is this script useful?
Some streaming websites do not offer multi-quality per video. So if you have `ytdl-format` in `mpv.conf` set to only play 480p or 720p videos, mpv/yt-dlp will not run it because it cannot find a video with the specified format.

This script helps you set a lower or a specific quality for some websites, while leaving the rest as default. That way all video streams will play and you won't have to keep editing `mpv.conf` each time to make it work.

# Changes to mpv configuration made by the script
The script will override any `ytdl-format` you have set in `mpv.conf` or in commandline to the values you have set within the script.

No files are edited or changed in any way, the script simply changes `ytdl-format` value, so whatever is in `mpv.conf` or CLI is ignored.

# How to install
Simply place `ytdlautoformat.lua` in the corresponding mpv scripts folder of your operating system:

- Windows: `%APPDATA%\mpv\scripts\` or `C:\users\USERNAME\AppData\Roaming\mpv\scripts\`
- Linux: `~/.config/mpv/scripts/` or `/home/USERNAME/.config/mpv/scripts/`
- Mac: `~/.config/mpv/scripts/` or `/Users/USERNAME/.config/mpv/scripts/`

# How to uninstall
The script doesn't change or alter configuration in other files, so removing the `ytdlautoformat.lua` script from the mpv scripts folder is all that is needed to uninstall/disable.

# Preview
A screenshot of the script running and showing process and changes in a playlist.

![ytdl-autoformat-demo](https://github.com/Samillion/mpv-ytdlautoformat/assets/17427046/57d132bc-ae4c-4ec5-b924-a61354754466)
