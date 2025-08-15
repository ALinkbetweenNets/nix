inputs: self: super: {
  # our packages are accessible via link.<name>
  link = { candy-icon-theme = super.callPackage ./candy-icon-theme { }; };
}
