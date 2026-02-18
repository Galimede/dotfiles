{ ... }:

{
  programs.git = {
    # Default identity
    settings.user = {
      name = "Galimede";
      email = "mat.degand@outlook.fr";
    };

    # Directory-specific identities
    includes = [
      {
        condition = "gitdir:~/dev/clever-cloud/gitlab/";
        contents = {
          commit.gpgsign = true;
          user = {
            name = "mdegand";
            email = "mathieu.degand@clever.cloud";
            signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIDHvHlUpULxUedlB/ZFqou7bHX4pZlTSj8btWrNYq64";
          };
        };
      }
      {
        condition = "gitdir:~/projects/github/";
        contents = {
          commit.gpgsign = true;
          user.signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE0xK4IZkhIz55po+dF57e9Sx/FLnqWR0O8GxwjZX0z1";
        };
      }
      {
        condition = "gitdir:~/Documents/frontend-team/";
        contents = {
          user = {
            name = "mdegand";
            email = "mathieu.degand@clever.cloud";
            signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIDHvHlUpULxUedlB/ZFqou7bHX4pZlTSj8btWrNYq64";
          };
        };
      }
    ];

    # Directory-specific identities
    # includes = [
    #   {
    #     condition = "gitdir:~/work/";
    #     contents = {
    #       user = {
    #         name = "Work Name";
    #         email = "work@company.com";
    #       };
    #     };
    #   }
    # ];
  };
}
