# INSTALL OPENSSL
      ```
      sudo yum install -y mod_ssl
      openssl genrsa 2048 > my-aws-private.key
      sudo yum  install openssl -y
      openssl genrsa 2048 > my-aws-private.key
      openssl req -new -x509 -nodes -sha1 -days 3650 -extensions v3_ca -key my-aws-private.key > my-aws-public.crt
      openssl pkcs12 -inkey my-aws-private.key -in my-aws-public.crt -export -out my-aws-public.p12
      awscli
      curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
      unzip awscliv2.zip
      sudo ./aws/install
      aws --version
      aws configure
      aws acm import-certificate --certificate fileb://my-aws-public.crt --private-key fileb://my-aws-private.key --region us-east-1
      openssl pkcs12 -inkey my-aws-private.key -in my-aws-public.crt -export -out my-aws.p12	
      ```

# https://medium.com/@chamilad/adding-a-self-signed-ssl-certificate-to-aws-acm-88a123a04301
