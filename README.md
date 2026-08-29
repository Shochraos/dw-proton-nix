# Nix DW-Proton

Nix packaging for [DW-Proton](https://dawn.wine/dawn-winery/dwproton), Dawn-Winery's fork of Proton-CachyOS, as a Steam Play compatibility tool.

> **AI disclaimer:** The Nix packaging, the update workflow and this README were written with AI assistance. The package installs a binary tarball published on the Dawn-Winery release page. Read what you install.

## How it works

- `versions.json` pins the build (`base`, `release`, sha256 hash). `flake.nix` reads it with `builtins.fromJSON`, and `default.nix` fetches the matching `dwproton-<base>-<release>-x86_64` tarball from the Dawn-Winery release page with that hash. Only `x86_64-linux` is built.
- The build rewrites `compatibilitytool.vdf` so the tool registers under its own name, `DW-Proton-<base>-<release>`, instead of the archive name, and installs it to `share/steam/compatibilitytools.d/dw-proton` for `programs.steam.extraCompatPackages` to pick up.
- The tarball ships a `.update-timestamp` marker inside its default prefix, and Proton stamps new prefixes with the mtime of the distribution's `wine.inf`. Wine re-runs its wine.inf prefix update whenever a prefix's marker disagrees with the live `wine.inf` mtime. The marker the tarball carries records the mtime from the machine that built the tarball, which the Nix store does not reproduce. The build therefore deletes the shipped marker and points Proton's stamp write at `/dev/null`. Wine seeds the timestamp itself on a prefix's first launch, and the check compares equal from then on.

Packaging problems belong here. Game and Proton issues go upstream: to [DW-Proton](https://dawn.wine/dawn-winery/dwproton) for Dawn-Winery-specific problems, to [Valve's Proton](https://github.com/ValveSoftware/Proton) for general ones.

## Usage

Add the input:

```nix
{
  inputs.nix-dw-proton = {
    url = "github:Shochraos/nix-dw-proton";
    inputs.nixpkgs.follows = "nixpkgs";
  };
}
```

Then add it to Steam:

```nix
{ inputs, pkgs, ... }:
{
  programs.steam = {
    enable = true;
    extraCompatPackages = [
      inputs.nix-dw-proton.packages.${pkgs.stdenv.hostPlatform.system}.dw-proton
    ];
  };
}
```

`dw-proton` is also the flake's `default` package. After the rebuild, `DW-Proton-<base>-<release>` (currently `DW-Proton-11.0-5`) appears in Steam's compatibility tools list (Steam → Settings → Compatibility).

## Updates

Every day at 00:00 UTC (and on manual dispatch), the update workflow queries the Dawn-Winery release API, parses the latest `dwproton-<base>-<release>` tag, picks the `dwproton-*-x86_64` archive asset, hashes it with `nix hash file`, and rewrites `versions.json`. A new version is committed straight to `main`, and CI builds it on the next push. To pick up a new version:

```bash
nix flake update nix-dw-proton
sudo nixos-rebuild switch
```

## Development

`nix build` builds the pinned release and `nix flake check` evaluates the flake. Pushes and PRs to `main` run both on CI, where the build step also checks that `compatibilitytool.vdf` and an executable `proton` land in the installed tool directory. nixpkgs is pinned to `nixpkgs-unstable`.

## License

The [LICENSE](LICENSE) file documents the license the packaged software ships under: Valve's BSD-style license for Proton. The repository itself is Nix packaging only.
