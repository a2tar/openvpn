class openvpn::server::config (
  $ca           = 'default_pki',
  $ip           = $::ipaddress,
  $port         = 1194,
  $proto        = 'udp',
  $dev          = 'tun',
  $local_net    = '10.8.0.0',
  $local_mask   = '255.255.255.0',
  $local_mask_s = '/24',
  $local_ip     = '10.8.0.1', # used for: firewall rules and dns resolver
  $duplicate_cn = true,
  $cipher       = 'AES-128-CBC',
  $status_log   = '/dev/null',
  $log          = '/dev/null',
  $log_append   = '/dev/null',
  $verb         = 3,
  $ensure       = 'present',) {
  include openvpn::install
  include openvpn::service

  sysctl::config { "net.ipv4.ip_forward": value => 1; }
  $network = "$local_net$local_mask_s"

  class { "openvpn::server::iptables_rules": network => "$local_net$local_mask_s" }

  class { "dnsmasq::config":
    ip      => $local_ip,
    require => Class["openvpn::service"],
  }

  # Files
  file { "down.sh":
    path    => "/etc/openvpn/down.sh",
    ensure  => $ensure,
    owner   => 'root',
    group   => 'root',
    mode    => 0755,
    source  => "puppet:///modules/openvpn/down.sh",
    require => Class["openvpn::install"],
  }

  file { "up.sh":
    path    => "/etc/openvpn/up.sh",
    ensure  => $ensure,
    owner   => 'root',
    group   => 'root',
    mode    => 0755,
    source  => "puppet:///modules/openvpn/up.sh",
    require => Class["openvpn::install"],
  }

  ###############################################################
  # Certificates
  ###############################################################
  file { "/etc/openvpn/$ca":
    ensure  => "directory",
    require => Class["openvpn::install"],
  }

  if $ca = 'default_pki' {
    $file_src_dir = 'puppet:///modules/openvpn/default_pki'
  } else {
    $file_src_dir = "puppet:///files/openvpn/$ca"
  }

  file { "ca.crt":
    path    => "/etc/openvpn/$ca/ca.crt",
    ensure  => $ensure,
    owner   => 'root',
    group   => 'root',
    mode    => 0644,
    source  => "$file_src_dir/ca.crt",
    require => Class["openvpn::install"],
  }

  file { "dh.pem":
    path    => "/etc/openvpn/$ca/dh.pem",
    ensure  => $ensure,
    owner   => 'root',
    group   => 'root',
    mode    => 0644,
    source  => "$file_src_dir/dh.pem",
    require => Class["openvpn::install"],
  }

  file { "server.crt":
    path    => "/etc/openvpn/$ca/server.crt",
    ensure  => $ensure,
    owner   => 'root',
    group   => 'root',
    mode    => 0644,
    source  => "$file_src_dir/server.crt",
    require => Class["openvpn::install"],
  }

  file { "server.key":
    path    => "/etc/openvpn/$ca/server.key",
    ensure  => $ensure,
    owner   => 'root',
    group   => 'root',
    mode    => 0600,
    source  => "$file_src_dir/server.key",
    require => Class["openvpn::install"],
  }

  file { "ta.key":
    path    => "/etc/openvpn/$ca/ta.key",
    ensure  => $ensure,
    owner   => 'root',
    group   => 'root',
    mode    => 0600,
    source  => "$file_src_dir/ta.key",
    require => Class["openvpn::install"],
  }

  file { "server.conf":
    path    => "/etc/openvpn/server.conf",
    ensure  => $ensure,
    owner   => 'root',
    group   => 'root',
    mode    => 0644,
    content => template("openvpn/server.conf.erb"),
    require => Class["openvpn::install"],
    notify  => Class["openvpn::service"],
  }
}
