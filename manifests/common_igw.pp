# io_psigwwar::common_igw
#
# Implement a loop over a hash of web servers
#
# This class makes use of the type delivered by Oracle
# in the DPK modules to update a list of Integration
# Gateways using ACM.
#
# The purpose of this is to enable the use of a dedicated
# set of gateway servers and ensure that all of them are
# updated when Puppet runs
#
# @example
#   include io_psigwwar::common_igw
class io_psigwwar::common_igw (
  $servers                = io_psigwwar::servers,
  $appsrv_pubsub_list     = io_psigwwar::appsrv_pubsub_list,

  $ib_node_proxy_userid   = io_psigwwar::ib_node_proxy_userid,
  $ib_node_proxy_password = io_psigwwar::ib_node_proxy_password,

  $ps_home_location       = io_psigwwar::ps_home_location,
  $os_user                = io_psigwwar::os_user,

  $jolt_port              = io_psigwwar::jolt_port,
  $domain_conn_pwd        = io_psigwwar::domain_conn_pwd,
  $db_name                = io_psigwwar::db_name,
  $db_type                = io_psigwwar::db_type,
  $db_user                = io_psigwwar::db_user,
  $db_user_pwd            = io_psigwwar::db_user_pwd,
  $db_connect_id          = io_psigwwar::db_connect_id,
  $db_connect_pwd         = io_psigwwar::db_connect_pwd,

  $default_local_node     = io_psigwwar::default_local_node,
  $gateway_user           = io_psigwwar::gateway_user,
  $gateway_password       = io_psigwwar::gateway_password,

  $gateway_port           = io_psigwwar::gateway_port,
  $gateway_ssl_port       = io_psigwwar::gateway_ssl_port,
  $run_control_id         = io_psigwwar::run_control_id,
  $persist_file           = io_psigwwar::persist_file,
  $tools_release          = io_psigwwar::tools_release,
  $use_ssl_gateway        = io_psigwwar::use_ssl_gateway,
  $ib_set_as_default_node = io_psigwwar::ib_set_as_default_node,
){

  if ($servers != undef) and ($appsrv_pubsub_list != undef) {
    if size($appsrv_pubsub_list) > 1 {
      $appsrv_pubsub_jolt = $appsrv_pubsub_list[0,-2].map |$s2| { "${s2}:${jolt_port}" }
      $appsrv_pubsub_all  = concat($appsrv_pubsub_jolt, $appsrv_pubsub_list[-1])
      $appsrv_pubsub_join = join($appsrv_pubsub_all,',//')
      $appsrv_node_entry  = $appsrv_pubsub_join
    }
    else {
      $appsrv_node_entry  = $appsrv_pubsub_list[0]
    }

    $db_settings = {
      db_name        => $db_name,
      db_type        => $db_type,
      db_opr_id      => $db_user,
      db_opr_pwd     => $db_user_pwd,
      db_connect_id  => $db_connect_id,
      db_connect_pwd => $db_connect_pwd,
    }

    $db_settings_array = join_keys_to_values($db_settings, '=')

    $servers.each |$igw_server| {

      $acm_plugin_list = {
        'PTIBConfigureGatewayNodes'  => {
          'env.default_local_node'           => $default_local_node,
          'env.gateway_host'                 => $igw_server,
          'env.ib_node_proxy_userid'         => $ib_node_proxy_userid,
          'env.use_ssl_gateway'              => $use_ssl_gateway,
          'env.ib_set_as_default_node'       => $ib_set_as_default_node,
          'env.ib_appserver_domain_password' => $domain_conn_pwd,
          'env.ib_jolt_port'                 => $jolt_port,
          'env.ib_node_proxy_password'       => $ib_node_proxy_password,
          'env.gateway_user'                 => $gateway_user,
          'env.gateway_port'                 => $gateway_port,
          'env.gateway_password'             => $gateway_password,
          'env.tools_release'                => $tools_release,
          'env.gateway_ssl_port'             => $gateway_ssl_port,
          'env.ib_appserver_host'            => $appsrv_node_entry,
        }
      }

      $acm_plugin_array  = hash_of_hash_to_array_of_array($acm_plugin_list)

      pt_acm_plugin { "${default_local_node} node setup on ${igw_server}":
        os_user               => $os_user,
        db_settings           => $db_settings_array,
        run_control_id        => $run_control_id,
        persist_property_file => $persist_file,
        plugin_list           => $acm_plugin_array,
        ps_home_dir           => $ps_home_location,
        logoutput             => true,
        loglevel              => debug,
      }
    }
  }
}
