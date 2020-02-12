class io_psigwwar (
  $servers                = undef,
  $target_connectors      = undef,
  $pia_domain_list        = hiera_hash('pia_domain_list'),
  $igw_prop_list          = hiera_hash('igw_prop_list'),
  $appsrv_pubsub_list     = undef,

  $ib_node_proxy_userid   = hiera(''),
  $ib_node_proxy_password = hiera(''),

  $ps_home_location       = hiera('ps_home_location'),
  $os_user                = hiera('domain_user'),

  $jolt_port              = hiera('jolt_port'),
  $domain_conn_pwd        = hiera('domain_conn_pwd'),
  $db_name                = hiera('db_name'),
  $db_type                = hiera('db_platform'),
  $db_user                = hiera('db_user'),
  $db_user_pwd            = hiera('db_user_pwd'),
  $db_connect_id          = hiera('db_connect_id'),
  $db_connect_pwd         = hiera('db_connect_pwd'),

  $default_local_node     = hiera('gateway_node_name'),
  $gateway_user           = hiera('pia_gateway_user'),
  $gateway_password       = hiera('pia_gateway_user_pwd'),

  $gateway_port           = '8000',
  $gateway_ssl_port       = '8443',
  $run_control_id         = 'intbroker',
  $persist_file           = false,
  $tools_release          = '%ToolsRelease',
  $use_ssl_gateway        = true,
  $ib_set_as_default_node = false,
){
  if ($servers != undef) and ($appsrv_pubsub_list != undef) {
    contain io_psigwwar::common_igw
  }

  if ($igw_prop_list != undef) {
    contain io_psigwwar::igw_prop
  }

  if ($target_connectors!= undef) {
    contain io_psigwwar::target_connectors
  }
}
