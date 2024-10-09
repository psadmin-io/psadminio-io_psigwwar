# io_psigwwar::igw_prop
#
# update integrationGateway.properties from a hiera hash
# of arbitrary config values.
#
# Allow PeopleSoft customers to update values in the PSIGW
# configuration file that are not accessible from the
# delivered DPK modules.
#
# @example
#   include io_psigwwar::igw_prop
class io_psigwwar::igw_prop (
  $pia_domain_list = $io_psigwwar::pia_domain_list,
  $igw_prop_list   = $io_psigwwar::igw_prop_list,
){

  $pia_domain_list.each |$domain_name, $pia_domain_info| {
    $ps_cfg_home_dir = $pia_domain_info['ps_cfg_home_dir']

    $config   = "${ps_cfg_home_dir}/webserv/${domain_name}/applications/peoplesoft/PSIGW.war/WEB-INF/integrationGateway.properties"

    $defaults = {
      'path'    => $config,
      'section' => '',
    }

    if ($domain_name in $igw_prop_list){
      create_ini_settings($igw_prop_list[$domain_name], $defaults)
    }
  }

  # ini spacing issue - https://github.com/psadmin-io/psadminio-io_psigwwar/issues/3
  # TODO - seems like a hack, will only work on Linux
  # Replace all ` = ` with `=`
  exec { "update-igw_prop-fix-spaces-${domain_name}":
    command    => "sed -i 's/ = /=/' ${config}",
    path       => [ '/usr/bin', '/bin', '/usr/sbin' ],
  }
}
