class { "openvpn::server::config":
  port  => 443,
  proto => 'tcp',
  ca    => 'default_pki',
}
