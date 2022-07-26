version 1.0

workflow virusdetection {
  input {
    File fastq1
    File fastq2
  }

  parameter_meta {
    fastq1: "Read 1 fastq file, gzipped. Can be either whole genome or whole transcriptome"
    fastq2: "Read 2 fastq file, gzipped. Can be either whole genome or whole transcriptome."
  }

  meta {
  	author: "Alex Fortuna"
  	email: "afortuna@oicr.on.ca"
  	description: "Perform taxonomic sequence classification on NGS data"
  	dependencies: [
        {
    	    name: "kraken2/2.0.8",
    	    url: "https://ccb.jhu.edu/software/kraken2/index.shtml?t=downloads"
    	}
  	]
  }

  call kraken2 {
    input:
      fastq1 = fastq1,
      fastq2 = fastq2
  }

  output {
    File taxonomicClassification = kraken2.out
  }
}

task kraken2 {
  input {
    String modules = "kraken2/2.0.8 kraken2-database/1"
    File fastq1
    File fastq2
    String kraken2DB = "$KRAKEN2_DATABASE_ROOT/"
    String sample
    Int mem = 8
    Int timeout = 72
  }

  command <<<
    set -euo pipefail

    kraken2 --paired ~{fastq1} ~{fastq2} \
    --db ~{kraken2DB} \
    --report kreport2.txt
  >>>

  runtime {
    memory: "~{mem} GB"
    modules: "~{modules}"
    timeout: "~{timeout}"
  }

  output {
    File out = "kreport2.txt"
  }
}
