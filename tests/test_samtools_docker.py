import subprocess
import filecmp

def test_samtools_docker():

    subprocess.run(["cwl-runner",
                    "--outdir=./test_samtools",
                    "./tools/samtools.cwl",
                    "./tools/samtools.yml"])

    assert filecmp.cmp("./tests/test1.hisat2.bam", "./test_samtools/test1.bam")


if __name__ == "__main__":
    test_samtools_docker()
