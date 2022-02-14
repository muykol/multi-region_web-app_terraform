
locals {
  security_groups = {
    public = {
      name = "alb-firewall"
      ingress = {
        http = {
          from        = 80
          to          = 80
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        }
      }
    }
    private = {
      name = "web-firewall"
      ingress = {
        http = {
          from        = 8080
          to          = 8080
          protocol    = "tcp"
          cidr_blocks = ["10.123.0.0/16", "10.124.0.0/16"]
        }
        maria_db = {
          from        = 3306
          to          = 3306
          protocol    = "tcp"
          cidr_blocks = ["10.123.0.0/16", "10.124.0.0/16"]
        }
      }
    }
  }
}


  