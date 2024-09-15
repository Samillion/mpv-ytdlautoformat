# mpv-ytdlautoformat
A simple mpv script to automatically change `ytdl-format`, for Youtube and Twitch by default, but more domains can be added as desired.

This script supports and works with multi-purpose playlists. For example, if you have a playlist that includes Youtube URLs, Vimeo URLs and local files.

If the URL is Youtube or Twitch, `ytdl-format` is set to: 720p and no VP9 codec. (Can be changed)

Otherwise, `ytdl-format` is set as you have it in `mpv.conf` or uses defaults set by `yt-dlp`.

# Options

> [!NOTE]
> The following changes only affect matched URLs from the `domains` list.

- To add more matched domains, simply add them to the `domains` list.
- To adjust quality of matched domains, edit `setQuality` value.
- To allow VP9 codec for matched domains, change `enableVP9` to `true`.

> [!TIP]
> You can set a default value in `mpv.conf` for non-matched domains. You don't have to, but this gives you more control on all streams you play.
>
> For example: `ytdl-format=bv[vcodec!~='vp0?9']+ba/b`.

# How is this script useful?
Some streaming websites do not offer multi-quality per video. So if you have `ytdl-format` in `mpv.conf` set to only play 480p or 720p videos, mpv/yt-dlp will not run it because it cannot find a video with the specified format.

This script helps you set a lower or a specific quality for some websites, while leaving the rest as default. That way all video streams will play and you won't have to keep editing `mpv.conf` each time to make it work.

# Changes to mpv configuration made by the script
If a URL match is found, the script will override `ytdl-format` you have set in `mpv.conf` or in commandline to the values you have set within the script.

No files are edited or changed in any way, the script simply changes `ytdl-format` value, so whatever is in `mpv.conf` or CLI is ignored.

# How to install
Simply place `ytdlautoformat.lua` in the corresponding mpv scripts folder of your operating system:

- Windows: `%APPDATA%\mpv\scripts\` or `C:\users\USERNAME\AppData\Roaming\mpv\scripts\`
- Linux: `~/.config/mpv/scripts/` or `/home/USERNAME/.config/mpv/scripts/`
- Mac: `~/.config/mpv/scripts/` or `/Users/USERNAME/.config/mpv/scripts/`

# How to uninstall
The script doesn't change or alter configuration in other files, so removing the `ytdlautoformat.lua` script from the mpv scripts folder is all that is needed to uninstall/disable.

# Preview
Screenshots showing steps the script goes through for a matched domain with a changed quality to `720p`, and an unmatched domain so it plays the default values set by `yt-dlp`.

![Terminal](https://github.com/user-attachments/assets/a54467f1-8059-4469-a90a-35f47d7ef395)

![Video Stats](https://github.com/user-attachments/assets/b9eddfec-8949-4ae9-9369-c7a653f81320)

