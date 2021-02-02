# crosscheckFingerprints

Checks if all the genetic data within a set of files appear to come from the same individual by using Picard [CrosscheckFingerprints](https://gatk.broadinstitute.org/hc/en-us/articles/360037594711-CrosscheckFingerprints-Picard-)

## Overview

## Dependencies

* [picard 2.21.2](https://broadinstitute.github.io/picard/command-line-overview.html#Overview)
* [crosscheckfingerprints-haplotype-map 20210201](https://github.com/oicr-gsi/fingerprint_maps)


## Usage

### Cromwell
```
java -jar cromwell.jar run crosscheckFingerprints.wdl --inputs inputs.json
```

### Inputs

#### Required workflow parameters:
Parameter|Value|Description
---|---|---
`inputs`|Array[File]|A list of SAM/BAM/VCF files to fingerprint.
`haplotypeMapFileName`|String|The file name that lists a set of SNPs, optionally arranged in high-LD blocks, to be used for fingerprinting.


#### Optional workflow parameters:
Parameter|Value|Default|Description
---|---|---|---
`haplotypeMapDir`|String|"$CROSSCHECKFINGERPRINTS_HAPLOTYPE_MAP_ROOT"|The directory that contains haplotype map files. By default the modulator data directory.
`outputPrefix`|String|"output"|Text to prepend to all output.


#### Optional task parameters:
Parameter|Value|Default|Description
---|---|---|---
`runCrosscheckFingerprints.crosscheckBy`|String|"READGROUP"|Specificies which data-type should be used as the basic comparison unit. Fingerprints from readgroups can be 'rolled-up' to the LIBRARY, SAMPLE, or FILE level before being compared. Fingerprints from VCF can be be compared by SAMPLE or FILE.
`runCrosscheckFingerprints.picardMaxMemMb`|Int|3000|Passed to Java -Xmx (in Mb).
`runCrosscheckFingerprints.exitCodeWhenMismatch`|Int|0|When one or more mismatches between groups is detected, exit with this value instead of 0.
`runCrosscheckFingerprints.exitCodeWhenNoValidChecks`|Int|0|When all LOD score are zero, exit with this value.
`runCrosscheckFingerprints.lodThreshold`|Float|0.0|If any two groups (with the same sample name) match with a LOD score lower than the threshold the tool will exit with a non-zero code to indicate error. Program will also exit with an error if it finds two groups with different sample name that match with a LOD score greater than -LOD_THRESHOLD. LOD score 0 means equal likelihood that the groups match vs. come from different individuals, negative LOD score -N, mean 10^N time more likely that the groups are from different individuals, and +N means 10^N times more likely that the groups are from the same individual.
`runCrosscheckFingerprints.validationStringency`|String|"SILENT"|Validation stringency for all SAM files read by this program. Setting stringency to SILENT can improve performance when processing a BAM file in which variable-length data (read, qualities, tags) do not otherwise need to be decoded. See https://jira.oicr.on.ca/browse/GC-8372 for why this is set to SILENT for OICR purposes.
`runCrosscheckFingerprints.modules`|String|"picard/2.21.2 crosscheckfingerprints-haplotype-map/20210201"|Modules to load for this workflow.
`runCrosscheckFingerprints.additionalParameters`|String?|None|Any additional parameters that need to be passed Picard.
`runCrosscheckFingerprints.threads`|Int|4|Requested CPU threads.
`runCrosscheckFingerprints.jobMemory`|Int|6|Memory (GB) allocated for this job.
`runCrosscheckFingerprints.timeout`|Int|6|Number of hours before task timeout.


### Outputs

Output | Type | Description
---|---|---
`crosscheckMetrics`|File|The crosschecksMetrics file produced by Picard CrosscheckFingerprints
`crosscheckMetricsMatrix`|File|Matrix of LOD scores. This is less informative than the metrics output and only contains Normal-Normal LOD score (i.e. doesn't account for Loss of Heterozygosity.


## Niassa + Cromwell

This WDL workflow is wrapped in a Niassa workflow (https://github.com/oicr-gsi/pipedev/tree/master/pipedev-niassa-cromwell-workflow) so that it can used with the Niassa metadata tracking system (https://github.com/oicr-gsi/niassa).

* Building
```
mvn clean install
```

* Testing
```
mvn clean verify \
-Djava_opts="-Xmx1g -XX:+UseG1GC -XX:+UseStringDeduplication" \
-DrunTestThreads=2 \
-DskipITs=false \
-DskipRunITs=false \
-DworkingDirectory=/path/to/tmp/ \
-DschedulingHost=niassa_oozie_host \
-DwebserviceUrl=http://niassa-url:8080 \
-DwebserviceUser=niassa_user \
-DwebservicePassword=niassa_user_password \
-Dcromwell-host=http://cromwell-url:8000
```

## Support

For support, please file an issue on the [Github project](https://github.com/oicr-gsi) or send an email to gsi@oicr.on.ca .

_Generated with generate-markdown-readme (https://github.com/oicr-gsi/gsi-wdl-tools/)_
