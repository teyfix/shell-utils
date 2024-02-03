# retrieves the prosody.cfg.lua file from the prosody container
prosody-conf() {
  tmp_file=$(mktemp /tmp/prosody.cfg-XXXXXX.lua)
  kube-exec prosody cat /config/prosody.cfg.lua | trim-nf >$tmp_file
  code $tmp_file
}

# retrieves the jitsi-meet.cfg.lua file from the prosody container
meet-conf() {
  tmp_file=$(mktemp /tmp/jitsi-meet.cfg-XXXXXX.lua)
  kube-exec prosody cat /config/conf.d/jitsi-meet.cfg.lua | trim-nf >$tmp_file
  code $tmp_file
}
