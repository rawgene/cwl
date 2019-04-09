import subprocess
import filecmp

def test_htseq_prepare_docker():
	subprocess.run(["cwl-runner",
					"--outdir=./test_htseq_prepare",
					"./tools/htseq_prepare.cwl",
					"./tools/htseq_prepare.yml"])
	assert filecmp.cmp("./tests/test.htseq.gff",
						"./test_htseq_prepare/test.gff")

if __name__ == "__main__":
	test_htseq_prepare_docker()
