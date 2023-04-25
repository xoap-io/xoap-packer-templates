[![Maintained](https://img.shields.io/badge/Maintained%20by-XOAP-success)](https://xoap.io)
[![Packer](https://img.shields.io/badge/Packer-%3E%3D1.8.0-blue)](https://packer.io)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

# Table of Contents

- [Table of Contents](#table-of-contents)
  - [Introduction](#introduction)
  - [Guidelines](#guidelines)
  - [Share the Love](#share-the-love)
  - [Contributing](#contributing)
  - [Bug Reports and Feature Requests](#bug-reports--feature-requests)
  - [Developing](#developing)
    - [Usage](#usage)
      - [Installation](#installation)
      - [Prerequisites](#prerequisites)
      - [Windows Updates](#windows-updates)

---

## Introduction

This is the XOAP Packer repository.

It is part of our [XOAP](https://xoap.io) Automation Forces Open Source community library to give you a quick start into Infrastructure as Code deployments with Packer in addition to image.XO.

Please check the links for more info, including usage information and full documentation:

- [XOAP Website](https://xoap.io)
- [XOAP Documentation](https://docs.xoap.io)
- [Twitter](https://twitter.com/xoap_io)
- [LinkedIn](https://www.linkedin.com/company/xoap_io)

---

## Guidelines

We are using the following guidelines to write code and make it easier for everyone to follow a distinctive guideline.
Please check these links before starting to work on changes.

[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-2.1-4baaaa.svg)](CODE_OF_CONDUCT.md)

Git Naming Conventions are an important part of the development process.
They describe how Branches, Commit Messages,
Pull Requests and Tags should look like to make them easily understandable for everybody in the development chain.

[Git Naming Conventions](https://namingconvention.org/git/)

He Conventional Commits specification is a lightweight convention on top of commit messages.
It provides an easy set of rules for creating an explicit commit history; which makes it easier to write automated tools on top of.

[Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/)

The better a Pull Request description is, the better a review can understand and decide on how to review the changes.
This improves implementation speed and reduces communication between the requester,
and the reviewer is resulting in much less overhead.

[Writing A Great Pull Request Description](https://www.pullrequest.com/blog/writing-a-great-pull-request-description/)

Versioning is a crucial part for Terraform Stacks and Modules.
Without version tags you cannot clearly create a stable environment
and be sure that your latest changes will not crash your production environment (sure it still can happen,
but we are trying our best to implement everything that we can to reduce the risk)

[Semantic Versioning](https://semver.org)

---

## Share the Love

Like this project? 
Please give it a ★ on [our GitHub](https://github.com/xoap-io/xoap-uberagent-kibana-dashboards)! 
It helps us a lot.

---

## Contributing

### Bug Reports & Feature Requests

Please use the issue tracker to report any bugs or file feature requests.

### Developing

If you are interested in being a contributor and want to get involved in developing this project, we would love to hear from you! Email us.

PRs are welcome. We follow the typical "fork-and-pull" Git workflow.

- Fork the repo on GitHub
- Clone the project to your own machine
- Commit changes to your own branch
- Push your work back up to your fork
- Submit a Pull Request so that we can review your changes

> NOTE: Be sure to merge the latest changes from "upstream" before making a pull request!

---

## Usage

### Installation

You can install Packer from the Hashicorp website: https://developer.hashicorp.com/packer/downloads?product_intent=packer.

### Prerequisites

All the available Packer configurations are provided "as is" without any warranty.

They were tested and run with on following infrastructure:

- macOS Ventura 13.3.1
- Hashicorp Packer 1.8.0
- VMware Fusion Pro 12.3.3
- Windows 10 22H2 Enterprise with Hyper-V

### Pre-Commit-Hooks

We added https://github.com/xoap-io/pre-commit-packer which enables validating and formatting the packer configuration files.

> Every time you commit a change to your packer configuration files, the pre-commit hook will run and validate the configuration.

Additionally it is crucial to have a pkrvars.hcl and a pkr.hcl file in every subfolder so that the packer configuration files are correctly formatted and validated.

### Windows Updates

The filters for the Windows Updates are set as follows:

filters = [
"exclude:$_.Title -like '*Preview*'",
"exclude:$_.Title -like '*Feature update*'",
"include:$true",
]

If you want your images to be updated to the latest feature level, remove the following line:

"exclude:$\_.Title -like '_Feature update_'",

### helper

We added the KMS keys for the Windows based operating systems in helper/key-management-services.md

You can also find all the ISO image related operating system Keys for the unattended.xml in the same directory.

### amazon-ebs builder

#### AMI-IDs

> Be aware of the fact that AMI-Ids are region-specific when defining them in the configuration.

#### Username and Password

> Do not change the winrm user and password because "Administrator" must be specified and the password is generated during the Packer build.

#### Sysprep and Password retrieval

See https://docs.aws.amazon.com/AWSEC2/latest/WindowsGuide/ec2launch-v2.html for more information.

#### AWS account access

> We recommend using a local credentials file or assuming a role instead of specifying an access key and secret.

### azure-arm builder

### vmware-iso builder
