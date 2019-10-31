region = "us-east-2"

availability_zones = ["us-east-2a", "us-east-2b"]

namespace = "eg"

stage = "test"

name = "ecs-web-app"

vpc_cidr_block = "172.16.0.0/16"

internal = false

http_enabled = true

access_logs_enabled = true

alb_access_logs_s3_bucket_force_destroy = true

access_logs_region = "us-east-2"

cross_zone_load_balancing_enabled = true

http2_enabled = true

idle_timeout = 60

ip_address_type = "ipv4"

deletion_protection_enabled = false

deregistration_delay = 15

health_check_path = "/"

health_check_timeout = 10

health_check_healthy_threshold = 2

health_check_unhealthy_threshold = 2

health_check_interval = 15

health_check_matcher = "200-399"

target_group_port = 80

target_group_target_type = "ip"

authentication_type = ""

unauthenticated_priority = 100

unauthenticated_paths = ["/"]

slow_start = 0

stickiness_enabled = false
