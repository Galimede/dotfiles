{ config, pkgs, ... }:

{
  # usage CLI is required for mise completions
  home.packages = [ pkgs.usage ];

  programs.mise = {
    enable = true;
    enableFishIntegration = true;
  };

  # Fish function to detect volta version and set MISE_NODE_VERSION
  # This runs on directory change, before mise's hook processes
  home.file.".config/fish/conf.d/volta-compat.fish".text = ''
    # Volta compatibility for mise
    # Sets MISE_NODE_VERSION based on volta.node in package.json

    function __volta_compat_hook --on-variable PWD
      if test -f package.json
        set -l volta_node (${pkgs.jq}/bin/jq -r '.volta.node // empty' package.json 2>/dev/null)
        if test -n "$volta_node"
          set -gx MISE_NODE_VERSION $volta_node
        else
          set -e MISE_NODE_VERSION
        end
      else
        set -e MISE_NODE_VERSION
      end
    end

    # Run once on shell startup for the initial directory
    __volta_compat_hook
  '';

}
