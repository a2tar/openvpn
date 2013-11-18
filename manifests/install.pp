class openvpn::install (
	$ensure  = 'installed',
	$package = 'openvpn',
) {
  include apt
	apt::key { 'OpenVPN GPG Key':
		key        => '2048R',
		key_source => 'http://repos.openvpn.net/repos/repo-public.gpg',
	} ->
	apt::source { 'repos.openvpn.net' :
		location    => 'http://repos.openvpn.net/repos/apt/precise-snapshots',
		repos       => 'main',
		release     => 'precise',
		include_src => false,
	} ->
	package { $package :
	    ensure  => $ensure,
	}
}