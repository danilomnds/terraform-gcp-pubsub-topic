variable "name" {
  type = string
}

variable "kms_key_name" {
  type    = string
  default = null
}

variable "labels" {
  type    = map(string)
  default = null
}

variable "message_storage_policy" {
  type = object({
    allowed_persistence_regions = list(string)
    enforce_in_transit          = optional(bool)
  })
  default = null
}

variable "schema_settings" {
  type = object({
    schema   = string
    encoding = optional(string)
  })
  default = null
}

variable "message_retention_duration" {
  type    = string
  default = null
}

variable "ingestion_data_source_settings" {
  type = object({
    aws_kinesis = optional(object({
      stream_arn          = string
      consumer_arn        = string
      aws_role_arn        = string
      gcp_service_account = string
    }))
    cloud_storage = optional(object({
      bucket = string
      text_format = optional(object({
        delimiter = optional(string)
      }))
      avro_format                = optional(string)
      pubsub_avro_format         = optional(string)
      minimum_object_create_time = optional(string)
      match_glob                 = optional(string)
    }))
    platform_logs_settings = optional(object({
      severity = optional(string)
    }))
    azure_event_hubs = optional(object({
      resource_group      = optional(string)
      namespace           = optional(string)
      event_hub           = optional(string)
      client_id           = optional(string)
      tenant_id           = optional(string)
      subscription_id     = optional(string)
      gcp_service_account = optional(string)
    }))
    aws_msk = optional(object({
      cluster_arn         = string
      topic               = string
      aws_role_arn        = string
      gcp_service_account = string
    }))
    confluent_cloud = optional(object({
      bootstrap_server    = string
      cluster_id          = string
      topic               = string
      identity_pool_id    = string
      gcp_service_account = string
    }))
  })
  default = null
}

variable "message_transforms" {
  type = object({
    javascript_udf = optional(object({
      function_name = string
      code          = string
    }))
    disabled = optional(bool)
  })
  default = null
}

variable "project" {
  type    = string
  default = null
}

variable "members" {
  type    = list(string)
  default = []
}

variable "subscriber_role" {
  type    = bool
  default = false
}