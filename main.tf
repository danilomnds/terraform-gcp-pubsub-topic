# Create a Pub/Sub topic with various optional settings
resource "google_pubsub_topic" "topic" {
  name         = var.name
  kms_key_name = var.kms_key_name
  labels       = var.labels

  # Optional message storage policy block
  dynamic "message_storage_policy" {
    for_each = var.message_storage_policy != null ? [var.message_storage_policy] : []
    content {
      allowed_persistence_regions = message_storage_policy.value.allowed_persistence_regions
      enforce_in_transit          = lookup(message_storage_policy.value, "enforce_in_transit", null)
    }
  }

  # Optional schema settings block
  dynamic "schema_settings" {
    for_each = var.schema_settings != null ? [var.schema_settings] : []
    content {
      schema   = schema_settings.value.schema
      encoding = schema_settings.value.encoding
    }
  }

  message_retention_duration = var.message_retention_duration

  # Optional ingestion data source settings block
  dynamic "ingestion_data_source_settings" {
    for_each = var.ingestion_data_source_settings != null ? [var.ingestion_data_source_settings] : []
    content {
      # AWS Kinesis ingestion settings
      dynamic "aws_kinesis" {
        for_each = ingestion_data_source_settings.value.aws_kinesis != null ? [ingestion_data_source_settings.value.aws_kinesis] : []
        content {
          stream_arn          = aws_kinesis.value.stream_arn
          consumer_arn        = aws_kinesis.value.consumer_arn
          aws_role_arn        = aws_kinesis.value.aws_role_arn
          gcp_service_account = aws_kinesis.value.gcp_service_account
        }
      }

      # Cloud Storage ingestion settings
      dynamic "cloud_storage" {
        for_each = ingestion_data_source_settings.value.cloud_storage != null ? [ingestion_data_source_settings.value.cloud_storage] : []
        content {
          bucket = cloud_storage.value.bucket
          # Optional text format settings
          dynamic "text_format" {
            for_each = cloud_storage.value.text_format != null ? [cloud_storage.value.text_format] : []
            content {
              delimiter = lookup(text_format.value, "delimiter", null)
            }
          }
          # Optional settings for object creation time and glob matching
          minimum_object_create_time = lookup(cloud_storage.value, "minimum_object_create_time", null)
          match_glob                 = lookup(cloud_storage.value, "match_glob", null)
        }
      }

      # Platform logs ingestion settings
      dynamic "platform_logs_settings" {
        for_each = ingestion_data_source_settings.value.platform_logs_settings != null ? [ingestion_data_source_settings.value.platform_logs_settings] : []
        content {
          severity = lookup(platform_logs_settings.value, "severity", null)
        }
      }

      # Azure Event Hubs ingestion settings
      dynamic "azure_event_hubs" {
        for_each = ingestion_data_source_settings.value.azure_event_hubs != null ? [ingestion_data_source_settings.value.azure_event_hubs] : []
        content {
          resource_group      = lookup(azure_event_hubs.value, "resource_group", null)
          namespace           = lookup(azure_event_hubs.value, "namespace", null)
          event_hub           = lookup(azure_event_hubs.value, "event_hub", null)
          client_id           = lookup(azure_event_hubs.value, "client_id", null)
          tenant_id           = lookup(azure_event_hubs.value, "tenant_id", null)
          subscription_id     = lookup(azure_event_hubs.value, "subscription_id", null)
          gcp_service_account = lookup(azure_event_hubs.value, "gcp_service_account", null)
        }
      }

      # AWS MSK ingestion settings
      dynamic "aws_msk" {
        for_each = ingestion_data_source_settings.value.aws_msk != null ? [ingestion_data_source_settings.value.aws_msk] : []
        content {
          cluster_arn         = aws_msk.value.cluster_arn
          topic               = aws_msk.value.topic
          aws_role_arn        = aws_msk.value.aws_role_arn
          gcp_service_account = aws_msk.value.gcp_service_account
        }
      }

      # Confluent Cloud ingestion settings
      dynamic "confluent_cloud" {
        for_each = ingestion_data_source_settings.value.confluent_cloud != null ? [ingestion_data_source_settings.value.confluent_cloud] : []
        content {
          bootstrap_server    = confluent_cloud.value.bootstrap_server
          cluster_id          = confluent_cloud.value.cluster_id
          topic               = confluent_cloud.value.topic
          identity_pool_id    = confluent_cloud.value.identity_pool_id
          gcp_service_account = confluent_cloud.value.gcp_service_account
        }
      }
    }
  }

  # Optional message transforms block
  dynamic "message_transforms" {
    for_each = var.message_transforms != null ? [var.message_transforms] : []
    content {
      # JavaScript UDF transform settings
      dynamic "javascript_udf" {
        for_each = message_transforms.value.javascript_udf != null ? [message_transforms.value.javascript_udf] : []
        content {
          function_name = javascript_udf.value.function_name
          code          = javascript_udf.value.code
        }
      }
      # Whether the transform is disabled
      disabled = lookup(message_transforms.value, "disabled", true)
    }
  }

  project = var.project

  # Lifecycle settings (currently ignoring no changes)
  lifecycle {
    ignore_changes = []
  }
}

# Grant Pub/Sub viewer role to specified members
resource "google_pubsub_topic_iam_member" "topicviewer" {
  depends_on = [google_pubsub_topic.topic]
  for_each   = { for member in var.members : member => member }
  project    = var.project
  topic      = google_pubsub_topic.topic.name
  role       = "roles/pubsub.viewer"
  member     = each.value
}

# Grant Pub/Sub subscriber role to specified members if enabled
resource "google_pubsub_topic_iam_member" "topicsubscriber" {
  depends_on = [google_pubsub_topic.topic]
  for_each = { for member in var.subscriber_members : member => member
  if var.subscriber_role }
  project = var.project
  topic   = google_pubsub_topic.topic.name
  role    = "roles/pubsub.subscriber"
  member  = each.value
}

# Grant Pub/Sub subscriber role to specified members if enabled
resource "google_pubsub_topic_iam_member" "topicspublisher" {
  depends_on = [google_pubsub_topic.topic]
  for_each = { for member in var.publisher_members : member => member
  if var.publisher_role }
  project = var.project
  topic   = google_pubsub_topic.topic.name
  role    = "roles/pubsub.publisher"
  member  = each.value
}