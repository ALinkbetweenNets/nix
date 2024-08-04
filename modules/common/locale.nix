{
  lib,
  pkgs,
  config,
  ...
}:
{
  # Set your time zone.
  time.timeZone = "Europe/Berlin";
  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    # LANGUAGE = "en_US.UTF-8";
    # LANG = "en_US.UTF-8";
    LC_ADDRESS = "de_DE.UTF-8";
    LC_COLLATE = "de_DE.UTF-8";
    LC_CTYPE = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_MESSAGES = "en_US.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "en_DK.UTF-8";
    # LC_ALL = "en_US.UTF-8";
  };
  # Configure console keymap
  console.keyMap = "de";
}
