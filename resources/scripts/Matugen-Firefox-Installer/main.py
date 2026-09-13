#!/usr/bin/env python3
import argparse
import configparser
import os
import sys
from pathlib import Path
import typing


def get_default_config_dir() -> Path:
    for i, arg in enumerate(sys.argv):
        if arg in ("-c", "--config-dir") and i + 1 < len(sys.argv):
            return Path(sys.argv[i + 1])
    if sys.platform == "darwin":
        return Path.home() / "Library/Application Support/Zen Browser"
    xdg_config = Path(os.environ.get("XDG_CONFIG_HOME", Path.home() / ".config"))
    cfg = xdg_config / "zen"
    if not cfg.is_dir():
        legacy = Path.home() / ".zen"
        if legacy.is_dir():
            return legacy
    return cfg


def read_ini(path: Path) -> typing.Optional[configparser.ConfigParser]:
    if not path.is_file():
        return None
    cfg = configparser.ConfigParser()
    cfg.read(path)
    return cfg


def find_profile(config_dir: Path) -> typing.Optional[Path]:
    if cfg := read_ini(config_dir / "installs.ini"):
        for section in cfg.sections():
            if cfg.has_option(section, "Default"):
                raw = cfg.get(section, "Default").rstrip("/")
                candidate = config_dir / raw
                if candidate.is_dir():
                    return candidate

    if cfg := read_ini(config_dir / "profiles.ini"):
        for section in cfg.sections():
            if cfg.get(section, "Default") == "1":
                raw = cfg.get(section, "Path", fallback="")
                is_rel = cfg.get(section, "IsRelative", fallback="0")
                candidate = config_dir / raw if is_rel == "1" else Path(raw)
                if candidate.is_dir():
                    return candidate
        if cfg.has_section("Profile0"):
            raw = cfg.get("Profile0", "Path", fallback="")
            is_rel = cfg.get("Profile0", "IsRelative", fallback="0")
            candidate = config_dir / raw if is_rel == "1" else Path(raw)
            if candidate.is_dir():
                return candidate
    return None


def install_themes(
    config_dir: Path,
    profile: Path,
    matugen_input: Path,
    matugen_output: Path,
    website_templates: Path,
    auto_yes: bool,
):
    if not matugen_output.is_dir():
        print(f"ERR: Matugen output folder `{matugen_output}` is not found!!", file=sys.stderr)
        sys.exit(1)

    if not matugen_input.is_dir():
        print(f"ERR: Matugen input templates folder `{matugen_input}` is not found!!", file=sys.stderr)
        sys.exit(1)

    chrome_dir = profile / "chrome"
    chrome_dir.mkdir(parents=True, exist_ok=True)
    content_file = chrome_dir / "userContent.css"

    if any(chrome_dir.iterdir()):
        print("INF: Zen styles are already installed!!")
        print("INF: If it is not working please run matugen and configure it properly!!\n     And then rerun this script:)")
    else:
        os.symlink(matugen_input / "zen-userChrome.css", chrome_dir / "userChrome.css")
        os.symlink(matugen_input / "zen-userContent.css", content_file)
        print("INF: Zen styles are successfully installed!!")

    if auto_yes:
        install_website_themes = "Y"
        print("Do you want to install the website themes? [Y/n] Y")
    else:
        install_website_themes = input("Do you want to install the website themes? [Y/n] ")

    if install_website_themes.upper() == "N":
        return

    website_dir = chrome_dir / "websites"
    if not website_dir.is_dir():
        if not website_templates.is_dir():
            print(f"ERR: Website templates folder `{website_templates}` does not exist!!", file=sys.stderr)
            sys.exit(1)
        os.symlink(website_templates, website_dir)

    imports = [
        f'@import url("{chrome_dir}/colors.css");',
        f'@import url("{website_dir}/bitwarden.css");',
        f'@import url("{website_dir}/github.css");',
        f'@import url("{website_dir}/youtube.css");',
    ]

    lines = content_file.read_text(encoding="utf-8").splitlines() if content_file.exists() else []
    cleaned_lines = [l for l in lines if l.strip() not in imports]
    new_lines = [cleaned_lines[0]] + imports + cleaned_lines[1:] if cleaned_lines else imports
    content_file.write_text("\n".join(new_lines) + "\n", encoding="utf-8")


def main():
    default_config = get_default_config_dir()
    default_matugen_input = default_config / "templates"
    default_matugen_output = Path.home() / ".cache/matugen"
    default_website_templates = Path.home() / ".files/resources/matugen-themes/websites"

    epilog_text = """
Matugen configuration example (e.g. ~/.config/matugen/config.toml):

[templates.zen-userchrome]
input_path = '<YOUR_TEMPLATE_DIR>/zen-userchrome.css'
output_path = '~/.cache/matugen/zen-userChrome.css'

[templates.zen-usercontent]
input_path = '<YOUR_TEMPLATE_DIR>/zen-usercontent.css'
output_path = '~/.cache/matugen/zen-userContent.css'

[templates.firefox-website-colors]
input_path = "<YOUR_TEMPLATE_DIR>/firefox-colors.css"
output_path = "~/.cache/matugen/firefox-colors.css"
"""

    parser = argparse.ArgumentParser(
        description="Install Zen Browser theme styles and link Matugen themes.",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=epilog_text,
    )
    parser.add_argument(
        "-c", "--config-dir", type=Path, help="Custom Zen root folder containing profiles and config data", default=default_config
    )
    parser.add_argument(
        "-m", "--matugen-output", type=Path, help="Custom matugen-theme output folder containing generated colors", default=default_matugen_output
    )
    parser.add_argument(
        "-i", "--matugen-input", type=Path, help="Custom matugen-input folder containing template files", default=default_matugen_input
    )
    parser.add_argument(
        "-w", "--websites-templates", type=Path, help="Custom website templates folder", default=default_website_templates
    )
    parser.add_argument("-y", "--yes", action="store_true", help="Automatically answer yes to all prompts")
    args = parser.parse_args()

    config_dir = args.config_dir
    if not any(arg in sys.argv for arg in ("-c", "--config-dir")):
        print("INF: Looking for the 'zen' folder")

    if not config_dir.is_dir():
        print(f"ERR: Zen config dir not found: {config_dir}", file=sys.stderr)
        sys.exit(1)
    else:
        print(f"INF: Using config directory: {config_dir}")

    print("INF: Figuring out, the default zen profile...")
    profile = find_profile(config_dir)

    if not profile or not profile.is_dir():
        print("ERR: Could not determine Zen profile directory.", file=sys.stderr)
        sys.exit(1)

    install_themes(
        config_dir=config_dir,
        profile=profile,
        matugen_input=args.matugen_input,
        matugen_output=args.matugen_output,
        website_templates=args.websites_templates,
        auto_yes=args.yes,
    )


if __name__ == "__main__":
    main()
