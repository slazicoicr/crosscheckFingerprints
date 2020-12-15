version 1.0
workflow crosscheckFingerprints {
    input {
        Array[File] inputs
        File haplotypeMap
        String outputPrefix
    }

    parameter_meta {
    }

    meta {
        author: "Savo Lazic"
        email: "savo.lazic@oicr.on.ca"
        description: "This Nextflow pipeline automates the ARTIC network nCoV-2019 novel coronavirus bioinformatics protocol. It will turn SARS-COV2 sequencing data (Illumina or Nanopore) into consensus sequences and provide other helpful outputs to assist the project's sequencing centres with submitting data. Pipeline documentation at https://artic.readthedocs.io/en/latest/minion/."
        dependencies:
        [
            {
                name: "ncov2019-artic-nf-nanopore/20200926",
                url: "https://github.com/connor-lab/ncov2019-artic-nf"
            },
            {
                name: "artic-ncov2019-primer-schemes/20200908",
                url: "https://github.com/artic-network/primer-schemes"
            }
        ]
        output_meta: {
        }
    }

    call runCrosscheckFingerprints {
        input:
            inputs = inputs,
            haplotypeMap = haplotypeMap,
            outputPrefix = outputPrefix
    }

    output {
        File crosscheckMetrics = runCrosscheckFingerprints.crosscheckMetrics
    }
}

task runCrosscheckFingerprints {
    input {
        Array[File] inputs
        File haplotypeMap
        String outputPrefix
        Int picardMaxMemMb = 12000
        Int exitCodeWhenMismatch = 0
        Int exitCodeWhenNoValidChecks = 0
        String modules = "picard/2.21.2"
        String? additionalParameters
        Int threads = 8
        Int jobMemory = 32
        Int timeout = 48
    }
    Array[String] inputCommand = prefix("INPUT=", inputs)

    parameter_meta {
    }

    command <<<
        java -Xmx~{picardMaxMemMb}M \
        -jar ${PICARD_ROOT}/picard.jar \
        CrosscheckFingerprints \
        ~{sep=" " inputCommand} \
        HAPLOTYPE_MAP=~{haplotypeMap} \
        OUTPUT=~{outputPrefix}.crosscheck_metrics.txt \
        NUM_THREADS=~{threads} \
        EXIT_CODE_WHEN_MISMATCH=~{exitCodeWhenMismatch} \
        EXIT_CODE_WHEN_NO_VALID_CHECKS=~{exitCodeWhenNoValidChecks} \
        ~{additionalParameters}
    >>>

    output {
        File crosscheckMetrics = "~{outputPrefix}.crosscheck_metrics.txt"
    }

    meta {
        output_meta: {
        }
    }

    runtime {
        modules: "~{modules}"
        memory:  "~{jobMemory} GB"
        cpu:     "~{threads}"
        timeout: "~{timeout}"
    }
}
