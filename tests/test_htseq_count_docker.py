import subprocess
import filecmp

def test_htseq_counts_docker():
	subprocess.run(["cwl-runner",
					"--outdir=./test_htseq_counts",
					"./tools/htseq_count.cwl",
					"./tools/htseq_count.yml"])
	assert filecmp.cmp("./tests/hisat2_dexseq/test1_htseq_count.csv",
						"./test_htseq_counts/test1_htseq_count.csv")

if __name__ == "__main__":
	test_htseq_counts_docker()
