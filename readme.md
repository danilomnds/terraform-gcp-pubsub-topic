# Module - Pub/Sub Topic
[![COE](https://img.shields.io/badge/Created%20By-CCoE-blue)]()[![HCL](https://img.shields.io/badge/language-HCL-blueviolet)](https://www.terraform.io/)[![GCP](https://img.shields.io/badge/provider-GCP-green)](https://registry.terraform.io/providers/hashicorp/google/latest)

Module developed to standardize the creation of Pub/Sub Topic.

## Compatibility Matrix

| Module Version | Terraform Version | Google Version     |
|----------------|-------------------| ------------------ |
| v1.0.0         | v1.13.0           | 6.49.2             |

## Release Notes

| Module Version | Note | 
|----------------|------|
| v1.0.0 | Initial Version |

## Specifying a version

To avoid that your code get the latest module version, you can define the `?ref=***` in the URL to point to a specific version.
Note: The `?ref=***` refers a tag on the git module repo.

## Default use case
```hcl
module "pbs-name" {    
  source = "git::https://github.com/danilomnds/terraform-gcp-pubsub-topic?ref=v1.0.0"
  project = "project_id"
  name = "pbs-name"
  message_retention_duration = "604800s"  ## 7 days #
  message_storage_policy = {
    allowed_persistence_regions = [
      "us-east1", "us-east4", "us-east5"
    ]
  }
  labels = {
    diretoria   = "ctio"
    area        = "area"
    system      = "system"    
    environment = "fqa"
    projinfra   = "0001"
    dm          = "00000000"
    provider    = "gcp"
    region      = "southamerica-east1"
  }  
}
output "id" {
  value = module.pbs-name.id
}
```

## Default use case plus RBAC
```hcl  
module "pbs-name" {    
  source = "git::https://github.com/danilomnds/terraform-gcp-pubsub-topic?ref=v1.0.0"
  project = "project_id"
  name = "pbs-name"
  message_retention_duration = "604800s"  ## 7 days #
  members = ["group:GRP_GCP-SYSTEM-PRD@timbrasil.com.br"]  
  message_storage_policy = {
    allowed_persistence_regions = [
      "us-east1", "us-east4", "us-east5"
    ]
  }
  labels = {
    diretoria   = "ctio"
    area        = "area"
    system      = "system"    
    environment = "fqa"
    projinfra   = "0001"
    dm          = "00000000"
    provider    = "gcp"
    region      = "southamerica-east1"
  }  
}
output "id" {
  value = module.pbs-name.id
}
```

## Input variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Name of the topic | `string` | n/a | `Yes` |
| kms_key_name | The resource name of the Cloud KMS CryptoKey to be used to protect access to messages published on this topic | `string` | n/a | No |
| labels | Labels with user-defined metadata | `map(string)` | n/a | No |
| message_storage_policy | Policy constraining the set of Google Cloud Platform regions where messages published to the topic may be stored. See the documentation [here](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_topic) | `object({})` | n/a | No |
| schema_settings | Settings for validating messages published against a schema. See the documentation [here](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_topic) | `object({})` | n/a | No |
| message_retention_duration | Indicates the minimum duration to retain a message after it is published to the topic | `string` | n/a | No |
| ingestion_data_source_settings | Settings for ingestion from a data source into this topic. See the documentation [here](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_topic) | `object({})` | n/a | No |
| message_transforms | Transforms to be applied to messages published to the topicd. See the documentation [here](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_topic) | `object({})` | n/a | No |
| project | The ID of the project in which the resource belongs. If it is not provided, the provider project is used | `string` | n/a | No |
| members | list of azure AD groups that will use the resource | `list(string)` | n/a | No |
| subscriber_role | Should Pub/Sub Subscriber be granted?  | `bool` | `false` | No |

# Object variables for blocks

Please check the documentation [here](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_topic)

## Output variables

| Name | Description |
|------|-------------|
| id | pub/sub topic id|

## Documentation
Pub/Sub Topic: <br>
[https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_topic](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_topic)