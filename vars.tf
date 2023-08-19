variable "AWS_REGION"{
    default           = "us-west-2"
    description       = "AWS Region"
}
variable "cidr_blocks"{
    default           = "0.0.0.0/0"
}
variable "cidr_block_cpstn_vpc" {
    default           = "10.0.0.0/16"
}
variable "cidr_block_cpstn_publicsubnet_1"{
    default           = "10.0.1.0/24"
}
variable "cidr_block_cpstn_privatesubnet_1"{
    default           = "10.0.2.0/24"
}
variable "cidr_block_cpstn_publicsubnet_2"{
    default           = "10.0.3.0/24"
}
variable "cidr_block_cpstn_privatesubnet_2"{
    default           = "10.0.4.0/24"
}
