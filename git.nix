{ ... }:

{
  programs.git = {
    enable = true;
    ignores = [
      ".zed"
      ".claude/settings.local.json"
    ];
    settings = {
      push.autoSetupRemote = true;
      remote.pushDefault = "origin";
      core.editor = "vim";
      gpg = {
        format = "ssh";
        ssh.program = "/opt/1Password/op-ssh-sign";
      };
    };
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks."*" = {
      extraOptions = {
        IdentityAgent = "~/.1password/agent.sock";
      };
    };
  };
}
