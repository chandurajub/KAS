resource "aws_instance" "jenkins" {
  ami           = "ami-0c84a3e93390c29bc"
  instance_type  = "t3.micro"
  availability_zone = "us-west-2a"
  tags = {
    Name = "jenkins"
  }
  iam_instance_profile = "instance_role"
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
}

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = "vol-03c5753c0de574ec8"
  instance_id = aws_instance.jenkins.id
}

resource "null_resource" "jenkins-install" {
  triggers = {
    date   = timestamp()
  }
  connection {
    host                  = aws_instance.jenkins.private_ip
    user                  = "root"
    password              = "DevOps321"
  }

  provisioner "file" {
    source                  = "scripts/install-jenkins.sh"
    destination             = "/tmp/jenkins.sh"
  }

  provisioner "file" {
    source                  = "scripts/02admin-user.groovy"
    destination             = "/tmp/02admin-user.groovy"
  }

  provisioner "file" {
    source                  = "scripts/01plugins.groovy"
    destination             = "/tmp/01plugins.groovy"
  }

  provisioner "file" {
    source                  = "scripts/03authorize.groovy"
    destination             = "/tmp/03authorize.groovy"
  }

  provisioner "remote-exec" {
    inline                  = [
      "sh /tmp/jenkins.sh","curl -s https://raw.githubusercontent.com/linuxautomations/labautomation/master/tools/terraform/install.sh|sudo bash"
    ]
  }
}

