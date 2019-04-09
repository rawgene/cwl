import subprocess
import filecmp

def test_salmon_quant_single():
	subprocess.run(["cwl-runner",
					"--outdir=./test_salmon_quant_single",
					"./tools/salmon_quant.cwl",
					"./tools/salmon_quant.single.yml"])
	assert filecmp.cmp("./tests/salmon_quant/test3/quant.sf",
						"./test_salmon_quant_single/test3/quant.sf")

def test_salmon_quant_pe():
	subprocess.run(["cwl-runner",
					"--outdir=./test_salmon_quant_pe",
					"./tools/salmon_quant.cwl",
					"./tools/salmon_quant.yml"])
	assert filecmp.cmp("./tests/salmon_quant/test2/quant.sf",
						"./test_salmon_quant_pe/test2/quant.sf")


if __name__ == "__main__":
	test_salmon_quant_single()
	test_salmon_quant_pe()
