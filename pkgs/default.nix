inputs: self: super: {
  # our packages are accessible via link.<name>
  link = { candy-icon-theme = super.pkgs.callPackage ./candy-icon-theme { }; };
}
