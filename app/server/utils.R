# Copyright (C) 2019 Seven Bridges Genomics Inc. All rights reserved.
#
# This program is licensed under the terms of the GNU Affero General
# Public License version 3 (https://www.gnu.org/licenses/agpl-3.0.txt).

# define the token generation url and view file url
# which can be used in the ui
.platforms <- list(
  "aws-us" = list(
    "token_url" = "https://igor.sbgenomics.com/developer#token",
    "file_url" = "https://igor.sbgenomics.com/u/",
    "public_app_url" = "https://igor.sbgenomics.com/public/apps#",
    "wf_url" = "https://igor.sbgenomics.com/raw/",
    "base_url" = "https://api.sbgenomics.com/v2/"
  ),
  "aws-eu" = list(
    "token_url" = "https://eu.sbgenomics.com/developer#token",
    "file_url" = "https://eu.sbgenomics.com/u/",
    "public_app_url" = "https://eu.sbgenomics.com/public/apps#",
    "wf_url" = "https://eu.sbgenomics.com/raw/",
    "base_url" = "https://eu-api.sbgenomics.com/v2/"
  ),
  "cgc" = list(
    "token_url" = "https://cgc.sbgenomics.com/developer#token",
    "file_url" = "https://cgc.sbgenomics.com/u/",
    "public_app_url" = "https://cgc.sbgenomics.com/public/apps",
    "wf_url" = "https://cgc.sbgenomics.com/raw/",
    "base_url" = "https://cgc-api.sbgenomics.com/v2/"
  ),
  "f4c" = list(
    "token_url" = "https://f4c.sbgenomics.com/developer#token",
    "file_url" = "https://f4c.sbgenomics.com/u/",
    "public_app_url" = "https://f4c.sbgenomics.com/public/apps#",
    "wf_url" = "https://f4c.sbgenomics.com/raw/",
    "base_url" = "https://f4c-api.sbgenomics.com/v2/"
  ),
  "cavatica" = list(
    "token_url" = "https://cavatica.sbgenomics.com/developer#token",
    "file_url" = "https://cavatica.sbgenomics.com/u/",
    "public_app_url" = "https://cavatica.sbgenomics.com/public/apps#",
    "wf_url" = "https://cavatica.sbgenomics.com/raw/",
    "base_url" = "https://cavatica-api.sbgenomics.com/v2/"
  )
)

# check if a string follows the format of an api token
is_token <- function(x) nchar(x) == 32L & grepl("[[:alnum:]]", x)
