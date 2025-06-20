# See https://puppet.com/docs/puppet/latest/lang_write_functions_in_puppet.html
# for more information on native puppet functions.
function testfunc::my_custom_function(String $arg) {
  notice("Function received: ${arg}")
}
