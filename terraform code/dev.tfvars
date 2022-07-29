region     = "us-central1"
zone       = "us-central1-a"
project_id = "belal-357614"

credentials_file_path = "./belal-357614-8cd5bac72a0e.json"
service_account       = "service1@belal-357614.iam.gserviceaccount.com"
cluster_node_zones    = ["us-central1-b"]


machine_type       = "e2-small"
management-sb-cidr = "10.0.0.0/16"
restricted-sb-cidr = "10.10.0.0/16"

master-ip-cidr   = "10.100.100.0/28"
pods-ip-cidr     = "10.101.0.0/16"
services-ip-cidr = "10.102.0.0/16"