class openvpn::service {
	service { "openvpn":
		ensure      => running,
		hasstatus   => true,
		hasrestart  => true,
		enable      => true,
		require     => Class["openvpn::install"],
	}
}