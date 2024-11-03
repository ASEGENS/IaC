terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.0"
    }
  }
}

provider "docker" {}

# Création du réseau
resource "docker_network" "network1" {
  name = "docker-network-iac"
}

# Image Docker pour NGINX
resource "docker_image" "nginx_image" {
  name = "nginx:latest"
}

# Container HTTP
resource "docker_container" "http_container" {
  name      = "http-container"
  image     = docker_image.nginx_image.latest
  networks_advanced {
    name = docker_network.network1.name
  }
  ports {
    internal = 80
    external = 8080
  }
}

# Image Docker pour PHP-FPM
resource "docker_image" "php_fpm_image" {
  name = "php:fpm"
}

# Container SCRIPT
resource "docker_container" "script_container" {
  name      = "script-container"
  image     = docker_image.php_fpm_image.latest
  networks_advanced {
    name = docker_network.network1.name
  }
}
