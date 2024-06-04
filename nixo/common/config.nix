{
  # The main user name
  username = "thiago";

  # Do not modify the variable below.
  # We're using it to make sure that home-manager's stateVersion is in sync with the system's stateVersion.
  state = "23.11";

	# System specific configuration that must be shared. e.g. hostname that should be shared with flake.nix
  system = {
	  hostname = "nixo";
  };
}
