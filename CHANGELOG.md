# [4.1.0](https://github.com/Hamz-06/terraform-aws-ec2/compare/v4.0.0...v4.1.0) (2026-08-08)


### Features

* **ec2:** support custom IAM policy documents for instance role ([2ca15ac](https://github.com/Hamz-06/terraform-aws-ec2/commit/2ca15ac7df981a925154f9dcecee13af94349671))

# [4.0.0](https://github.com/Hamz-06/terraform-aws-ec2/compare/v3.0.0...v4.0.0) (2026-08-05)


### Features

* **ec2:** make subnet_id required ([7d46892](https://github.com/Hamz-06/terraform-aws-ec2/commit/7d46892fc8df366aa5c1b5927204aaf87c0628cc))


### BREAKING CHANGES

* **ec2:** subnet_id no longer optional.

# [3.0.0](https://github.com/Hamz-06/terraform-aws-ec2/compare/v2.0.0...v3.0.0) (2026-04-12)


### Features

* **infra:** remove vpc module ([cbe24b1](https://github.com/Hamz-06/terraform-aws-ec2/commit/cbe24b1f74701928df4d52d35bba75bf13743ee3))


### BREAKING CHANGES

* **infra:** VPC module has been removed from infrastructure stack

# [2.0.0](https://github.com/Hamz-06/terraform-aws-ec2/compare/v1.1.0...v2.0.0) (2025-10-26)


### Features

* create aws_key_pair by default ([815df51](https://github.com/Hamz-06/terraform-aws-ec2/commit/815df51419cb86f5016f923f9dc873692494f9e2))


### BREAKING CHANGES

* EC2 key creation is now automatic by default

# [1.1.0](https://github.com/Hamz-06/terraform-aws-ec2/compare/v1.0.2...v1.1.0) (2025-10-25)


### Features

* **tf:** add associate public ip + security group ingress ([010eabc](https://github.com/Hamz-06/terraform-aws-ec2/commit/010eabcb0db3a238fc4cd22dd8b2f1386b046b02))

## [1.0.2](https://github.com/Hamz-06/terraform-aws-ec2/compare/v1.0.1...v1.0.2) (2025-10-24)


### Bug Fixes

* **ci:** semantic release test ([79f75eb](https://github.com/Hamz-06/terraform-aws-ec2/commit/79f75eb2d99c4eee021fefa40141785104455d41))
