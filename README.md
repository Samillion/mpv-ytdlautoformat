# mpv-ytdlautoformat
A simple mpv script to automatically change `ytdl-format` (youtube-dl), specifically if the URL is Youtube or Twitch.

If the URL is Youtube or Twitch, `ytdl-format` is set to:
480p, 30 FPS and no VP9.

Otherwise, `ytdl-format` remains unchanged from default or as you have it set in `mpv.conf`.

# Adding More Domains & Adjusting Video Quality
If you would like to add more domains to have `ytdl-format` automatiaclly changed for them, simply add them to the `VSTREAMS` set.

To adjust quality, simply change 480 to 720 for 720p, or 1080 within the `ytdlAutoChange()` function.
