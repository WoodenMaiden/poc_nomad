job "agrold" {
  datacenters = ["*"]

  // Because Agrold is a long-live service
  type = "service"

  // Run the job only on Linux, because we use docker.
  constraint {
    attribute = "${attr.kernel.name}"
    operator  = "set_contains"
    value     = "linux"
  }

  group "webapp" {

    network {
      port "http" {
        to = 8080
      }
    }

    task "tomcat" {
      driver = "docker"
      config {
        image = "10.9.2.21:8080/agrolddev:latest"

        ports = ["http"]
      }

      env {
        CATALINA_OPTS = join(" ", [
          "-Dagrold.db_connection_url='someurl/agrolddb?useSSL=false'",
          "-Dagrold.db_username='app'",
          "-Dagrold.db_password='zerk4_z'",
          "-Dagrold.name='agrolddev'",
          "-Dagrold.baseurl='http://localhost/'",
          "-Dagrold.sparql_endpoint='http://sparql.southgreen.fr'",
          "-Dagrold.rf_link='http://someurl'"
        ])
        BITNAMI_DEBUG                  = "false"
        TOMCAT_ALLOW_REMOTE_MANAGEMENT = "1"
        TOMCAT_PASSWORD                = "password"
        TOMCAT_USERNAME                = "manager"       
      }
    }

    // task "mysql" {
    //   driver = "docker"
    //   config {
    //     image = "mysql:5.7"
    //   }

    //   env {
    //     MYSQL_ROOT_PASSWORD = "ezbjp4"
    //     MYSQL_DATABASE      = "agrolddb"
    //   }
    // }
  }
}