/*resource "aws_instance" "Terraform_instance" {
  ami           = "ami-007020fd9c84e18c7"
  instance_type = "t2.micro"
  subnet_id     = "subnet-0fc24d3949e171bcf"
  security_groups = ["sg-0e272864109ba6399"]
  key_name = "jenkins_2"
  count = "1"

  tags = {
    Name = "my_Terra_instance"
  }
}
*/
