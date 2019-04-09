import subprocess
import filecmp

def test_dexseq_docker():
	subprocess.run(["cwl-runner",
					"--outdir=./test_dexseq",
					"./tools/dexseq.cwl",
					"./tools/dexseq.yml"])
	assert filecmp.cmp("./tests/DEE_results.hisat2_dexseq.csv",
						"./test_dexseq/untreated-treated_DEE_results.csv")

if __name__ == "__main__":
	test_dexseq_docker()
