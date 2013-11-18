define openvpn::server::vpn_cfg_file(
  $ensure = present,
  $mode   = 0600,
  $cfg    = '',
){
  file { $name :
    path    => "/etc/openvpn/$name",
    ensure  => $ensure,
    owner   => 'root',
    group   => 'root',
    mode    => $mode,
    source  => "puppet:///modules/openvpn/down.sh",
    require => Class["openvpn::install"],
  }
}
