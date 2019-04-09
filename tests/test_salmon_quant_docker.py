import subprocess
import filecmp
import csv


def salmon_quant_reader(filepath):
	result = float(list(csv.reader(open(filepath), delimiter="\t"))[1][3])
	return round(result)


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
	ref = salmon_quant_reader("./tests/salmon_quant/test2/quant.sf")
	test = salmon_quant_reader("./test_salmon_quant_pe/test2/quant.sf")
	assert ref == test


if __name__ == "__main__":
	test_salmon_quant_single()
	test_salmon_quant_pe()
