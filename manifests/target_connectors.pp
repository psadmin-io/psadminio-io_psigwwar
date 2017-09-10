# io_psigwwar::target_connectors
#
# Place target connectors in the PSIGW.war servlet
#
# For those needing to place any custom connectors or the
# SSL target connector delivered with Campus Solutions. This
# Class will take an archive which starts at the root of PSIGW.war
# and extract it in to your gateway. 
#
# @example
#   include io_psigwwar::target_connectors

class io_psigwwar::target_connectors (
  $target_connectors = io_psigwwar::target_connectors,
){
  target_connectors.each |$connector_name, $connector_archive| {
    # extract archive to PSIGW.war
  }
}
