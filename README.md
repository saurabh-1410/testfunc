# testfunc

# Usage
# Primary server use -  

puppet apply -e 'testfunc::my_custom_function("Saurabh")' \n
puppet apply -e 'testfunc::my_custom_function("Hello testing")' --debug \n

# write a script to listen and force TLS1_1 or 1_2 

```
[root@rep2383 ~]# cat server.py
from http.server import HTTPServer, SimpleHTTPRequestHandler
import ssl

# Use TLS 1.1 only (change for other version of TLS like TLSv1_2 or TLSv1_3)
context = ssl.SSLContext(ssl.PROTOCOL_TLSv1_1)

# Enforce client certificate authentication
context.verify_mode = ssl.CERT_REQUIRED
context.load_cert_chain(
    certfile='/etc/puppetlabs/puppet/ssl/certs/rep2383.us-west1-c.c.customer-support-scratchpad.internal.pem',
    keyfile='/etc/puppetlabs/puppet/ssl/private_keys/rep2383.us-west1-c.c.customer-support-scratchpad.internal.pem'
)
context.load_verify_locations(
    cafile='/etc/puppetlabs/puppet/ssl/certs/ca.pem'
)

# Start HTTPS server
server_address = ('0.0.0.0', 8443)
httpd = HTTPServer(server_address, SimpleHTTPRequestHandler)
httpd.socket = context.wrap_socket(httpd.socket, server_side=True)

print("Listening on port 8443 with ONLY TLS 1.2 and client certs...")
httpd.serve_forever()


[root@rep2383 ~]#
```

####On the client side test 

```
  77  curl --cert /etc/puppetlabs/puppet/ssl/certs/$(hostname -f).pem --key /etc/puppetlabs/puppet/ssl/private_keys/$(hostname -f).pem --cacert /etc/puppetlabs/puppet/ssl/certs/ca.pem https://rep2383.us-west1-c.c.customer-support-scratchpad.internal:8443 -v
   78  curl --tlsv1.1 --cert /etc/puppetlabs/puppet/ssl/certs/$(hostname -f).pem --key /etc/puppetlabs/puppet/ssl/private_keys/$(hostname -f).pem --cacert /etc/puppetlabs/puppet/ssl/certs/ca.pem https://rep2383.us-west1-c.c.customer-support-scratchpad.internal:8443 -v


   74  openssl s_client -connect rep2383.us-west1-c.c.customer-support-scratchpad.internal:8443   -tls1_2   -cert /etc/puppetlabs/puppet/ssl/certs/$(hostname -f).pem   -key /etc/puppetlabs/puppet/ssl/private_keys/$(hostname -f).pem -CAfile /etc/puppetlabs/puppet/ssl/certs/ca.pem
   75  openssl s_client -connect rep2383.us-west1-c.c.customer-support-scratchpad.internal:8443   -tls1_1   -cert /etc/puppetlabs/puppet/ssl/certs/$(hostname -f).pem   -key /etc/puppetlabs/puppet/ssl/private_keys/$(hostname -f).pem -CAfile /etc/puppetlabs/puppet/ssl/certs/ca.pem
```


