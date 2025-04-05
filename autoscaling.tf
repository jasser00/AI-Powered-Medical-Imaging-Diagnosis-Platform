module "asg_spot_instances" {
  source = "terraform-aws-modules/autoscaling/aws"
  name   = "instance-req-jasser"

  vpc_zone_identifier = module.test_vpc.private_subnets
  min_size            = 0
  max_size            = 500
  desired_capacity    = 1
  default_cooldown    = 350
  user_data           = file("${path.module}/app.sh")
  scaling_policies = {
    avg-cpu-policy-greater-than-50 = {
      policy_type               = "TargetTrackingScaling"
      estimated_instance_warmup = 1200
      target_tracking_configuration = {
        predefined_metric_specification = {
          predefined_metric_type = "ASGAverageCPUUtilization"
        }
        target_value = 75
      }
    }
  }
  initial_lifecycle_hooks = [
    {
      name                  = "ExampleStartupLifeCycleHook"
      default_result        = "CONTINUE"
      heartbeat_timeout     = 60
      lifecycle_transition  = "autoscaling:EC2_INSTANCE_LAUNCHING"
      notification_metadata = jsonencode({ "hello" = "world" })
    },
    {
      name                  = "ExampleTerminationLifeCycleHook"
      default_result        = "CONTINUE"
      heartbeat_timeout     = 180
      lifecycle_transition  = "autoscaling:EC2_INSTANCE_TERMINATING"
      notification_metadata = jsonencode({ "goodbye" = "world" })
    }
  ]

  instance_refresh = {
    strategy = "Rolling"
    preferences = {
      checkpoint_delay       = 600
      checkpoint_percentages = [35, 70, 100]
      instance_warmup        = 300
      min_healthy_percentage = 50
      max_healthy_percentage = 100
    }
  }

  launch_template_name        = "example-asg"
  launch_template_description = "Launch template example"
  update_default_version      = true

  image_id          = data.aws_ami.ubuntu_ami.id
  ebs_optimized     = true
  enable_monitoring = true

  create_iam_instance_profile = true
  iam_role_name               = "example-asg"
  iam_role_path               = "/ec2/"
  iam_role_description        = "IAM role example"
  iam_role_tags = {
    CustomIamRole = "Yes"
  }
  iam_role_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }

  use_mixed_instances_policy = true
  mixed_instances_policy = {
    override = [
      {
        instance_requirements = {
          cpu_manufacturers = ["amd"]
          memory_gib_per_vcpu = {
            min = 2
            max = 4
          }
          memory_mib = {
            min = 2048 # 2 GiB
          }
          vcpu_count = {
            min = 2
            max = 4
          }
          max_spot_price_as_percentage_of_optimal_on_demand_price = 50
        }
      }
    ]
  }

  tags = local.common
}
