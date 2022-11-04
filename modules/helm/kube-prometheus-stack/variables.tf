variable "namespace" {
  description = "Namespace to deploy the application"
  type        = string
  default     = "monitoring"
}

variable "chart_version" {
  description = "Chart version"
  type        = string
  default     = "15.4.4"
}

variable "cluster_id" {
  description = "EKS cluster ID"
  type        = string
}

variable "bucket_name" {
  description = "S3 bucket name for thanos long term storage"
  type        = string
  default = "thanos-bucket-33121"
  
}