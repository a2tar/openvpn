class openvpn::server::iptables_rules (
	$network = '10.8.0.0/24', # default openvpn network
	$file    = '/tmp/openvpn-iptables.rules',
) {
	package { "iptables" :
	    ensure  => 'installed',
	}
	file { $file :
		ensure  => present,
		owner   => 'root',
		group   => 'root',
		mode    => 0700,
		content => template("openvpn/iptables.rules.erb"),
		notify  => Exec["load_iptables_rules"],
	}
	exec { "load_iptables_rules" :
		command     => $file,
		# subscribe   => File[$file],
		refreshonly => true
	}
}