{ pkgs, hex, ... }:

let
  system = pkgs.stdenv.hostPlatform.system;
  hexPkg = hex.packages.${system}.hex;

  # On Arch, Nix's Vulkan loader cannot find the system's Intel drivers, so
  # Hex fails to create its window surface and transcribes on the CPU.
  # nixVulkanIntel + nixGLIntel provide the drivers, like kitty and zed.
  hexGL = pkgs.symlinkJoin {
    name = "hex-nixgl-${hexPkg.version}";
    paths = [ hexPkg ];
    postBuild = ''
      rm $out/bin/hex
      cat > $out/bin/hex <<EOF
      #!${pkgs.runtimeShell}
      exec ${pkgs.nixgl.nixVulkanIntel}/bin/nixVulkanIntel ${pkgs.nixgl.nixGLIntel}/bin/nixGLIntel ${hexPkg}/bin/hex "\$@"
      EOF
      chmod +x $out/bin/hex

      desktop=share/applications/anomaly.hex.desktop
      rm $out/$desktop
      sed "s|${hexPkg}/bin/hex|$out/bin/hex|g" ${hexPkg}/$desktop > $out/$desktop
    '';
    meta.mainProgram = "hex";
  };
in
{
  imports = [ hex.homeManagerModules.default ];

  programs.hex = {
    enable = true;
    package = hexGL;
    autostart = true;
  };
}
