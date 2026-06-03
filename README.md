# Nix DW Proton

A Nix flake for [DW-Proton](https://dawn.wine/dawn-winery/dwproton), a compatibility tool for Steam Play based on Wine with additional patches and optimizations from Dawn-Winery and CachyOS.

> **Disclaimer**: This is an unofficial, community-maintained Nix package. It is not affiliated with, officially connected to, or endorsed by Valve Corporation, CachyOS, Dawn-Winery or any of their subsidiaries or affiliates. The names Proton, CachyOS, Dawn-Winery, and any related names are trademarks of their respective owners.

## Usage

Add to your NixOS configuration:

```nix
{
  inputs = {
    nix-dw-proton.url = "github:shochraos/nix-dw-proton";
  };
}
```

Then add it to your Steam configuration:

```nix
# In your Steam configuration (e.g., configuration.nix or steam.nix)
programs.steam = {
  enable = true;
  extraCompatPackages = [
    inputs.nix-dw-proton.packages.${system}.dw-proton
  ];
};
```

After rebuilding your system, you should see something like "DW-Proton-[Version]" in Steam's compatibility tools list (Steam -> Settings -> Compatibility).

## Updates

This package automatically checks for updates periodically and creates a pull request when a new version is available on the Dawn-Winery repository. To get the latest version:

1. Update your flake inputs:
```bash
nix flake update nix-dw-proton
```

2. Rebuild your system:
```bash
sudo nixos-rebuild switch
```

## Contributing

This is a community-maintained package and help is welcome! If you'd like to contribute:

1. Issues: 
   - Report packaging issues (e.g., installation problems, Steam not detecting the tool)
   - Problems with the Nix flake itself
   - Note: For issues with games or Proton itself, please report to:
     - [DW-Proton](https://dawn.wine/dawn-winery/dwproton) for Dawn-Winery-specific issues
     - [Valve Proton](https://github.com/ValveSoftware/Proton) for general Proton issues

2. Pull Requests: 
   - Improvements to the Nix packaging
   - Documentation updates
   - Automation enhancements

3. Documentation:
   - Help improve installation instructions
   - Add usage examples
   - Clarify system requirements

This repository only handles the Nix packaging of DW-Proton. We can't fix issues with the underlying Proton implementation.

## Credits

This package is just a Nix flake wrapper around:

- [DW-Proton](https://dawn.wine/dawn-winery/dwproton) by the Dawn-Winery team - a fork of Proton-CachyOS with additional optimizations
- [Proton](https://github.com/ValveSoftware/Proton) by Valve Corporation - the original compatibility layer for Steam Play

All credit for the underlying software goes to their respective teams. This repository simply provides the Nix packaging to make it easier to use on NixOS.
