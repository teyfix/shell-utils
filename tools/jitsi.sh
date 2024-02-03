# retrieves the jitsi-meet.cfg.lua file from the prosody container
meet-conf() {
  kube-exec prosody cat /config/conf.d/jitsi-meet.cfg.lua | trim-nf
}
