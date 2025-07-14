plan testfunc::wait_hello {
  out::message('hello')

  # Wait for 4 minutes (240 seconds)
  notice('Waiting for 4 minutes...')
  sleep(240)

  out::message('bye')
}
