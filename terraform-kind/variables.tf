variable "cluster_name" {
  type        = string
  description = "The cluster's name"
  default     = null
}

variable "image" {
  type        = string
  description = "(Optional) container image to load into the cluster"
  default     = ""
}
