{ ... }:

# Desktop app and CLI are installed via AUR, not Nix,
# for proper system integration (polkit, onepassword-cli group, etc.)

{
  # Allow CLI to authenticate via the desktop app (biometric/system unlock)
  home.sessionVariables = {
    OP_BIOMETRIC_UNLOCK_ENABLED = "true";
  };
}
